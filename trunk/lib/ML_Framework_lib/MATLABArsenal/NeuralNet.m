% NeuralNet: wrapper for multi-layer perceptron (from NETLAB)
%
% Parameters:
% para: parameters 
%   1. NHidden: number of hidden nodes, default: 10
%   2. NOut: number of output nodes, default: 1
%   3. Alpha: weight decay, default: 0.2
%   4. NCycles: number of learning cycles, default: 10
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
% ParseParameter, GetModelFilename

function  [Y_compute, Y_prob] = NeuralNet(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;
if (num_class > 2)
    error('Error: The class number is larger than 2!');
end;

p = str2num(char(ParseParameter(para, {'-NHidden';'-NOut'; '-Alpha'; '-NCycles'; '-Threshold'}, {'10';'1';'0.2';'100'; '0.5'})));
threshold = p(5);

% Parameter estimation
if (~isempty(X_train)),
    net = ParaEst(p, X_train, Y_train, num_class, class_set, preprocess.Verbosity);
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'net');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    net = model.net;
    clear model;
end;

Ypred = mlpfwd(net, X_test);
Y_compute = class_set(1) * (Ypred >= threshold) + class_set(2) * (Ypred < threshold);
Y_prob = Ypred;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function net = ParaEst(p, X_train, Y_train, num_class, class_set, verbosity)

if (nargin < 6), verbosity = 1; end;

% Now set up and train the MLP
nhidden = p(1);
nout = p(2);
alpha = p(3);	% Weight decay
ncycles = p(4);	% Number of training cycles. 

% Set up MLP network
[num_data num_feature] = size(X_train);
net = mlp(num_feature, nhidden, nout, 'logistic', alpha);
options = zeros(1, 18);
options(1) = verbosity - 1;    % Print out error values, -1 print nothing
options(14) = ncycles;

% Train using quasi-Newton.
target = (Y_train == class_set(1)); % 1 for positive, 0 for negative
net = netopt(net, options, X_train, target, 'quasinew');
