% GMM_classify: implementation for Gaussian mixture models
%
% Parameters:
% para: parameters 
%   1. NumMix: number of Gaussian mixtures, default: 1
%   2. NCycles: number of iteration cycles, default: 20
% X_train: training examples
% Y_train: training labels
% X_test: testing examples
% Y_test: testing labels 
% num_class: number of classes
% class_set: set of class labels such as [1,-1], the first one is the
% positive label
%
% Require functions: 
% ParseParameter, GetModelFilename, gmm, gmminit, gmmem, gmmprob

function  [Y_compute, Y_prob] = GMM_classify(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;
p = str2num(char(ParseParameter(para, {'-NumMix'; '-NCycles'}, {'1'; '20'})));

% Parameter estimation
if (~isempty(X_train)),
    mix = ParaEst(p, X_train, Y_train, num_class, class_set);
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'mix');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    mix = model.mix;
    clear model;
end;

% Prediction, compute the posterior probability
for i = 1:num_class,
    Y_prob_matrix(:, i) = gmmprob(mix{i}, X_test);
end;
[Y_prob Index] = max(Y_prob_matrix, [], 2);    
Y_compute = class_set(Index);
sumYprob = sum(Y_prob_matrix, 2);
if (num_class == 2),
    Y_prob = Y_prob_matrix(:, 1) ./ ((sumYprob == 0) + sumYprob);
else
    Y_prob = Y_prob ./ ((sumYprob == 0) + sumYprob);
end;

function mix = ParaEst(p, X_train, Y_train, num_class, class_set)

% Fix seeds for reproducible results
randn('state', 42);
rand('state', 42);
num_feature = size(X_train, 2);

num_mix = p(1);
ncycles = p(2);

for i = 1:num_class    
    % Convert the binary labels into 1 and 0
    data =  X_train(Y_train == class_set(i),:);
    
    options = foptions;
    options(14) = 10;	% Use 10 iterations of k-means in initialisation
    % Initialise the model parameters from the data
    mix{i} = gmm(num_feature, num_mix, 'diag');    
    mix{i} = gmminit(mix{i}, data, options);

    % Set up vector of options for EM trainer
    options = zeros(1, 18);
    options(1) = -1;		% Prints out error values.
    options(14) = ncycles;		% Max. Number of iterations.
    [mix{i}, options, errlog] = gmmem(mix{i}, data, options);
end;

