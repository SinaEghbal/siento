%% for a pair of outputs (or ratings) produce reliability and performance
%% measures
function [MaPrecision, MaRecall, MaF1, miPrecision, miRecall, miF1 ] = PerformanceX2(data)

% check data
[x,y] = size(data);
Samples = x;
if y>3
    error('ERROR: too many columns');
end

% create a cross tabulation (contingency table)
% could write support for more raters and it would 
% produce multidimensional contingency table
% rater 1 will be in rows, rater 2 in the columns
ct = crosstab(data(:,2),data(:,3));

% calculate cohen Kappa interrater agreement
kappa(ct)

% If rater1 is system and 2 is truth
[OutClassN, TargetClassN] = size(ct)
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
for j = [1:TargetClassN] % for each target class
    
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
    
    Precision(j) =  a/(a+b);
    Recall(j) = a/(a+c);
    F1(j) = 2*a/(2*a+b+c);
end
    
% calculate micro and macro average for each measure
miPrecision =  aa/(aa+bb);
miRecall = aa/(aa+cc);
miF1 = 2*aa/(2*aa+bb+cc);

MaPrecision = mean(Precision); 
MaRecall = mean(Recall);
MaF1 = mean(F1);

