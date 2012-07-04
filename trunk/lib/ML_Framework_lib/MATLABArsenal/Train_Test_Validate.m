
% Train_Test_Validate: performance evalaution using a training set and a
% testing set
%
% Pararmeters: 
% D: data array, including the feature data and output class
% classifier: classifier description string
%
% Related parameters:
% preprocess.TrainOnly, preprocess.TestOnly,
% preprocess.TrainTestSplitBoundary

function run = Train_Test_Validate(D, classifier)

global preprocess;
[X, Y, orgY, num_data, num_feature] = Preprocessing(D);
clear D;

% split the dataset into training/testing sets
if (preprocess.TrainTestSplitBoundary > 0),
    splitboundary = preprocess.TrainTestSplitBoundary;
else
    splitboundary = fix(num_data / (-preprocess.TrainTestSplitBoundary));
end;
testindex = splitboundary+1:num_data;
trainindex = 1:splitboundary;

% Judge if it is either trainonly or testonly
if (preprocess.TestOnly), 
    trainindex = []; 
    testindex = 1:num_data;
end; 
if (preprocess.TrainOnly), 
    trainindex = 1:splitboundary;  
    testindex = 1:num_data;
end; 
PrintTrainTestInfo(orgY, trainindex, testindex);

% The statistics of data
num_class = length(preprocess.ClassSet);
class_set = preprocess.ClassSet;
X_test = X(testindex, :);
Y_test = Y(testindex, :);
X_train = X(trainindex, :);
Y_train = Y(trainindex, :);

% Classificaiton
[Y_compute, Y_prob] = Classify(classifier, X_train, Y_train, X_test, Y_test, num_class, class_set);

% Report the performance 
[run.YY, run.YN, run.NY, run.NN, run.Prec, run.Rec, run.F1, run.Err, run.AvgPrec, run.BaseAvgPrec] ...
    = CalculatePerformance(Y_compute, Y_prob, Y_test, class_set, max(2, preprocess.Verbosity));

run.Y_pred = zeros(length(testindex), 4);
if (size(Y_compute, 2) == 1), % single column
    run.Y_pred(:, 1) = (1:length(testindex))';
    run.Y_pred(:, 2) = Y_prob; 
    run.Y_pred(:, 3) = preprocess.OrgClassSet(Y_compute); 
    run.Y_pred(:, 4) = orgY(testindex, :);
end;
    
% Print training/testing info
function PrintTrainTestInfo(orgY, trainindex, testindex)

global preprocess;
if (preprocess.Verbosity > 1),
    class_set = preprocess.OrgClassSet;
    fprintf('Training Data: ');
    for i = 1:length(class_set), fprintf('(%d,%d) ', class_set(i), sum(orgY(trainindex) == class_set(i))); end;
    fprintf('\n');
    fprintf('Testing Data: ');
    for i = 1:length(class_set), fprintf('(%d,%d) ', class_set(i), sum(orgY(testindex) == class_set(i))); end;
    fprintf('\n');
end;
if ((~all(ismember(unique(orgY(testindex)), unique(orgY(trainindex))))) & (~isempty(trainindex))), 
    fprintf('Warning: labels of the testing set is not a subset of the training set\n');
end;