% MCWithMultiFSet: implementation for meta-classification on seperate
% groups of features (i.e., a late fusion strategy)
%
% Parameters:
% classifier: base classifier 
% para: parameters 
%   1. Voting: use majority voting or sum rule, default: 1
% X_train: training examples
% Y_train: training labels
% X_test: testing examples
% Y_test: testing labels 
% num_class: number of classes
% class_set: set of class labels such as [1,-1], the first one is the
% positive label
%
% Output parameters:
% Y_compute: the predicted labels
% Y_prob: the prediction confidence in [0,1]
%
% Require functions: 
% ParseParameter, Classify

function [Y_compute, Y_prob] = MCWithMultiFSet(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;

% Parse the parameters
% -Separator defines the starting and ending points of feature groups
p = str2num(char(ParseParameter(para, {'-Voting'}, {'1'})));
bVoting = p(1);
p = char(ParseParameter(para, {'-Separator'}, {'0'}));
if (~isfield(preprocess, 'FeatureSet')),
   Separator = sscanf(p, '%d,');
   Separator = reshape(Separator', 2, [])';
   len = size(Separator, 1);
   preprocess.FeatureSet = zeros(len, size(Y_train, 2));
   for i = 1:len,
        preprocess.FeatureSet(i, Separator(i, 1):Separator(i, 2)) = 1;    
   end;
end;

if ((bVoting == 0) && (num_class ~= 2)), 
    fprintf('Error: The number of classes is larger than 2!');
    return;
end;

num_feature_set = size(preprocess.FeatureSet, 1);
num_test = size(Y_test, 1);
num_train = size(Y_train, 1);
num_data = size(Y_test, 1) + size(Y_train, 1);
Y_prob_array = zeros(num_data, num_feature_set);
Y_compute_array = zeros(num_data, num_feature_set);

% If there are no training data, simply pass to the next level
if (isempty(X_train)),
    for i = 1:num_feature_set,
        feature_set = find(preprocess.FeatureSet(i, :) > 0);
        [Y_compute Y_prob] = Classify(classifier, [], [], X_test(:, feature_set), Y_test, num_class, class_set);
        Y_prob_array(:, i) = Y_prob;
        Y_compute_array(:, i) = Y_compute;
    end;
else
    for i = 1:num_feature_set
        fprintf('Evaluating feature set %d\n', i);
        feature_set = find(preprocess.FeatureSet(i, :) > 0);
        X_test_new = [X_train(:, feature_set); X_test(:, feature_set)];
        Y_test_new = [Y_train(:); Y_test(:)];
        X_train_new = X_train(:, feature_set);
        Y_train_new = Y_train(:);

        [Y_compute Y_prob] = Classify(classifier, X_train_new, Y_train_new, X_test_new, Y_test_new, num_class, class_set);
        Y_prob_array(:, i) = Y_prob;
        Y_compute_array(:, i) = Y_compute;
    end;
end;

if ((bVoting == 0) & (num_class == 2)),
    % Majority voting
    % Convert back to the probability of class 1, when the number of classes is 2
    Y_prob_array = Y_prob_array .* (Y_compute_array == 1) + (1 - Y_prob_array) .* (Y_compute_array ~= 1); 
    [junk Index] = sort(-Y_prob_array, 1);
    Y_rank_score = zeros(num_data, num_feature_set);
    for i = 1:num_feature_set
        Y_rank_score(Index(:,i), i) = (1:num_data)';    
        Y_rank_score(Y_prob_array(:,i) == max(Y_prob_array(:,i)), i) = 1;
        Y_rank_score(Y_prob_array(:,i) == min(Y_prob_array(:,i)), i) = num_data;    
    end;
    Y_rank_score = 1 - Y_rank_score / num_data;
    % Y_prob_train = Y_rank_score(1:size(Y_train, 1), :);
    Y_prob_test = Y_rank_score(size(Y_train, 1)+1:num_data, :);
    Y_prob = sum(Y_prob_test, 2) / num_feature_set;

    threshold = 0.5;
    Y_compute = class_set(1) * (Y_prob >= threshold) + class_set(2) * (Y_prob < threshold);
else,
    % SUM rule
    Y_train_compute_array = Y_compute_array(size(Y_train, 1)+1:num_data, :);
    n = histc(Y_train_compute_array, class_set', 2);
    [junk, index] = max(n, [], 2);
    Y_compute = class_set(index);
    Y_prob_array = Y_prob_array(size(Y_train, 1)+1:num_data, :);
    Y_prob_array(Y_train_compute_array ~= repmat(Y_compute, 1, num_feature_set)) = 0;
    Y_prob = mean(Y_prob_array, 2);
end;

