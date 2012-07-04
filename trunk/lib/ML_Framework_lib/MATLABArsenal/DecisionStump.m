% DecisionStump: implementation for decision stump
%
% Parameters:
% para: parameters 
%   1. CostFactor: weighting between postive data and negative data, default: 1
%   2. Threshold: decision threshold for posterior probability, default: 0
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
% ParseParameter, GetModelFilename, optstumps

function [Y_compute, Y_prob] = DecisionStump(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;

Y_compute = zeros(size(Y_test)); 
Y_prob = zeros(size(Y_test));
if (num_class > 2)
    error('Error: The class number is larger than 2!');
end;

p = str2num(char(ParseParameter(para, {'-CostFactor'; '-Threshold'}, {'1';'0'}, 1)));
costfactor = p(1);
threshold = p(2);

X_train_ext = X_train;
X_test_ext = X_test;

beta = [];
if (~isempty(X_train)),
    % Convert the binary labels into 1, 0
    Y_train = (Y_train == class_set(1));
    weights = (Y_train == 1) * costfactor + (Y_train == 0);
    [bestaxis, bestthresh, bestsign] = optstumps(X_train', Y_train', weights');
    if (preprocess.Verbosity > 1), 
        fprintf('bestaxis: %d, bestthresh: %f, bestsign: %d \n', bestaxis, bestthresh, bestsign);
    end;
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'bestaxis', 'bestthresh', 'bestsign');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    bestaxis = model.bestaxis;
    bestthresh = model.bestthresh;
    bestsign = model.bestsign;
    clear model;    
end;
Y_pred = ((X_test(:, bestaxis)-bestthresh) * bestsign <= threshold);
Y_compute = (Y_pred == 1) * class_set(1) + (Y_pred == 0) * class_set(2);
Y_prob = (Y_pred == 1) * 0.9 + (Y_pred == 0) * 0.1;
