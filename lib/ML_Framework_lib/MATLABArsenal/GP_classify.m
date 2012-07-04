% GP_classify: implementation for Gaussian Process for Classification
%
% Parameters:
% para: parameters 
%   1. PriorMean: mean of the prior distribution, default: 0
%   2. PriorVariance: variance of the prior distribution, default: 1
%   3. NCycles: maximum convergence cycles, default: 10
%   4. Threshold: decision threshold, default: 0.5
% X_train: training examples
% Y_train: training labels
% X_test: testing examples
% Y_test: testing labels 
% num_class: number of classes
% class_set: set of class labels such as [1,-1], the first one is the
% positive label
%
% Require functions: 
% ParseParameter, GetModelFilename, gp, gpinit, netopt, gpcovar, gpfwd

function  [Y_compute, Y_prob] = GP_classify(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;
if (nargin <= 5), num_class = 2; end;
p = str2num(char(ParseParameter(para, {'-PriorMean'; '-PriorVariance'; '-NCycles'; '-Threshold'}, {'0'; '1'; '100'; '0.5'})));
threshold = p(4);

% Parameter estimation
if (~isempty(X_train)),
    [net, cninv] = ParaEst(p, X_train, Y_train, num_class, class_set);
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'net', 'cninv');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    net = model.net;
    cninv = model.cninv;
    clear model;
end;

% Prediction
[Ypred, sigsq] = gpfwd(net, X_test, cninv);
% Convert the results back
Y_compute = class_set(1) * (Ypred >= threshold) + class_set(2) * (Ypred < threshold);
Y_prob = Ypred;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [net, cninv] = ParaEst(p, X_train, Y_train, num_class, class_set)

global preprocess;

randn('state', 1);

num_feature = size(X_train, 2);
pr_mean = p(1);
pr_variance = p(2);
ncycles = p(3);

% Set the options
options = foptions;
options(1) = (preprocess.Verbosity >= 1);    % Display training error values
options(14) = ncycles;

% Initialization
target = (Y_train == class_set(1));
net = gp(num_feature, 'ratquad');  % 'sqexp'
prior.pr_mean = pr_mean;
prior.pr_var = pr_variance;
net = gpinit(net, X_train, target, prior);

% Now learn the Gaussian Process to find the hyperparameters.
[net, options] = netopt(net, options, X_train, target, 'scg');

cn = gpcovar(net, X_train); 
cninv = inv(cn);
