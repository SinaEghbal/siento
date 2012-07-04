% MCBagging: implementation for Bagging meta-classifier
%
% Parameters:
% classifier: base classifier 
% para: parameters 
%   1. Iter: number of iteration, default: 10
%   2. SampleRatio: bootstrap sample ratio, default: 1
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
% ParseParameter, CalculatePerformance, Classify

function [Y_compute, Y_prob] = MCBagging(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set)

rand('state', 1);
p = str2num(char(ParseParameter(para, {'-Iter';'-SampleRatio'}, {'10';'1'})));
num_sample = p(1);
sample_ratio = p(2);

X_Sample = X_train;
Y_Sample = Y_train;
Y_compute_train_matrix = zeros(length(Y_train), num_class);
Y_compute_test_matrix = zeros(length(Y_test), num_class);

for iter = 1:num_sample,    
    % Sample data and retrain the model
    fprintf('Sample %d............\n', iter);
    X_Sample = []; 
    Y_Sample = [];
    if (~isempty(X_train)), 
        while (length(unique(Y_Sample)) < num_class), 
            num_samples = ceil(length(Y_train) * sample_ratio);
            dist = ones(length(Y_train), 1) ./ length(Y_train);
            sample_idx = SampleDistribution(dist, num_samples);
            X_Sample = X_train(sample_idx, :);
            Y_Sample = Y_train(sample_idx);
        end;      
    end;
    
    % Compute the predictions and voting
    Y_compute_test = Classify(classifier, X_Sample, Y_Sample, X_test, Y_test, num_class, class_set);    
    for i = 1:num_class, 
        % Majority voting
        ind = find(Y_compute_test == class_set(i));
        Y_compute_test_matrix(ind, i) = Y_compute_test_matrix(ind, i) + 1 / num_sample;
    end;
    [Y_prob Index] = max(Y_compute_test_matrix, [], 2);
    Y_compute = class_set(Index);
    CalculatePerformance(Y_compute, Y_prob, Y_test, class_set);    
end
if (num_class == 2), 
    Y_prob = Y_compute_test_matrix(:, 1);
end;

% Sample the data based on pdf and output the index
function ret_vec = SampleDistribution(pdf, num_samples)

CumDist = cumsum(pdf);
Diff = CumDist * ones(1, num_samples) - ones(length(pdf), 1) * rand(1, num_samples);
Diff = (Diff <= 0) * 2 + Diff;
[C, I] = min(Diff);
ret_vec = I';

