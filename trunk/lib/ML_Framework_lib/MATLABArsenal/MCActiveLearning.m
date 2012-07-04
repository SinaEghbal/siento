% MCActiveLearning: implementation for active learning meta-classifier
%
% Parameters:
% para: parameters 
%   1. Iter: iteration, default: 10
%   2. IncSize: data size per increment, default: 10
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

function  [Y_compute, Y_prob] = MCActiveLearning(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set)

p = str2num(char(ParseParameter(para, {'-Iter'; '-IncSize'}, {'10';'10'})));
Iteration = p(1);
IncrementSize = p(2);

% If there are no training data, simply pass to the next level
if (isempty(X_train)),
    [Y_compute, Y_prob] = Classify(classifier, X_train, Y_train, X_test, Y_test, num_class, class_set);
    return;
end;

test_index = 1:length(Y_test);
Y_compute = zeros(length(Y_test), 1);
Y_prob = zeros(length(Y_test), 1);
for j = 1:Iteration
    % Classify the data
    [Y_compute_iter, Y_prob_iter] = Classify(classifier, X_train, Y_train, X_test, Y_test, num_class, class_set);
    Y_compute(test_index) = Y_compute_iter;
    Y_prob(test_index) = Y_prob_iter;    
    CalculatePerformance(Y_compute_iter, Y_prob_iter, Y_test, class_set);
    
    % Find the most ambiguous data points
    [junk Index] = sort(abs(Y_prob_iter));
    X_train = [X_train; X_test(Index(1:IncrementSize), :)];
    Y_train = [Y_train; Y_test(Index(1:IncrementSize), :)];
    X_test(Index(1:IncrementSize), :) = []; % Delete the test examples in testing set
    Y_test(Index(1:IncrementSize), :) = []; % Delete the test examples in testing set
    test_index(Index(1:IncrementSize)) = [];  
end;
