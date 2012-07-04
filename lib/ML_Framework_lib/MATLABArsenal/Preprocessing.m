% Preprocessing: preprocess the data
%
% Parameters:
% D: entire data collection
%
% Output parameters:
% X: features
% Y: labels
% orgY: original labels
% num_data: number of data
% num_features: number of features
%

function [X, Y, orgY, num_data, num_feature] = Preprocessing(D)

global preprocess;

% Data sampling (outdated) 
if ((preprocess.DataSampling == 1) & (preprocess.DataSamplingRate > 0))
    [num_data, num_feature] = size(D);
    Index = mod(1:num_data, preprocess.DataSamplingRate);
    D = D(Index == fix((preprocess.DataSamplingRate - 1)/2), :);      
end;

% Get the number of feature and data
[num_data, num_feature] = size(D);

% Convert NaN to 0 
if (any(any(isnan(D))) == 1),
	fprintf('Warning: the raw data contains NaN values! \n');
	D(isnan(D)) = 0; 
end;

% randomize the data
if (preprocess.Shuffled == 1) %Shuffle the datasets
    Vec_rand = rand(num_data, 1);
    [B, Index] = sort(Vec_rand);
    D = D(Index, :);
    preprocess.shuffleindex = Index;
end;

% Extract Shot ID information
if (preprocess.ShotAvailable == 1) 
    preprocess.ShotInfo = D(:, num_feature:num_feature);
    preprocess.ShotIDSet = unique(preprocess.ShotInfo);
    ShotIDSet = preprocess.ShotIDSet;
    D = D(:, 1:num_feature-1);
    num_feature = num_feature - 1;
    fprintf('Shot Number: %d\n', length(unique(preprocess.ShotInfo)));
    
    % Extract the key frame
    if ((preprocess.DataSampling == 1) & (preprocess.DataSamplingRate <= 0)) 
        D_sampling = zeros(length(ShotIDSet), num_feature);
        for j = 1:length(ShotIDSet)
            D_shotID = D(preprocess.ShotInfo == ShotIDSet(j), :);
            med = fix((sum(preprocess.ShotInfo == ShotIDSet(j)) + 1)/2);
            D_sampling(j, :) = D_shotID(med, :);
            D_sampling(j, num_feature) = D_shotID(med, num_feature);
        end;
        D = D_sampling;
        clear D_sampling;
        
        [num_data, num_feature] = size(D);
        preprocess.ShotInfo = preprocess.ShotIDSet;
        fprintf('Data Number: %d, Feature Number: %d\n', num_data, num_feature);
    end;    
end;

% Partition the data collection
actual_num_class = preprocess.ActualNumClass;
num_feature = num_feature - actual_num_class;
X = D(:, 1:num_feature);
Y = full(D(:, num_feature+1:num_feature + actual_num_class));
orgY = Y;
clear D;

% Obtain the class set
if (~isfield(preprocess, 'OrgClassSet') | isempty(preprocess.OrgClassSet)),
    class_set = unique(Y); 
    % If only one type of labels exists, make the set of labels to be two
    if (length(class_set) == 1), 
        if (class_set == 1), 
            class_set = [1 2]; 
        else
            class_set = [1 class_set];
        end;
    end;
    % Assume the class(1) is the positive class
    if (all(class_set ~= 1)), error('1 must be the positive label!\n'); end;
    class_set(class_set == 1) = []; 
    class_set = [1; class_set];
    preprocess.OrgClassSet = class_set;
else
    class_set = preprocess.OrgClassSet; % Allow users to assign the labels     
end;

% Print the dataset statistics
fprintf('Data Number: %d, Feature Number: %d, Data per Class: ', num_data, num_feature);
for i = 1:length(class_set), 
    fprintf('(%d,%d) ', class_set(i), sum(Y == class_set(i))); 
end;
fprintf('\n');

% Convert labels to continuous value
Y_dup = Y;
for i = 1:length(class_set)
    Y_dup(Y == class_set(i)) = i;    
end;
Y = Y_dup;
preprocess.ClassSet = (1:length(class_set))';

% Normalize the data set
if (preprocess.Normalization == 1) 
    % Variance normalization
    mCov = std(X);
    mCov(mCov == 0) = 1;
    X = X ./ repmat(mCov, num_data, 1);
