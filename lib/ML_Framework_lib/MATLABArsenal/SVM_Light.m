% SVM_Light: wrapper for SVM_LIGHT
%
% Parameters:
% para: parameters 
%   1. Kernel: kernel type, 0: linear, 1: poly, 2: RBF, default: 0
%   2. KernelParam: kernel parameter, default: 0.05
%   3. CostFactor: weighting between postive data and negative data, default: 1
%   4. Threshold: decision threshold for posterior probability, default: 0.5
%   5. TransPosFrac: fraction of unlabeled examples to be classified
%      into the positive class, if this value is larger than 0, then 
%      trigger the transductive learning process. default: -1
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
% ParseParameter, GetModelFilename, svml, svmtrain, svmfwd

function  [Y_compute, Y_prob] = SVM_Light(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global SVMLight_dir;

if (nargin <= 5), num_class = 2; end;
if (nargin <= 6), class_set = [1 -1]; end;
if (num_class > 2)
    error('Error: The class number is larger than 2!');
end;

p = str2num(char(ParseParameter(para, {'-Kernel';'-KernelParam'; '-CostFactor'; '-Threshold'; ; '-TransPosFrac'}, {'0';'0.05';'1';'0.5';'-1'}, 1)));
kernel = p(1);
kernelparam = p(2);
costfactor = p(3);
threshold = p(4);
transposfrac = p(5);

% Convert the binary labels into +/-1
Y_train =  (Y_train == class_set(1)) - (Y_train ~= class_set(1));
if (transposfrac >= 0),
    % Transductive learning
    X_train = [X_train; X_test];
    Y_train = [Y_train; zeros(size(Y_test))];
end;

%Remove all zero entries
all_zero_entry = find(sum(abs(X_train), 2) == 0);
X_train(all_zero_entry, :) = [];
Y_train(all_zero_entry) = [];

all_zero_entry = find(sum(abs(X_test), 2) == 0);
X_test(all_zero_entry, 1) = 1e-5;

% Building the model
if (transposfrac >= 0),
    % Transductive learning
    net = svml(GetModelFilename, 'Kernel', kernel, 'KernelParam', kernelparam, 'CostFactor', costfactor, 'TransPosFrac', transposfrac, 'ExecPath', SVMLight_dir);
else
    net = svml(GetModelFilename, 'Kernel', kernel, 'KernelParam', kernelparam, 'CostFactor', costfactor, 'ExecPath', SVMLight_dir);
end;
% Learning the parameters
if (~isempty(X_train)),
    net = svmltrain(net, X_train, Y_train);
end;
% Compute prediction on the test data
Ypred = svmlfwd(net, X_test);

% Output the results
Y_prob = 1 ./ (1 + exp(-Ypred));
Y_compute = class_set(1) * (Y_prob >= threshold) + class_set(2) * (Y_prob < threshold);
