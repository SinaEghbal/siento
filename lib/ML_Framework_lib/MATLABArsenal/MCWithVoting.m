% MCWithVoting: implementation for meta-classification with majority voting 
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

function  [Y_compute, Y_prob] = MCWithVoting(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set)

p = str2num(char(ParseParameter(para, {'-PosRatio'}, {'0.5'})));
sizefactor = p(1);

if (num_class ~= 2), 
    fprintf('Error: The number of classes is larger than 2!');
    return;
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
       
downsize = fix((1 - sizefactor) / sizefactor * num_positive);
num_group = fix(num_negative / downsize);
downsize = fix(num_negative / num_group);

Y_all = zeros(size(Y_test, 1), 1);
for i = 1:num_group
    data_additional = data_neg(floor((i-1)*num_negative/num_group)+1 : floor(i*num_negative/num_group), :);
    X_train = [data_pos; data_additional];
       
    label_pos = ones(size(data_pos, 1), 1) * class_set(1);
    label_additional = ones(size(data_additional, 1), 1) * class_set(2);
    Y_train = [label_pos; label_additional];
    
    [Y_compute Y_prob] = Classify(classifier, X_train, Y_train, X_test, Y_test, num_class, class_set);
    Y_all = Y_all + (Y_compute == class_set(1));    
end;

Y_compute = (Y_all > num_group / 2) * class_set(1) + (Y_all <= num_group / 2) * class_set(2);