elseif (preprocess.Normalization == 2)
    % 0-1 normalization
    maxX = repmat(max(X), num_data, 1);
    minX = repmat(min(X), num_data, 1);
    X = (X - minX) ./ (maxX - minX);
end;

% Dimension Reduction using SVD
if ((preprocess.SVD > 0) & (num_feature > preprocess.SVD)) % SVD reduction
    SVD_dimension = preprocess.SVD;
    fprintf('SVD: reduce to %d dimension\n', SVD_dimension);
    [U, S, V] = svds(X', SVD_dimension);
    X = X * U;
    num_feature = SVD_dimension;
    if (~isempty(preprocess.DimReductionFile)),
        fprintf('Write to file %s\n', preprocess.DimReductionFile);
        dlmwrite(preprocess.DimReductionFile, [X Y]);    
    end;
end;

% Dimension Reduction using Latent Dirichlet Allocation
% Assume the data takes {0,1} values
if ((preprocess.LDirAlloc > 0) & (num_feature > preprocess.LDirAlloc)) % SVD reduction
    LDA_dimension = preprocess.LDirAlloc;
    fprintf('LDirAlloc: reduce to %d dimension\n', LDA_dimension);  
    X =  LatentDirAlloc(X, LDA_dimension);
    num_feature = LDA_dimension;
    if (~isempty(preprocess.DimReductionFile)),
        fprintf('Write to file %s\n', preprocess.DimReductionFile);
        dlmwrite(preprocess.DimReductionFile, [X Y]);    
    end;
end;
 
% Chi-square feature selection, only for binary classification
if (preprocess.ChiSquare > 0) & (length(preprocess.OrgClassSet) == 2),  
   for  i = 1:num_feature,
        datamean = mean(X(:, i));
        train_pos = sum(X(Y == class_set(1), i) >= datamean);
        train_neg = sum(X(Y ~= class_set(1), i) >= datamean);
        train_all = train_pos + train_neg;
        ntrain_pos = sum(X(Y == class_set(1), i) < datamean);
        ntrain_neg = sum(X(Y ~= class_set(1), i) < datamean);
        ntrain_all = ntrain_pos + ntrain_neg;
        if (train_all == 0), fprintf('Error: in Chi squared feature selection\n'); continue; end;
        if (ntrain_all == 0), fprintf('Error: in Chi squared feature selection\n'); continue;  end;
        truth_pos_per = sum(Y == class_set(1)) / num_data;
        truth_neg_per = sum(Y ~= class_set(1)) / num_data;
        truth_pos_per = (truth_pos_per == 0) * 1e-5 + truth_pos_per;
        truth_neg_per = (truth_neg_per == 0) * 1e-5 + truth_neg_per;
        chi(i) = (train_pos - train_all * truth_pos_per) ^ 2 / (train_all * truth_pos_per) + (train_neg - train_all * truth_neg_per) ^ 2 / (train_all * truth_neg_per) ...
               + (ntrain_pos - ntrain_all * truth_pos_per) ^ 2 / (ntrain_all * truth_pos_per) + (ntrain_neg - ntrain_all * truth_neg_per) ^ 2 / (ntrain_all * truth_neg_per);
   end;
   fprintf('Chi squared: '); fprintf('%.3f, ', chi); fprintf('\n');
   X = X(:, chi >= preprocess.ChiSquare);
   num_feature = size(X, 2);
end;

% read the constraints
if (preprocess.ConstraintAvailable == 1) & (preprocess.ShotAvailable == 1),  
    constraintMap = dlmread(preprocess.ConstraintFileName, ',');
    preprocess.constraintMap = constraintMap;
    preprocess.ConPair1 = []; preprocess.ConPair2 = []; preprocess.LabelPair = [];
    for j = 1:size(constraintMap, 1),
           preprocess.ConPair1(j, :) = mean(X(preprocess.ShotInfo == constraintMap(j, 1), :), 1);
           preprocess.ConPair2(j, :) = mean(X(preprocess.ShotInfo == constraintMap(j, 2), :), 1);
           preprocess.LabelPair(j) = constraintMap(j, 3);
    end;
    preprocess.constraintUsed = ones(size(constraintMap, 1), 1);
end;