% Perceptron: implementation for perceptron
%
% Parameters:
% para: parameters 
%   1. MaxIter: maximum iterations, default: 100
%   2. CostFactor: weighting between postive data and negative data, default: 1
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

function [Y_compute, Y_prob] = Perceptron(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;
if (num_class > 2)
    error('Error: The class number is larger than 2!');
end;

p = str2num(char(ParseParameter(para, {'-CostFactor'; '-MaxIter'}, {'1'; '100'}, 1)));
CostFactor = p(1);
MaxIter = p(2);

X_train_ext = [X_train ones(size(X_train, 1), 1)];
X_test_ext = [X_test ones(size(X_test, 1), 1)];

if (~isempty(X_train)),
    % Convert the binary labels into +/-1
    Y_train = (Y_train == class_set(1)) - (Y_train ~= class_set(1));
    beta = LearnPercept(Y_train, X_train_ext, CostFactor, MaxIter);   
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'beta');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    beta = model.beta;
    clear model;   
end;
Logit_Y_prob = X_test_ext * beta;  
Y_prob = 1 ./ (1 + exp(-Logit_Y_prob));
Y_compute = class_set(1) * (Logit_Y_prob >= 0) + class_set(2) * (Logit_Y_prob < 0);

function beta = LearnPercept(Y_train, X_train_ext, CostFactor, MaxIter)   

[num_data, num_feature] = size(X_train_ext);
beta = zeros(num_feature, 1);
for t = 1:MaxIter,
    all_correct = true;
    for i = 1:num_data,
       if (Y_train(i) .* (X_train_ext(i, :) * beta)) <= 0, 
            beta = beta + Y_train(i) .* X_train_ext(i, :)';
            all_correct = false;
       end;
    end;
    if (all_correct), break; end;
end;