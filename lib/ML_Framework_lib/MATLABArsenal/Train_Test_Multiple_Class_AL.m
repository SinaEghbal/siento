% Train_Test_Multiple_Class_AL: multi-class active learning wrapper for binary
% classifiers
%
% Pararmeters: 
% classifier: the base classifier
% para: parameters
%   1. CodeType: multi-class coding type, 0:one-vs-all, 1:pairwise, 2:ECOC
%   2. LossFuncType: loss function type, 0:logistic, 1:exp, 2:hinge 
%   3. ALIter: iteration of active learning
%   4. ALIncrSize: batch size for each iteration
% X_train, Y_train: training data and labels
% X_test, Y_test: testing data and labels
% num_class: number of classes
%
% Output parameters:
% Y_compute: the predicted labels
% Y_prob: the prediction confidence in [0,1]

function [Y_compute, Y_prob] = train_test_multiple_class_AL(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;

% parameters 
p = str2num(char(ParseParameter(para, {'-CodeType'; '-LossFuncType'; '-ALIter'; '-ALIncrSize'}, {'0'; '2'; '4'; '10'})));
preprocess.MultiClass.CodeType = p(1);
preprocess.MultiClass.LossFuncType = p(2);
preprocess.ActiveLearning.Iteration = p(3);
preprocess.ActiveLearning.IncrementSize = p(4);
preprocess.MultiClass.UncertaintyFuncType = 2; 
preprocess.MultiClass.ProbEstimation = 0;
PrintMessage();

% The statistics of dataset
train_len = size(Y_train, 1);
test_len = size(Y_test, 1);
test_index = 1:test_len;

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

Y_compute = zeros(test_len, 1);
Y_prob = zeros(test_len, 1);
Y_train_coding_matrix = (Y_train == class_set(1)) * coding_matrix;
Y_test_matrix = Y_test;
Y_test_coding_matrix = (Y_test == class_set(1)) * coding_matrix;

for i = 1:preprocess.ActiveLearning.Iteration
    
    test_len = size(Y_test_coding_matrix, 1);
    Y_compute_matrix = zeros(test_len, num_class);
    Y_loss_matrix = zeros(test_len, num_class);
    Y_uncertainty = zeros(test_len, 1);
    Y_compute_coding_matrix = zeros(test_len, coding_len);
    for j = 1:coding_len
        Y_train_coding = Y_train_coding_matrix(:, j);
        Y_test_coding = Y_test_coding_matrix(:, j);
        
        % Delete the element of which the label is zero
        X_train_norm = X_train(Y_train_coding ~= 0, :);
        Y_train_coding_norm = Y_train_coding(Y_train_coding ~= 0, :);
        
        % Converting the label back to class_set
        %conv_Y_train_coding_norm = class_set(1) * (Y_train_coding_norm == 1)  +  class_set(2) * (Y_train_coding_norm == -1);
        %conv_Y_test_coding = class_set(1) * (Y_test_coding == 1) + class_set(2) * (Y_test_coding == -1);    
        [Y_compute_class, Y_prob_class] = Classify(classifier, X_train_norm, Y_train_coding_norm, X_test, Y_test_coding, 2, [1 -1]');  
        CalculatePerformance(Y_compute_class, Y_prob_class, Y_test_coding, class_set);
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

    [Y_loss Y_loss_index]= min(Y_loss_matrix, [], 2);
    Y_compute_matrix = zeros(test_len, num_class);
    Y_compute_matrix((Y_loss_index-1) * test_len + (1:test_len)') = 1;

    for j = 1: test_len
        switch (preprocess.MultiClass.ProbEstimation)
        case 0
            dl = Y_compute_coding_matrix(j, :) .* coding_matrix(Y_loss_index(j), :);
            Y_uncertainty(j) = SumLossFunc(dl, coding_len);
        case 1
            dl = Y_compute_coding_matrix(j, :) .* ones(1, coding_len);
            Y_uncertainty(j) = SumLossFunc(dl, coding_len);            
            dl = Y_compute_coding_matrix(j, :) .* ones(1, coding_len) * -1;
            Y_uncertainty(j) = Y_uncertainty(j) + SumLossFunc(dl, coding_len);            
        case 2
            Y_uncertainty(j) = any(abs(Y_compute_coding_matrix(j, :)) == min(abs(Y_compute_coding_matrix)));
        end;
    end;
    
    %for j = 1:num_class
    %    Y_compute = Y_compute_matrix(:, j);
    %    Y_test = Y_test_matrix(:, j);
    %    [run_class.yy(j), run_class.yn(j), run_class.ny(j), run_class.nn(j), run_class.prec(j), run_class.rec(j), run_class.F1(j),...
    %        run_class.err(j)] = CalculatePerformance(Y_compute, Y_test, class_set);
    %end  
    
    [Y_compute_iter, junk] = find(Y_compute_matrix');
    [Y_test_iter, junk] = find(Y_test_matrix');
    Y_prob_iter = exp(-Y_loss) ./ sum(exp(-Y_loss_matrix), 2);
    Y_compute(test_index) = Y_compute_iter;
    Y_prob(test_index) = Y_prob_iter;    
    
    [junk, junk, junk, junk, run.Micro_Prec, run.Micro_Rec, run.Micro_F1, run.Err] ...
        = CalculatePerformance(Y_compute_iter, Y_prob_iter, Y_test_iter, preprocess.OrgClassSet, 0);
    %run.Macro_Prec = sum(run_class.prec) / num_class;
    %run.Macro_Rec = sum(run_class.rec) / num_class;
    %run.Macro_F1 = NormalizeRatio(2 * run.Macro_Prec * run.Macro_Rec, run.Macro_Prec + run.Macro_Rec);
    fprintf('Iter %d: Train Size = %d, Error = %f Micro_Precision = %f, Micro_Recall = %f, Micro_F1 = %f\n', ... 
            i, size(X_train, 1), run.Err, run.Micro_Prec, run.Micro_Rec, run.Micro_F1);  
    
    % Delete the testing data that have been labeled        
    % [C Index] = sort(abs(Y_compute_coding_matrix)); 
    [C Index] = sort(-Y_uncertainty);
    for k = 1:preprocess.ActiveLearning.IncrementSize
        X_train = [X_train; X_test(Index(k), :)];
        Y_train_coding_matrix = [Y_train_coding_matrix; Y_test_coding_matrix(Index(k), :)];
    end 
        
    Index = Index(1:preprocess.ActiveLearning.IncrementSize);
    Y_uncertainty(Index) = [];
    X_test(Index, :) = [];
    Y_test_matrix(Index, :) = [];
    Y_test_coding_matrix(Index, :) = [];
    test_index(Index) = [];    
end

function SumCertainty = SumLossFunc(dl, coding_len)

global preprocess;
switch (preprocess.MultiClass.UncertaintyFuncType)    
case 0 
      uncertainty = 1 ./ (1 + exp(2 * dl)); 
case 1
      uncertainty = exp(-dl);
case 2
      uncertainty = (dl <= 1) .* (1 - dl);
case 3
      uncertainty = exp(-100 * abs(dl)); % minimum abs(dl)
case 4
      if (dl > -1) 
           uncertainty = log( 1./(1+dl));
      else
           uncertainty = 0;
      end;
case 5
      uncertainty = rand(1, coding_len);
end;
SumCertainty = sum(uncertainty);
        
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

if (preprocess.MultiClass.UncertaintyFuncType == 0) 
    msg = sprintf(' Uncertainty: L1 ');
    preprocess.Message = [preprocess.Message msg];
elseif (preprocess.MultiClass.UncertaintyFuncType == 1)
    msg = sprintf(' Uncertainty: Exp ');
    preprocess.Message = [preprocess.Message msg]; 
elseif (preprocess.MultiClass.UncertaintyFuncType == 2)
    msg = sprintf(' Uncertainty: (1-Y)+ ');
    preprocess.Message = [preprocess.Message msg];
elseif (preprocess.MultiClass.UncertaintyFuncType == 3)
    msg = sprintf(' Uncertainty: Min Margin ');
    preprocess.Message = [preprocess.Message msg];
elseif (preprocess.MultiClass.UncertaintyFuncType == 4)
    msg = sprintf(' Uncertainty: -ln(1+x) ');
    preprocess.Message = [preprocess.Message msg];
elseif (preprocess.MultiClass.UncertaintyFuncType == 5)
    msg = sprintf(' Uncertainty: Random ');
    preprocess.Message = [preprocess.Message msg];
end;    

if (preprocess.MultiClass.ProbEstimation == 0) 
    msg = sprintf(' Best Worse ');
    preprocess.Message = [preprocess.Message msg];
elseif (preprocess.MultiClass.ProbEstimation == 1)
    msg = sprintf(' Uniform Guess ');
    preprocess.Message = [preprocess.Message msg]; 
elseif (preprocess.MultiClass.ProbEstimation == 2)
    msg = sprintf(' Binary Class ');
    preprocess.Message = [preprocess.Message msg];     
end;

fprintf('Multiclass Info: %s\n', preprocess.Message);
