% LDA_classify: implementation for linear discriminant analysis
%
% Parameters:
% para: parameters 
%   1. RegFactor: regularization factor, default: 0
%   2. QDA: use qudratic discriminant analysis or not, default: 0
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

function  [Y_compute, Y_prob] = LDA_classify(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;
p = str2num(char(ParseParameter(para, {'-RegFactor'; '-QDA'}, {'0.1'; '0'})));

% Parameter estimation
if (~isempty(X_train)),
    [data_mean, inv_sigma, num_data_class] = ParaEst(p, X_train, Y_train, num_class, class_set);
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'data_mean', 'inv_sigma', 'num_data_class');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    data_mean = model.data_mean;
    inv_sigma = model.inv_sigma;
    num_data_class = model.num_data_class;
    clear model;
end;

% Prediction
num_test = size(Y_test, 1);
Y_distance_matrix = zeros(num_test, num_class); 
for i = 1:num_class,
    % Calculate the distance
    data_distance = X_test - repmat(data_mean(i, :), num_test, 1);
    Y_distance_matrix(:, i) = sum((data_distance * inv_sigma) .* data_distance, 2);
end;

% Generate the labels and probabilities
[Y_distance Index] = min(Y_distance_matrix, [], 2);
Y_compute = class_set(Index);
Y_prob_matrix = exp(-0.5 * (Y_distance_matrix - repmat(min(Y_distance_matrix, [], 2), 1, num_class))); 
Y_prob_matrix = repmat(num_data_class, num_test, 1) .* Y_prob_matrix;
sumYprob = sum(Y_prob_matrix, 2);
if (num_class == 2),
    Y_prob = Y_prob_matrix(:, 1) ./ ((sumYprob == 0) + sumYprob);
else
    Y_prob = max(Y_prob_matrix, [], 2) ./ ((sumYprob == 0) + sumYprob);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data_mean, inv_sigma, num_data_class] = ParaEst(p, X_train, Y_train, num_class, class_set)

RegFactor = p(1);
QDA = p(2);

num_feature = size(X_train, 2);
sigma = (1 - RegFactor) * cov(X_train) + RegFactor * eye(num_feature);
inv_sigma = inv(sigma);

data_mean = zeros(num_class, num_feature);
num_data_class = zeros(1, num_class);
for i = 1:num_class    
    % Convert the binary labels into 0 and 1
    data = X_train(Y_train == class_set(i), :);
    data_mean(i, :) = mean(data);
    num_data_class(i) = size(data, 1);
    if (QDA > 0),
        sigma = (1 - RegFactor) * cov(data) + RegFactor * eye(num_feature);
        inv_sigma = inv(sigma); 
        num_data_class(i) = num_data_class(i) / sqrt(det(sigma));
    end;
end;
