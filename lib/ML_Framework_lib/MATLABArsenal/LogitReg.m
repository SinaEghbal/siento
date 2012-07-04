% LogitReg: implementation for logistic regression
%
% Parameters:
% para: parameters 
%   1. RegFactor: regularization factor, default: 0
%   2. CostFactor: weighting between postive data and negative data, default: 1
%   3. AddConstant: add a constant 1 in the feature space or not, default: 1
%   4. Threshold: decision threshold for posterior probability, default: 0.5
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
% ParseParameter, GetModelFilename, ordinalNormal

function [Y_compute, Y_prob] = LogitReg(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;

Y_compute = zeros(size(Y_test)); 
Y_prob = zeros(size(Y_test));
if (num_class > 2)
    error('Error: The class number is larger than 2!');
end;

p = str2num(char(ParseParameter(para, {'-RegFactor'; '-CostFactor'; '-AddConstant'; '-Threshold'}, {'0'; '1'; '1'; '0.5'}, 1)));
RegFactor = p(1);
CostFactor = p(2);
AddConstant = p(3);
Threshold = p(4);

X_train_ext = X_train;
X_test_ext = X_test;

beta = [];
if (~isempty(X_train)),
    % Convert the binary labels into +/-1
    Y_train = (Y_train == class_set(1)) - (Y_train ~= class_set(1));
	if (AddConstant == 1), 
        X_train_ext = [X_train ones(size(X_train, 1), 1)]; 
    end;
    beta = ordinalNormal(Y_train, X_train_ext, RegFactor, CostFactor);   
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'beta', 'AddConstant');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    beta = model.beta;
	AddConstant = model.AddConstant;
    clear model;    
end;
if (AddConstant == 1), 
    X_test_ext = [X_test ones(size(X_test, 1), 1)]; 
end;
Logit_Y_prob = X_test_ext * beta;  
Logit_Y_prob = max(min(Logit_Y_prob, 100), -100);
Y_prob = exp(Logit_Y_prob) ./ (1 + exp(Logit_Y_prob));
Y_compute = class_set(1) * (Y_prob >= Threshold) + class_set(2) * (Y_prob < Threshold);
