% Train_Test_Multiple_Class: multi-class learning wrapper for binary
% classifiers
%
% Pararmeters: 
% classifier: the base classifier
% para: parameters
%   1. CodeType: multi-class coding type, 0:one-vs-all, 1:pairwise, 2:ECOC
%   2. LossFuncType: loss function type, 0:logistic, 1:exp, 2:hinge     
% X_train, Y_train: training data and labels
% X_test, Y_test: testing data and labels
% num_class: number of classes
%
% Output parameters:
% Y_compute: the predicted labels
% Y_prob: the prediction confidence in [0,1]

function [Y_compute, Y_prob] = Train_Test_Multiple_Class(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;

% parameters
p = str2num(char(ParseParameter(para, {'-CodeType'; '-LossFuncType'}, {'0'; '2'})));
preprocess.MultiClass.CodeType = p(1);
preprocess.MultiClass.LossFuncType = p(2);
PrintMessage();

% The statistics of dataset
% num_class = length(preprocess.OrgClassSet);
train_len = size(Y_train, 1);
test_len = size(Y_test, 1);

% If multi-class classification with single labels, expand the labels to
% multiple labels, now Y is a matrix of {0, 1}^(num_data*num_class) 
if (preprocess.ActualNumClass == 1),  
    Y_train_convert = zeros(train_len, num_class);
    Y_train_convert((1:train_len)' + (Y_train - 1) * train_len) = 1;
    Y_train = Y_train_convert;        
    Y_test_convert = zeros(test_len, num_class);
    Y_test_convert((1:test_len)' + (Y_test - 1) * test_len) = 1;
    Y_test = Y_test_convert;     
end;

coding_matrix = GenerateCodeMatrix(preprocess.MultiClass.CodeType, num_class);
coding_len = size(coding_matrix, 2);

Y_train_coding_matrix = (Y_train == 1) * coding_matrix;
Y_test_matrix = Y_test;
Y_test_coding_matrix = (Y_test == 1) * coding_matrix;

Y_compute_matrix = zeros(test_len, num_class);
Y_loss_matrix = zeros(test_len, num_class);
Y_compute_coding_matrix = zeros(test_len, coding_len);
for j = 1:coding_len
    Y_train_coding = Y_train_coding_matrix(:, j);
    Y_test_coding = Y_test_coding_matrix(:, j);
        
    % Delete the element of which the label is zero
    X_train_norm = X_train(Y_train_coding ~= 0, :);
    Y_train_coding_norm = Y_train_coding(Y_train_coding ~= 0, :);
    
    % Classification
    [Y_compute_class, Y_prob_class] = Classify(classifier, X_train_norm, Y_train_coding_norm, X_test, Y_test_coding, 2, [1 -1]');  
    CalculatePerformance(Y_compute_class, Y_prob_class, Y_test_coding, [1 -1]');
    Y_compute_coding_matrix(:, j) = 2 * Y_prob_class - 1;
end;

for j = 1: test_len
    for k = 1:num_class
        dl = Y_compute_coding_matrix(j, :) .* coding_matrix(k, :);
        switch (preprocess.MultiClass.LossFuncType)
        case 0 
            loss = 1 ./ (1 + exp(2 * dl)); 
        case 1
            loss = exp(-dl);
        case 2
            loss = (dl <= 1) .* (1 - dl);
        end;
        Y_loss_matrix(j, k) = sum(loss); % Loss Function
    end;
end;

[Y_loss Y_loss_index] = min(Y_loss_matrix, [], 2);
Y_compute_matrix = zeros(test_len, num_class);
Y_compute_matrix((Y_loss_index-1) * test_len + (1:test_len)') = 1;

[Y_compute, junk] = find(Y_compute_matrix');
[Y_test, junk] = find(Y_test_matrix');
Y_prob = exp(-Y_loss) ./ sum(exp(-Y_loss_matrix), 2);

function PrintMessage()

global preprocess;

preprocess.Message = [];
if (preprocess.MultiClass.CodeType == 0) 
    msg = sprintf(' Coding: 1-vs-r ');
    preprocess.Message = [preprocess.Message msg];
elseif (preprocess.MultiClass.CodeType == 1)
    msg = sprintf(' Coding: 1-vs-1 ');
    preprocess.Message = [preprocess.Message msg]; 
elseif (preprocess.MultiClass.CodeType == 2)
    msg = sprintf(' Coding: ECOC15_5 ');
    preprocess.Message = [preprocess.Message msg];
elseif (preprocess.MultiClass.CodeType == 3)
    msg = sprintf(' Coding: ECOC63_31 ');
    preprocess.Message = [preprocess.Message msg]; 
elseif (preprocess.MultiClass.CodeType == 4)
    msg = sprintf(' Coding: Random ');
    preprocess.Message = [preprocess.Message msg]; 
end;    

if (preprocess.MultiClass.LossFuncType == 0) 
    msg = sprintf(' Loss: L1 ');
    preprocess.Message = [preprocess.Message msg];
elseif (preprocess.MultiClass.LossFuncType == 1)
    msg = sprintf(' Loss: Exp ');
    preprocess.Message = [preprocess.Message msg]; 
elseif (preprocess.MultiClass.LossFuncType == 2)
    msg = sprintf(' Loss: (1-Y)+ ');
    preprocess.Message = [preprocess.Message msg];
end;    

fprintf('Multiclass Info: %s\n', preprocess.Message);
