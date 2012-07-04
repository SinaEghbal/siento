% LogitRegKernel: implementation for kernel logistic regression
%
% Parameters:
% para: parameters 
%   1. RegFactor: regularization factor, default: 0
%   2. Kernel: kernel type, 0: linear, 1: poly, 2: RBF, default: 0
%   3. KernelParam: kernel parameter, default: 0.05
%   4. CostFactor: weighting between postive data and negative data, default: 1
%   5. Threshold: decision threshold for posterior probability, default: 0.5
% X_train: training examples
% Y_train: training labels
% X_test: testing examples
% Y_test: testing labels 
% num_class: number of classes
% class_set: set of class labels such as [1,-1], the first one is the
% positive label
%
% Require functions: 
% ParseParameter, GetModelFilename, ordinalKernel, ordinalKernelPredict

function [Y_compute, Y_prob] = LogitRegKernel(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;
if (num_class > 2)
    error('Error: The class number is larger than 2!');
end;

p = str2num(char(ParseParameter(para, {'-Kernel';'-KernelParam'; '-RegFactor'; '-CostFactor'; '-Threshold'}, {'0';'0.05';'0';'1';'0.5'}, 1)));
kerneltype = p(1);
kernelpara =  p(2); 
regftr = p(3);
costfactor = p(4);
threshold = p(5);

X_train_ext = [X_train ones(size(X_train, 1), 1)];
X_train_ext = X_train_ext(1:size(X_train_ext, 1), :);
Y_train  = Y_train(1:size(Y_train, 1), :);
X_test_ext = [X_test ones(size(X_test, 1), 1)];

Logit_Y_prob = zeros(size(X_test, 1), 1);
if (~isempty(X_train)),
    % Parameter estimation
    % Convert the binary labels into +/-1
    Y_train = (Y_train == class_set(1)) - (Y_train ~= class_set(1));
    beta = ordinalKernel(Y_train, X_train_ext, [], [], [], kerneltype, kernelpara, regftr, 0, costfactor);
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'beta', 'X_train_ext');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    beta = model.beta;
    X_train_ext = model.X_train_ext;
    clear model;       
end;

% Prediction
Logit_Y_prob = ordinalKernelPredict(beta, X_train_ext, X_test_ext, kerneltype, kernelpara);
Y_prob = exp(Logit_Y_prob) ./ (1 + exp(Logit_Y_prob));
Y_compute = class_set(1) * (Y_prob >= threshold) + class_set(2) * (Y_prob < threshold);
