% LogitReg: implementation for k nearest neighbor
%
% Parameters:
% para: parameters 
%   1. k: number of neighbor nodes, default: 1
%   2. d: type of distance metrics, 0:L2, 1:L1, 2:chi2, 3:cos, default: 0
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

function  [Y_compute, Y_prob] = kNN_classify(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;
p = str2num(char(ParseParameter(para, {'-k';'-d'}, {'1';'0'})));
k = p(1);
disttype = p(2);

% Parameter estimation
if (~isempty(X_train)),
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'X_train', 'Y_train');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    X_train = model.X_train;
    Y_train = model.Y_train;
    clear model;
end;

num_test = size(X_test, 1);   
num_train = size(X_train, 1);
num_feature = size(X_test, 2);

fprintf('Iter: %5d', 0);
X_train_sqr = sqrt(sum(X_train .* X_train, 2));
X_test_sqr = sqrt(sum(X_test .* X_test, 2));
Y_compute = zeros(size(Y_test)); 
Y_prob = zeros(size(Y_test));
for i = 1:num_test    
    sumDistance = zeros(num_train, 1);
    sumDistance = vecdist(X_train, X_test(i, :), disttype, X_train_sqr, X_test_sqr(i));
    if (rem(i, 100) == 0),
      fprintf('\b\b\b\b\b\b\b\b\b\b\bIter: %5d', i);
    end    
    
    [sortDis, Index] = sort(sumDistance);
    sort_class_set = sort(class_set);
    n = hist(Y_train(Index(1:k)), sort_class_set);
    [junk, index] = max(n);
    Y_compute(i) = sort_class_set(index);
    
    Y_prob_matrix = exp(-sortDis)';
    sumYprob = sum(Y_prob_matrix, 2);
    if (num_class == 2),
        Y_prob(i) = Y_prob_matrix(1) ./ ((sumYprob == 0) + sumYprob);
    else
        Y_prob(i) = max(Y_prob_matrix) ./ ((sumYprob == 0) + sumYprob);
    end;
end;
fprintf('\n');

function dist = vecdist(X_train_vec, X_test_vec, disttype, X_train_sqr_vec, X_test_sqr)

switch(disttype)
case 0
    X_diff = (X_train_vec - repmat(X_test_vec, size(X_train_vec, 1), 1));
    dist = sum(X_diff .* X_diff, 2);
case 1
    X_diff = (X_train_vec - repmat(X_test_vec, size(X_train_vec, 1), 1));
    dist = sum(abs(X_diff), 2);
case 2
    plusdist = (X_train_vec + repmat(X_test_vec, size(X_train_vec, 1), 1));
    plusdist = plusdist + (plusdist == 0) * 1e-8;
    minusdist = (X_train_vec - repmat(X_test_vec, size(X_train_vec, 1), 1)); 
    dist = sum(minusdist .* minusdist ./ plusdist, 2); % chi2 distance
case 3
    dist = sum((X_train_vec .* repmat(X_test_vec, size(X_train_vec, 1), 1)), 2);    
    dist = (dist ./ X_train_sqr_vec) / X_test_sqr;
    dist = 1 - dist; % cosine similarity, make it a distance 
end;