function  [Performance_Measures, Performance_Measures1, ...
                ConfusionMatrix, KResults,AllResults]= confm (NLAB_OUT,D)
Label_List = getlablist(D);
if isnumeric(Label_List)
    
    for i=1:length(Label_List)
     Label_List1{i} = num2str(Label_List(i));    
    end
    Label_List = Label_List1';
else
Label_List = cellstr(Label_List);
end

nlabels = getnlab(D);
slabels = num2cell(nlabels);
sNLAB_OUT = num2cell(NLAB_OUT);

for i=1:length(Label_List)
    for j=1:length(slabels)
        if (slabels{j} == i)
            slabels{j}= Label_List{i};
        end
        if(sNLAB_OUT{j} == i)
            sNLAB_OUT{j}= Label_List{i};
        end
    end
end

[C,NE,LABLIST] = confmat(slabels,sNLAB_OUT);

[n m] = size(C);
if ( n ~= m) 
   ncol = m;
for i=1:length(LABLIST)
   summm = 0;
    for j=1:length(sNLAB_OUT)
        if(  strcmp(LABLIST{i},sNLAB_OUT{j} ))
            summm = summm +1;
        end
    end
    if(summm ==0)
    C(:,i+1:ncol+1)= C(:,i:ncol);
    ncol= ncol+1;
    C(:,i)= 0;
    end   
end
end

 
    ct = C;

% calculate cohen Kappa interrater agreement
 [KResults,kappameasure] = kappa1(ct);

% If rater1 is system and 2 is truth
[OutClassN, TargetClassN] = size(ct);
if ( OutClassN ~= TargetClassN) 
    warn('Different number of targets and outputs')
end

% calculate contingency table for each class:
%                   Correct=Y   Correct=N
%             +-----------+-----------+
%  Assigned=Y |     a     |     b     |
%             +-----------+-----------+
%  Assigned=N |     c     |     d     |
%             +-----------+-----------+

aa = 0; bb= 0; cc=0; dd=0;
for j = 1:TargetClassN % for each target class
    
    a = ct(j,j); % categ i was target AND system output
    aa = aa + ct(j,j);       % for macro
    b = 0; c=0; d=0; % initialize for micro
     
    for i = [1:j-1 j+1:OutClassN]
        % b = false positive, should NOT have been but were.
        b = b + ct(j,i);
        bb = b + ct(j,i);    % for macro
        % c: false negative, should have been but were not
        c = c + ct(i,j);
        cc = cc + ct(i,j);   % for macro
        % correct negative
        d = d + ct(i,i);
        dd = dd + ct(i,i); % for macro
    end
    
    if ~isnan(a/(a+b)) Precision(j) =a/(a+b); else Precision(j)=0; end
    if ~isnan(a/(a+c)) Recall(j)= a/(a+c); else Recall(j)=0; end
    if ~isnan(2*a/(2*a+b+c)) F1(j)=2*a/(2*a+b+c); else F1(j)=0;end
end
    
% calculate micro and macro average for each measure
accuracy = trace(C)/sum(sum(C));
miPrecision =  aa/(aa+bb);
miRecall = aa/(aa+cc);
miF1 = 2*aa/(2*aa+bb+cc);

MaPrecision = mean(Precision);
MaRecall = mean(Recall);
MaF1 = mean(F1);


Performance_Measures = strvcat(...
    'Class           Precision          Recall        F1',...
 '=========================================');

for i=1:length(LABLIST)

    Row = sprintf('%s \t%5.3f \t%5.3f \t%5.3f', ...
                   LABLIST{i},Precision(i),Recall(i),F1(i))
    Performance_Measures = strvcat(Performance_Measures, Row)
end
Performance_Measures = {Performance_Measures}

Performance_Measures1 = {
sprintf('\nAccuracy :\t \t %6.3f %%', accuracy*100); ...
sprintf('miPrecision :\t \t %6.3f',miPrecision); ...
sprintf('miRecall :\t \t %6.3f',miRecall);...
sprintf('miF1 :\t \t %6.3f',miF1);...
sprintf('MaPrecision :\t \t %6.3f',MaPrecision); ...
sprintf('MaRecall :\t \t %6.3f',MaRecall);...
sprintf('MaF1 :\t \t %6.3f\n',MaF1); KResults}


ConfusionMatrix = sprintf('True\t|  Estimated Labels \nLabels \t|')
classnames = '';
shortnames = {'a','b','c','d','e','f','g','h','i','j','k','l','m',...
    'n','o','p','q','r','s','t','u','v','w','x','y','z'};
for i=1:length(LABLIST)
%     classname = sscanf(LABLIST{i}, '%c',9);
%     classnames = [classnames sprintf('%s\f\f',classname)];
    
    classname = sscanf(shortnames{i}, '%c',9);
    classnames = [classnames sprintf(' %s\f\f\f\f',classname)];
end
ConfusionMatrix = [ConfusionMatrix classnames sprintf('\t| %s','Total')]
ns(1:(length(ConfusionMatrix)-10)) = '-';
ConfusionMatrix = strvcat(ConfusionMatrix, ....
    sprintf('------------------|%s',ns)) 

for i=1:length(LABLIST)
    classname = sscanf(LABLIST{i}, '%c',9);
    Row = [sprintf('%s',classname) ...
           sprintf(' = %c\t|',shortnames{i})]
          Row1='';
          for j=1:length(LABLIST) 
           Row1= [Row1 sprintf('%4.0f\f\f\f',  ct(i,j))];
          end
          Row = [Row ,Row1, sprintf('\t| %4.0f',sum(ct(i,:)))];
    ConfusionMatrix = strvcat(ConfusionMatrix, Row)
end
ConfusionMatrix = strvcat(ConfusionMatrix, ...
    sprintf('------------------|%s',ns)) 
Row = [sprintf('%s\t|','Total'),...
    sprintf('%4.0f\f\f\f',sum(ct)), sprintf('| %3.0f \n',sum(sum(ct)))]
ConfusionMatrix = strvcat(ConfusionMatrix, Row)
ConfusionMatrix= {ConfusionMatrix};


AllResults = {accuracy,miPrecision,miRecall,miF1,MaPrecision,MaRecall,MaF1,...
              kappameasure,Precision,Recall,F1};
end