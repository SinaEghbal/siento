% LDAKernel_classify: implementation for kernel linear discriminant analysis
%
% Parameters:
% para: parameters 
%   1. RegFactor: regularization factor, default: 0.1
%   2. Kernel: kernel type, 0: linear, 1: poly, 2: RBF, default: 0
%   3. KernelParam: kernel parameter, default: 0.05
% X_train: training examples
% Y_train: training labels
% X_test: testing examples
% Y_test: testing labels 
% num_class: number of classes
% class_set: set of class labels such as [1,-1], the first one is the
% positive label
%
% Require functions: 
% ParseParameter, GetModelFilename

function [Y_compute, Y_prob] = LDAKernel_classify(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;
if (num_class > 2)
    error('Error: The class number is larger than 2!');
end;

p = str2num(char(ParseParameter(para, {'-Kernel';'-KernelParam';'-RegFactor'}, {'0';'0.05';'0.1'}, 1)));
KernelType = p(1);
KernelPara = p(2); 
RegFactor = p(3);

% Parameter estimation
if (~isempty(X_train)),
    Y_train = (Y_train == class_set(1)) - (Y_train ~= class_set(1));
    [beta, mu1, mu2] = LearnFLDAKernel(Y_train, X_train, KernelType, KernelPara, RegFactor);
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'beta', 'mu1', 'mu2', 'X_train');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    beta = model.beta;
    mu1 = model.mu1;
    mu2 = model.mu2;
    X_train = model.X_train;
    clear model;
end;

Logit_Y_prob = PredictFLDAKernel(beta, X_train, X_test, KernelType, KernelPara, mu1, mu2);
Y_prob = exp(Logit_Y_prob) ./ (1 + exp(Logit_Y_prob));
Y_compute = class_set(1) * (Logit_Y_prob >= 0) + class_set(2) * (Logit_Y_prob < 0);

% Learning 
function [beta, mu1, mu2] = LearnFLDAKernel(Y_train, X_train, KernelType, KernelPara, RegFactor)   

extx = X_train;
mextx = size(extx, 1);
% Build the kernel matrix
switch (KernelType) 
    case 0 
        kernel = extx * extx'; 
    case 1
        kernel = (1 + extx * extx') .^ KernelPara;
    case 2
        kernel = eye(mextx);
        for i = 1:mextx
            k = repmat(extx(i, :), size(extx, 1), 1) - extx;
            kernel(:, i) = sum(k .* k, 2);
        end;
        % kernel = exp(-KernelPara * kernel);
        kernel = exp(- kernel / (2 * KernelPara ^2));
end;

[num_data, num_feature] = size(X_train);
beta = zeros(num_data, 1);

Kc(:, 1) = mean(kernel(:, Y_train == 1), 2);
Kc(:, 2) = mean(kernel(:, Y_train == -1),2);
K = mean(kernel, 2);

num_class = 2;
num_pos = sum(Y_train == 1);
num_neg = sum(Y_train == -1);
SB = Kc * Kc' - num_class * K * K';
SW = kernel * kernel - num_pos * Kc(:, 1) * Kc(:, 1)' - num_neg * Kc(:, 2) * Kc(:, 2)';
% M = SB \ SW;
[V, D] = eig(SB, SW + RegFactor * eye(size(SW)));
[junk, ind] = max(diag(D));
beta = V(:, ind);

L_output = kernel * beta; 
mu1 = mean(L_output(Y_train == 1));
mu2 = mean(L_output(Y_train == -1));
% sigma = std(L_output(Y_train == 1));

% Prediction 
function [L_output, kernel] = PredictFLDAKernel(beta, D_train, D_test, KernelType, KernelPara, mu1, mu2)

if nargin<4, kerneltype = 0; end;
if nargin<5, kernelpara = 0; end;

switch (KernelType) 
    case 0 
        kernel = D_test * D_train'; 
    case 1
        kernel = (1 + D_test * D_train') .^ KernelPara;
    case 2
        % RBFftr = 0.01;
        num_test = size(D_test, 1);
        num_train = size(D_train, 1);        
        kernel = zeros(num_test, num_train);
        for i = 1:num_test
            for j = 1:num_train
                kernel(i, j) = (D_test(i, :) - D_train(j, :)) * (D_test(i, :) - D_train(j, :))';
            end;
        end;
        kernel = exp(- kernel / (2 * KernelPara ^2));
end;
L_output = kernel * beta; 
L_output = (L_output - mu2) .^ 2 - (L_output - mu1) .^ 2;
