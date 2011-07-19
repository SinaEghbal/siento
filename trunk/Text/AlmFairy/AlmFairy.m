%clear global all;
clear all;

%mode =0 only calculation
%mode =1 graphical!
mode = 0;

%read data from ANew database
AnewDataReader;

%read data from AlmFairy database
AlmFairyDataReader;

emotionsMaker;

total_distance = [0 0 0] ;  
classification_result  = zeros(length(AlmFairy_sid), 3);

% for each sentence in the db 
count = 0;
for jj = [1:length(AlmFairy_sid)]
%Calculating coordinates for the sentence 
sen = char(AlmFairy_sentence_stem(jj));
sen = regexprep(sen, ',', '');
sen = regexprep(sen, '\.', '');
sen = regexprep(sen, '?', '');
input = regexp(sen, ' ', 'split');

Alm_emo = str2num(cell2mat(AlmFairy_emo(jj)));
%which emotion!
Alm_emo_str = char(AlmFairy_emotions(AlmFairy_emotions_codes == Alm_emo));
name = strcat(Alm_emo_str, '_stem');
%pre-class value
[aX aY aZ] = weightVAD(eval(name));

%assigned class value
[rx ry rz] = weightVAD(input);
if (rx+ ry+ rz == 0) 
    continue 
end
if (mode ~= 1)
    total_distance = total_distance + ([rx ry rz] - [aX aY aZ]).^2
    count = count + 1;
end

if (mode == 1)
    dis_real_AlmFairy = sqrt((rx-aX)^2+(ry-aY)^2+(rz-aZ)^2);
    subplot(1,1,1)
    plot3(aX, aY, aZ,'o','Color' ,'red');
    title(char(AlmFairy_sentence(jj)));

    %text(aX-.3,aY+.3, aZ+.3,'AlmFairy', 'Color' ,'red');
    
    %grid on
    %legend on
    axis square
    hold on;
    axis([1 9 1 9 1 9]);
    xlabel('Valence');
    ylabel('Arousal ');
    zlabel('Dominance');

    %Plotting Default Anet values
    plot3([aX, aX- .00001], [aY , aY-.00001], [0,aZ], 'red');
    plot3([aX, aX- .00001], [0, aY], [aZ , aZ-.00001],'red');
    plot3([0, aX], [aY , aY-.00001], [aZ , aZ-.00001], 'red');


    %Plotting Colculated Text values
    plot3(rx, ry, rz,'o');
    plot3(rx, ry, rz,'x');
    text(rx-.3,rz+.3, ry+.3,'txt', 'Color' ,'blue');
    
    plot3([rx, rx- .00001], [ry , ry-.00001], [0,rz], 'blue');
    plot3([rx, rx- .00001], [0, ry], [rz , rz-.00001],'blue');
    plot3([0, rx], [ry , ry-.00001], [rz , rz-.00001], 'blue');

end%if (mode == 1)

for emo=1:length(AlmFairy_emotions)
    tmp = char(AlmFairy_emotions(emo));
    name = strcat(tmp, '_stem');
    [ex ey ez] = weightVAD(eval(name));
    if (mode == 1)
        plot3([ex, ex- .00001], [ey , ey-.00001], [0,ez],':','Color',[.8 .8 .8]);
        plot3([ex, ex- .00001], [0, ey], [ez , ez-.00001],':','Color',[.8 .8 .8]);
        plot3([0, ex], [ey , ey-.00001], [ez , ez-.00001],':','Color',[.8 .8 .8]);
    
        
        plot3(ex, ey, ez, 'X');
        text(ex-.3,ey+.3, ez+.3,AlmFairy_emotions(emo));
    end%if (mode == 1)
    
    distance(emo) = sqrt((rx-ex)^2+(ry-ey)^2+(rz-ez)^2);
    %text((rx+ex)/2,(ry+ey)/2,(rz+ez)/2,strcat('\leftarrow',num2str(distance,2)),'HorizontalAlignment','left');
end %emo=1:length(emotions)

    [sorted_dis inx] = sort(distance);

if (mode == 1)
    hold off;

    gcs1=axes('position',[.8  .1  .195  .8]);
    set(gcs1,'xtick',[])
    set(gcs1,'ytick',[])

    for emo=1:length(AlmFairy_emotions)
        if (emo == 1)
            color = [.6 .2 .4];
        else
            color = 'black' ;   
        end
        text(.05, 1 - emo/10 , AlmFairy_emotions(inx(emo)),'Color',color);
        text(.6, 1 - emo/10 , '=','Color',color);
        text(.7, 1 - emo/10 , num2str(sorted_dis(emo),3),'Color',color);
    end%emo=1:length(emotions)
    emo = emo + 2;
    color = [.2 .2 .5];
    text(.05, 1 - emo/10 , {'Text-2-AlmFairy' },'Color',color);
    text(.7, 1 - emo/10 , '=','Color',color);
    text(.8, 1 - emo/10 , num2str(dis_real_AlmFairy,3),'Color',color);
    
    waitforbuttonpress;
end    %if (mode == 1)
if (mode ~= 1)
    classification_result(jj,1) = str2num(cell2mat(AlmFairy_sid(jj)));
    classification_result(jj,2) = AlmFairy_emotions_codes(inx(1));
    classification_result(jj,3) = Alm_emo;
end

end %jj = [2:length(ANET_No)]

classification_result_noZero = classification_result(sum(classification_result')~=0 , :); 


csvwrite('Anew-AlmFairy-results.csv',classification_result_noZero);

RMSE = sqrt(total_distance / count)

