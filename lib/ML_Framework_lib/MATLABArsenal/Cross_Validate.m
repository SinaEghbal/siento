% Cross_Validate: implementation of cross validation
%
% Input pararmeter: 
% D: the data array that contains features and labels
% classifier: the classifier description string
% 
% Required functions:
% Classify, CalculatePerformance

function run = Cross_Validate(D, classifier)

global preprocess;
[X, Y, orgY, num_data, num_feature] = Preprocessing(D);
clear D;

% The statistics of dataset
num_folder = preprocess.NumCrossFolder;
run.Y_pred = zeros(num_data, 4);
run.Y_pred(:, 1) = (1:num_data)';
for i = 1:num_folder
    fprintf('Iteration %d ......\n', i);  
    % Generate the data indices for the testing data and the training data
    testindex = floor((i-1) * num_data/num_folder)+1 : floor(i * num_data/num_folder);
    trainindex = setdiff(1:num_data, testindex);
      
    num_class = length(preprocess.ClassSet);
    class_set = preprocess.ClassSet;
    X_test = X(testindex, :);
    Y_test = Y(testindex, :);
    X_train = X(trainindex, :);
    Y_train = Y(trainindex, :);
    PrintTrainTestInfo(orgY, trainindex, testindex);

    % Classificaiton
    [Y_compute, Y_prob] = Classify(classifier, X_train, Y_train, X_test, Y_test, num_class, class_set);
    % Print the results
    [run_class(i).YY, run_class(i).YN, run_class(i).NY, run_class(i).NN, ...
        run_class(i).Prec, run_class(i).Rec, run_class(i).F1, run_class(i).Err, run_class(i).AvgPrec, run_class(i).BaseAvgPrec] ...
            = CalculatePerformance(Y_compute, Y_prob, Y_test, class_set, max(1, preprocess.Verbosity));

    % If Y_compute has only a single column    
    if (size(Y_compute, 2) == 1), 
        run.Y_pred(testindex, 2) = Y_prob; 
        run.Y_pred(testindex, 3) = preprocess.OrgClassSet(Y_compute); 
        run.Y_pred(testindex, 4) = orgY(testindex, :);
    end;
end

if (isfield(run_class(1), 'Err')), run.Err = mean([run_class(:).Err]); end;
if (isfield(run_class(1), 'Prec')), run.Prec = mean([run_class(:).Prec]); end;
if (isfield(run_class(1), 'Rec')), run.Rec = mean([run_class(:).Rec]); end;
if (isfield(run_class(1), 'F1')), run.F1 = mean([run_class(:).F1]); end;
if (isfield(run_class(1), 'AvgPrec')), run.AvgPrec = mean([run_class(:).AvgPrec]); end;
if (isfield(run_class(1), 'BaseAvgPrec')), run.BaseAvgPrec = mean([run_class(:).BaseAvgPrec]); end;

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

