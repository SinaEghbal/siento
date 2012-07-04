% MCDownSampling: implementation for down sampling
%
% Parameters:
% classifier: base classifier 
% para: parameters 
%   1. PosRatio: ratio of positive examples after sampling, default: 10
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

function [Y_compute, Y_prob] = MCDownSampling(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set)

p = str2num(char(ParseParameter(para, {'-PosRatio'}, {'0.5'})));
sizefactor = p(1);

if (num_class ~= 2), 
    error('Error: The number of classes is larger than 2!');
end;

% If there are no training data, simply pass to the next level
if (isempty(X_train)),
    [Y_compute, Y_prob] = Classify(classifier, X_train, Y_train, X_test, Y_test, num_class, class_set);
    return;
end;

% Collect the positive and negative data
data_neg = X_train(Y_train ~= class_set(1), :);
data_pos = X_train(Y_train == class_set(1), :);
num_positive = size(data_pos, 1);
num_negative = size(data_neg, 1);

% Down sample the negative data
downsize = fix((1 - sizefactor) / sizefactor * num_positive);
rand_index = fix(rand(1, downsize) * num_negative) + 1;
data_additional = data_neg(rand_index, :);     
X_train = [data_pos; data_additional];

label_pos = ones(num_positive, 1) * class_set(1);
label_additional = ones(size(data_additional, 1), 1) * class_set(2);
Y_train = [label_pos; label_additional];       

% Classification
[Y_compute, Y_prob] = Classify(classifier, X_train, Y_train, X_test, Y_test, num_class, class_set);