% PerceptronKernel: implementation for kernel perceptron
%
% Parameters:
% para: parameters 
%   1. Kernel: kernel type, 0: linear, 1: poly, 2: RBF, default: 0
%   2. KernelParam: kernel parameter, default: 0.05
%   3. MaxIter: maximum iterations, default: 100
%   4. CostFactor: weighting between postive data and negative data, default: 1
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

function [Y_compute, Y_prob] = PerceptronKernel(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global temp_model_file preprocess;

Y_compute = zeros(size(Y_test)); Y_prob = zeros(size(Y_test));
if (num_class > 2)
    error('PerceptronKernel: The class number is larger than 2!');
end;

p = str2num(char(ParseParameter(para, {'-Kernel';'-KernelParam'; '-CostFactor'; '-MaxIter'}, {'0';'0.05';'1';'100'}, 1)));
KernelType = p(1);
KernelPara = p(2); 
CostFactor = p(3);
MaxIter = p(4);

X_train_ext = [X_train ones(size(X_train, 1), 1)];
% X_train_ext = X_train_ext(1:size(X_train_ext, 1), :);
Y_train  = Y_train(1:size(Y_train, 1), :);
X_test_ext = [X_test ones(size(X_test, 1), 1)];
%X_ext = X_train_ext;

if (~isempty(X_train)),
    % Convert the binary labels into +/-1
    Y_train = (Y_train == class_set(1)) - (Y_train ~= class_set(1));
    beta = LearnPerceptKernel(Y_train, X_train_ext, KernelType, KernelPara, CostFactor, MaxIter);
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'beta', 'X_train_ext');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    beta = model.beta;
    X_train_ext = model.X_train_ext;
    clear model;   
end;

Logit_Y_prob = PredictPerceptKernel(beta, X_train_ext, X_test_ext, KernelType, KernelPara);
Y_prob = exp(Logit_Y_prob) ./ (1 + exp(Logit_Y_prob));
Y_compute = class_set(1) * (Logit_Y_prob >= 0) + class_set(2) * (Logit_Y_prob < 0);

% Learning 

function beta = LearnPerceptKernel(Y_train, X_train_ext, KernelType, KernelPara, CostFactor, MaxIter)   

extx = X_train_ext;
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
        kernel = exp(-KernelPara * kernel);
        % kernel = exp(- kernel / (2 * KernelPara ^2));
end;

[num_data, num_feature] = size(X_train_ext);
beta = zeros(num_data, 1);
for t = 1:MaxIter,
    pred = Y_train .* (kernel * beta);
    beta = beta + Y_train .* (pred <= 0);
    if (all(pred > 0)), break; end;
end;

% Prediction 
function [L_output, kernel] = PredictPerceptKernel(beta, D_train, D_test, KernelType, KernelPara)

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
%        kernel = exp(-KernelPara * kernel);
        kernel = exp(- kernel / (2 * KernelPara ^2));
end;
L_output = kernel * beta; 