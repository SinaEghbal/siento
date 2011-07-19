function [y, W] = aubt_fisher (data, cs, dim)
% Projects the data into a less dimensional space using fisher-transformation.
%
%  [y, W] = fisher (data, cs, dim)
%   
%   input:
%   data:   feature matrix (one sample per row)
%   cs:     label vector
%   dim:    the dimension of the new space
%
%   output:
%   y:      transformed data
%   W:      the projection matrix
%
%   2005, Johannes Wagner <go.joe@gmx.de>

F = size (data, 2); % features
D = size (data, 1); % records
C = max (cs); % classes

for i = 1:C
    meanFeatC(i, :) = mean (aubt_getClassData (data, cs, i), 1); % mean feature-vector for each class
end
meanFeat = mean (meanFeatC, 1); % mean feature-vector for all classes

Sw = zeros (F, F); % within-class scatter
for i = 1:D  
   tmp = data(i,:) - meanFeatC(cs(i),:);
   Sw = Sw + tmp'*tmp;
end

Sb = zeros (F, F); % between-class scatter
for i = 1:C
    tmp = meanFeatC(i,:) - meanFeat;
    Sb = Sb + tmp'*tmp;
end

[V, E] = eig (pinv(Sw)*Sb); % eigenvalues
W = V(:,1:dim); % projection matrix

y = zeros (D, dim); % reduce data onto the classifier space
for i = 1:D
    y(i,:) = data(i,:) * W;
end
%% normalization in the range [0,1]
y = real (y);
for i = 1:size (y,2)
    y(:,i) = aubt_rangeNorm (y(:,i), 0, 1);
end
end