% MCAdaBoostM1: implementation for AdaBoost.M1 meta-classifier
%
% Parameters:
% classifier: base classifier 
% para: parameters 
%   1. Iter: number of iteration, default: 10
%   2. SampleRatio: bootstrap sample ratio, default: 1
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
% ParseParameter, GetModelFilename, CalculatePerformance, Classify

function [Y_compute, Y_prob] = MCAdaBoostM1(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;

% Parameters
rand('state', 1);
p = str2num(char(ParseParameter(para, {'-Iter';'-SampleRatio'}, {'10';'1'})));
Max_Iter = p(1);
Sample_Ratio = p(2);

X_Sample = X_train;
Y_Sample = Y_train;
Y_compute_train_matrix = zeros(length(Y_train), num_class);
Y_compute_test_matrix = zeros(length(Y_test), num_class);
Y_compute = ones(size(Y_test));
Y_prob = ones(size(Y_test));

% Testing only 
if (isempty(X_train)),
    Y_compute_output = zeros(length(Y_test), Max_Iter);
    for iter = 1:Max_Iter,
        [Y_compute_test junk] = Classify(classifier, [], [], X_test, Y_test, num_class, class_set);
        Y_compute_output(:, iter) = Y_compute_test;
        CalculatePerformance(Y_compute_test, [], Y_test, class_set);
    end;
    model = load(strcat(GetModelFilename, '.mat'));
    alpha = model.alpha;
    clear model;
    for iter = 1:Max_Iter,
        Y_compute_test_matrix = UpdatePrediction(Y_compute_test_matrix, Y_compute_output(:, iter), alpha(iter), num_class, class_set);
    end;
    [Y_compute, Y_prob] = ConvertPrediction(Y_compute_test_matrix, num_class, class_set);
    return;
end;

% Initialize the data 
Dist = ones(length(Y_train), 1) ./ length(Y_train);
num_data = length(Y_train);
alpha = zeros(Max_Iter, 1);

for iter = 1:Max_Iter
    % Compute scores for training data
    [Y_compute_all junk] = Classify(classifier, X_Sample, Y_Sample, [X_train; X_test], [Y_train; Y_test], num_class, class_set);
    Y_compute_train  = Y_compute_all(1:length(Y_train), :);
    Y_compute_test  = Y_compute_all(length(Y_train)+1:length(Y_train)+length(Y_test), :);
    
    % Compute the weighted errors
    Weight_Err = sum(Dist .* (Y_compute_train ~= Y_train));
    if Weight_Err == 0, fprintf('Terminated: Training Error is Zero!'); break, end;
    if Weight_Err >= 0.5, fprintf('Terminated: Training Error is Larger than 0.5!'); break, end
    beta = Weight_Err / (1 - Weight_Err);
    alpha(iter) = -log(beta); % log(1/beta)
    
    % Compure the training predictions
    Y_compute_train_matrix = UpdatePrediction(Y_compute_train_matrix, Y_compute_train, alpha(iter), num_class, class_set);
    [junk Index] = max(Y_compute_train_matrix, [], 2);
    if (preprocess.Verbosity >= 1), 
        fprintf('%d: beta = %f, alpha = %f\n', iter, beta, alpha(iter));
        fprintf('Training: '); 
        CalculatePerformance(class_set(Index), [], Y_train, class_set);
    end;

    % Compute the testing predictions 
    Y_compute_test_matrix = UpdatePrediction(Y_compute_test_matrix, Y_compute_test, alpha(iter), num_class, class_set);
    [Y_compute, Y_prob] = ConvertPrediction(Y_compute_test_matrix, num_class, class_set);
    if (preprocess.Verbosity >= 1), 
        fprintf('Testing: '); 
        CalculatePerformance(Y_compute, Y_prob, Y_test, class_set);
    end;
    
    % Compute the sampling distribution
    Dist = Dist .* ((Y_compute_train ~= Y_train) + (Y_compute_train == Y_train) .* beta);
    Dist = Dist ./ sum(Dist);

    % Sample data and retrain the model
    Y_Sample = [];
    while (length(unique(Y_Sample)) < num_class), 
        num_samples = ceil(length(Y_train) * Sample_Ratio);
        Sample_Idx = SampleDistribution(Dist, num_samples);
        X_Sample = X_train(Sample_Idx, :);
        Y_Sample = Y_train(Sample_Idx);
    end;      
end
% Save the parameters
if (preprocess.TrainOnly == 1),
    save(strcat(GetModelFilename, '.mat'), 'alpha');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Y_compute_matrix = UpdatePrediction(Y_compute_matrix, Y_compute, alpha, num_class, class_set)

for i = 1:num_class, 
    ind = find(Y_compute == class_set(i));
    Y_compute_matrix(ind, i) = Y_compute_matrix(ind, i) + alpha;
end;

function [Y_compute, Y_prob] = ConvertPrediction(Y_compute_test_matrix, num_class, class_set)

Y_prob_matrix = exp(Y_compute_test_matrix - repmat(max(Y_compute_test_matrix, [], 2), 1, num_class));
[Y_prob Index] = max(Y_prob_matrix, [], 2);
Y_compute = class_set(Index);

% Convert Y_prob to posterior probability 
sumYprob = sum(Y_prob_matrix, 2);
if (num_class == 2),
    Y_prob = Y_prob_matrix(:, 1) ./ ((sumYprob == 0) + sumYprob);
else
    Y_prob = Y_prob ./ ((sumYprob == 0) + sumYprob);
end;

% Sample the data based on pdf and output the index
function ret_vec = SampleDistribution(pdf, num_samples)

CumDist = cumsum(pdf);
Diff = CumDist * ones(1, num_samples) - ones(length(pdf), 1) * rand(1, num_samples);
Diff = (Diff <= 0) * 2 + Diff;
[C, I] = min(Diff);
ret_vec = I';


