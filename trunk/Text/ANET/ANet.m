clear global all;
clear all;

%mode =0 only calculation
%mode =1 graphical!
mode = 0;

%read data from ANew database
AnewDataReader;

%read data from ANet database
AnetDataReader;

emotionsMaker;

total_distance = [0 0 0] ;
classification_result  = zeros(length(ANET_No) - 1, 3);

% for each sentence in the db 
count = 0;
for jj = [2:length(ANET_No)]
%Calculating coordinates for the sentence 
sen = char(ANET_sentence_stem(jj));
sen = regexprep(sen, ',', '');
sen = regexprep(sen, '\.', '');
input = regexp(sen, ' ', 'split');

aX = str2num(cell2mat(ANET_val(jj)));
aY = str2num(cell2mat(ANET_aro(jj)));
aZ = str2num(cell2mat(ANET_dom(jj)));
[rx ry rz] = weightVAD(input);
if (rx+ ry+ rz == 0) 
    continue 
end
if (mode ~= 1)
    total_distance = total_distance + ([rx ry rz] - [aX aY aZ]).^2
    count = count + 1;
end

if (mode == 1)
    dis_real_anet = sqrt((rx-aX)^2+(ry-aY)^2+(rz-aZ)^2);
    subplot(1,1,1)
    plot3(aX, aY, aZ,'o','Color' ,'red');
    title(char(ANET_sentence(jj)));

    text(aX-.3,aY+.3, aZ+.3,'ANET', 'Color' ,'red');
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


for emo=1:length(emotions)
    tmp = char(emotions(emo));
    name = strcat(tmp, '_stem');
    [ex ey ez] = weightVAD(eval(name));
    if (mode == 1)
        plot3([ex, ex- .00001], [ey , ey-.00001], [0,ez],':','Color',[.8 .8 .8]);
        plot3([ex, ex- .00001], [0, ey], [ez , ez-.00001],':','Color',[.8 .8 .8]);
        plot3([0, ex], [ey , ey-.00001], [ez , ez-.00001],':','Color',[.8 .8 .8]);
    
        
        plot3(ex, ey, ez, 'X');
        text(ex-.3,ey+.3, ez+.3,emotions(emo));
    end%if (mode == 1)
    
    distance_output(emo) = sqrt((rx-ex)^2+(ry-ey)^2+(rz-ez)^2);
    distance_target(emo) = sqrt((aX-ex)^2+(aX-ey)^2+(aX-ez)^2);
    %text((rx+ex)/2,(ry+ey)/2,(rz+ez)/2,strcat('\leftarrow',num2str(distance,2)),'HorizontalAlignment','left');
end %emo=1:length(emotions)

[sorted_dis_out inx_out] = sort(distance_output);
[sorted_dis_trg inx_trg] = sort(distance_target);
if (mode == 1)
    hold off;

    gcs1=axes('position',[.8  .1  .195  .8]);
    set(gcs1,'xtick',[])
    set(gcs1,'ytick',[])

    for emo=1:length(emotions)
        if (emo == 1)
            color = [.6 .2 .4];
        else
            color = 'black' ;   
        end
        text(.05, 1 - emo/10 , emotions(inx_out(emo)),'Color',color);
        text(.6, 1 - emo/10 , '=','Color',color);
        text(.7, 1 - emo/10 , num2str(sorted_dis_out(emo),3),'Color',color);
    end%emo=1:length(emotions)
    emo = emo + 2;
    color = [.2 .2 .5];
    text(.05, 1 - emo/10 , {'Text-2-ANET' },'Color',color);
    text(.7, 1 - emo/10 , '=','Color',color);
    text(.8, 1 - emo/10 , num2str(dis_real_anet,3),'Color',color);
    
    waitforbuttonpress;
end    %if (mode == 1)
if (mode ~= 1)
    classification_result(jj-1,1) = str2num(cell2mat(ANET_No(jj)));
    classification_result(jj-1,2) = inx_out(1);
    classification_result(jj-1,3) = inx_trg(1);
end

end %jj = [2:length(ANET_No)]

classification_result_noZero = classification_result(sum(classification_result')~=0 , :); 

csvwrite('Anew-Anet-results.csv',classification_result_noZero);


RMSE = sqrt(total_distance / count)




