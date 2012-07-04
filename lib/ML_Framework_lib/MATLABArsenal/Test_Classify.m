% Test_Classifiy: the main module for MATLABArsenal
% 
% Parameter: 
% classifier: the classifier description string
% Example: test_classify('classify -t DataExample1.txt -sf 1 -- LibSVM
%   -Kernel 0 -CostFactor 3');
% input_data: input data from MATLAB internal codes
% Example: A = load('DataExample1.txt');
%           test_classify('classify -sf 1 -- LibSVM -Kernel 0 -CostFactor 3', A);
% 
% Output:
% run: include all the classification results

function run = Test_Classify(classifier, input_data)

warning('off','MATLAB:colon:operandsNotRealScalar');
if (nargin < 2), input_data = []; end;

% clear global preprocess;
global preprocess; 
global temp_train_file temp_test_file temp_output_file temp_model_file weka_dir mySVM_dir libSVM_dir SVMLight_dir; 
preprocess = [];

if (~isfield(preprocess, 'Verbosity')), preprocess.Verbosity = 1; end;
if (~isfield(preprocess, 'Message')), preprocess.Message = ''; end;
if (~isfield(preprocess, 'NumCrossFolder')), preprocess.NumCrossFolder = 3; end;
if (~isfield(preprocess, 'TrainTestSplitBoundary')), preprocess.TrainTestSplitBoundary = 100; end;
if (~isfield(preprocess, 'Normalization')), preprocess.Normalization = 1; end;
if (~isfield(preprocess, 'SizeFactor')), preprocess.SizeFactor = 0.5; end;
if (~isfield(preprocess, 'ShotAvailable')), preprocess.ShotAvailable = 0; end;
if (~isfield(preprocess, 'DataSampling')), preprocess.DataSampling = 0; end;
if (~isfield(preprocess, 'Sparse')), preprocess.Sparse = 0; end;
if (~isfield(preprocess, 'Shuffled')), preprocess.Shuffled = 0; end;
if (~isfield(preprocess, 'OutputFlag')), preprocess.OutputFlag = 'a'; end;
if (~isfield(preprocess, 'SVD')), preprocess.SVD = 0; end;
if (~isfield(preprocess, 'FLD')), preprocess.FLD = 0; end;
if (~isfield(preprocess, 'CHI')), preprocess.ChiSquare = 0; end;
if (~isfield(preprocess, 'ValidateByShot')), preprocess.ValidateByShot = 0; end;
if (~isfield(preprocess, 'ComputeMAP')), preprocess.ComputeMAP = 0; end;
if (~isfield(preprocess, 'Evaluation')), preprocess.Evaluation = 0; preprocess.TrainTestSplitBoundary = -2; end;
if (~isfield(preprocess, 'MultiClassType')), preprocess.MultiClassType = 0; end;
if (~isfield(preprocess, 'MultiClass') | (preprocess.MultiClassType == 0)), 
    preprocess.MultiClass.LabelType = 1; preprocess.MultiClass.CodeType = -1; preprocess.MultiClass.LossFuncType = -1;
    preprocess.MultiClass.UncertaintyFuncType = -1; preprocess.MultiClass.ProbEstimation = -1;
end;
if (~isfield(preprocess, 'ConstraintAvailable')), preprocess.ConstraintAvailable = 0; end;
if (~isfield(preprocess, 'ConstraintFileName')), preprocess.ConstraintFileName = ''; end;
if (~isfield(preprocess, 'input_file')), preprocess.input_file = ''; end;
if (~isfield(preprocess, 'output_file')), preprocess.output_file = ''; end;
if (~isfield(preprocess, 'pred_file')), preprocess.pred_file = ''; end;
if (~isfield(preprocess, 'model_file')), preprocess.model_file = ''; end;
if (~isfield(preprocess, 'WorkingDir')), preprocess.WorkingDir = ''; end;
if (~isfield(preprocess, 'NormalizePred')), preprocess.NormalizePred = 0; end;
if (~isfield(preprocess, 'ActualNumClass')), preprocess.ActualNumClass = 0; end;
if (~isfield(preprocess, 'TestOnly')), preprocess.TestOnly = 0; end;
if (~isfield(preprocess, 'TrainOnly')), preprocess.TrainOnly = 0; end;
if (~isfield(preprocess, 'CurModelCount')), preprocess.CurModelCount = 0; end;

if (nargin < 1), Report_Error; end;
[header, para, rem] = ParseCmd(classifier, '--', 0);
if (strcmpi(header, 'classify')), 
    p = str2num(char(ParseParameter(para, {'-v'; '-sf'; '-n'; '-sh'; '-vs'; '-ds'; '-dsr'; '-svd'; '-fld'; '-map'; '-if'; '-chi'; '-of'; '-sp'; '-np'; '-ac'; '-ldir'}, ...
                                          {'1'; '0'; '1'; '0'; '1'; '0'; '0'; '0'; '0'; '0'; '0'; '0'; '0'; '0'; '0'; '1'; '0'}, 0)));
    preprocess.Verbosity = p(1);
    preprocess.Shuffled = p(2);
    preprocess.Normalization = p(3);
    preprocess.ShotAvailable = p(4);
    preprocess.ValidateByShot = p(5);
    preprocess.DataSampling = p(6);
    preprocess.DataSamplingRate = p(7);
    preprocess.SVD = p(8);
    preprocess.FLD = p(9);
    preprocess.ComputeMAP = p(10);
    preprocess.InputFormat = p(11);
    preprocess.ChiSquare = p(12);
    preprocess.OutputFormat = p(13);
    % preprocess.PredFormat = p(14);
    preprocess.Sparse = p(14);
    preprocess.NormalizePred = p(15);
    preprocess.ActualNumClass = p(16);
    preprocess.LDirAlloc = p(17);
    
    p = ParseParameter(para, {'-t'; '-o'; '-p'; '-oflag'; '-dir'; '-drf' }, {''; ''; ''; 'a'; ''; ''}, 0);
    preprocess.input_file = char(p{1, :});
    preprocess.output_file = char(p{2, :});    
    preprocess.pred_file = char(p{3, :});    
    preprocess.OutputFlag = char(p{4, :});    
    preprocess.WorkingDir = char(p{5, :});    
    preprocess.DimReductionFile = char(p{6, :});    
    classifier = rem;   
else 
    Report_Error;
end;

% Setup the environmental varaible for directory information
if (isempty(preprocess.WorkingDir)), 
    % preprocess.WorkingDir = cd;
    filename = 'Classify.m'; 
    if (~exist(filename)),
        error('Cannot find the files in MATLABArsenal!');
    end;
    cur_dir = which(filename); 
    sep_pos = findstr(cur_dir, filesep); 
    preprocess.WorkingDir = cur_dir(1:sep_pos(length(sep_pos))-1);
end;
root = preprocess.WorkingDir;

temp_dir = sprintf('%s/temp', root);
if (~exist(temp_dir)),
    % eval(sprintf('!md \"%s\"', temp_dir));
    s = mkdir(root, 'temp');
    if (s ~= 1), error('Cannot create temp directory!'); end;
end;
temp_train_file = sprintf('%s/temp.train.txt', temp_dir);
temp_test_file = sprintf('%s/temp.test.txt', temp_dir);
temp_output_file = sprintf('%s/temp.output.txt', temp_dir);
temp_model_file = sprintf('%s/temp.model.txt', temp_dir);
weka_dir = sprintf('%s/weka-3-4/weka.jar', root);
mySVM_dir = sprintf('%s/svm', root);
libSVM_dir = sprintf('%s/svm', root);
SVMLight_dir = sprintf('%s/svm', root);

[header, para, rem] = ParseCmd(classifier, '--', 0);
if (strcmpi(header, 'train_test_validate')), 
    preprocess.Evaluation = 0;
    p = str2num(char(ParseParameter(para, {'-t'; '-test'; '-train'}, {'-2'; '0'; '0'}, 0)));
    preprocess.TrainTestSplitBoundary = p(1);
    preprocess.TestOnly = p(2);
    preprocess.TrainOnly = p(3);
    p = ParseParameter(para, {'-m' }, {''}, 0);
    preprocess.model_file = char(p{1, :}); 
    classifier = rem;
elseif (strcmpi(header, 'cross_validate')), 
    preprocess.Evaluation = 1;
    p = str2num(char(ParseParameter(para, {'-t'}, {'3'}, 0)));
    preprocess.NumCrossFolder = p(1);
    classifier = rem;
elseif (strcmpi(header, 'test_file_validate')), 
    preprocess.Evaluation = 2;
    p = char(ParseParameter(para, {'-t'}, {''}, 0));
    preprocess.test_file = p(1, :);
    classifier = rem;
elseif (strcmpi(header, 'train_only')), 
    preprocess.Evaluation = 3;
    p = char(ParseParameter(para, {'-m'}, {''}, 0));
    preprocess.TrainTestSplitBoundary = -1;
    preprocess.TrainOnly = 1;
    preprocess.model_file = p(1, :);
    classifier = rem;
elseif (strcmpi(header, 'test_only')), 
    preprocess.Evaluation = 4;
    p = char(ParseParameter(para, {'-m'}, {''}, 0));
    preprocess.TestOnly = 1;
    preprocess.model_file = p(1, :);
    classifier = rem; 
end;   

if (preprocess.TrainOnly == 1),
    if (isempty(preprocess.model_file)), 
        error('Error: the model file is empty!');
    end;
end;
if (preprocess.TestOnly == 1),
    if (isempty(preprocess.model_file)), 
        error('Error: the model file is empty!');
    end;
    % Load the dataset information
    fprintf('Loading model file %s.mat \n', preprocess.model_file);
    setting = load(sprintf('%s.mat', preprocess.model_file));
    preprocess.OrgClassSet = setting.class_set;
    classifier = setting.classifier;
    fprintf('Classifier: %s\n', classifier);
end;
if (isempty(classifier)),
    fprintf('Warning: the classfier is empty, use ZeroR instead!\n');
    classifier = 'ZeroR';
end;

% Initialize the message string

preprocess.Message = '';
if (preprocess.Evaluation == 0)
    msg = sprintf(' Train-Test Split, Boundary: %d, ', preprocess.TrainTestSplitBoundary);
    preprocess.Message = [preprocess.Message msg]; 
elseif (preprocess.Evaluation == 1)
    msg = sprintf(' Cross Validation, Folder: %d, ', preprocess.NumCrossFolder);
    preprocess.Message = [preprocess.Message msg];     
elseif (preprocess.Evaluation == 2)
    msg = sprintf(' Testing on File %s, ', preprocess.test_file);
    preprocess.Message = [preprocess.Message msg];     
elseif (preprocess.Evaluation == 3)
    msg = sprintf(' Training on File %s, ', preprocess.input_file);
    preprocess.Message = [preprocess.Message msg];     
elseif (preprocess.Evaluation == 4)
    msg = sprintf(' Testing on File %s, ', preprocess.input_file);
    preprocess.Message = [preprocess.Message msg];     
else 
    msg = sprintf(' Train-Test Split, Boundary: %d, ', preprocess.TrainTestSplitBoundary);
    preprocess.Message = [preprocess.Message msg]; 
end;

if (preprocess.MultiClassType == 0)
    msg = sprintf(' Classification, ', preprocess.TrainTestSplitBoundary);
    preprocess.Message = [preprocess.Message msg]; 
elseif (preprocess.MultiClassType == 1) 
    msg = sprintf(' Multiclass Classification Wrapper, ', preprocess.NumCrossFolder);
    preprocess.Message = [preprocess.Message msg];     
elseif (preprocess.MultiClassType == 2) 
    msg = sprintf(' Multilabel Classification Wrapper, ', preprocess.NumCrossFolder);
    preprocess.Message = [preprocess.Message msg];     
elseif (preprocess.MultiClassType == 3) 
    msg = sprintf(' Multiclass Active Learning Wrapper, ', preprocess.NumCrossFolder);
    preprocess.Message = [preprocess.Message msg];     
end;

if (preprocess.SVD == 1)
    msg = sprintf(' SVD ');
    preprocess.Message = [preprocess.Message msg]; 
end;
if (preprocess.Shuffled == 1)
    msg = sprintf(' Shuffled ');
    preprocess.Message = [preprocess.Message msg]; 
end;
if (preprocess.Sparse == 1)
    msg = sprintf(' Sparse ');
    preprocess.Message = [preprocess.Message msg]; 
end;
if (preprocess.DataSampling == 1)
    msg = sprintf(' Sampling Rate: %d', preprocess.DataSamplingRate);
    preprocess.Message = [preprocess.Message msg];    
end;
if (preprocess.ComputeMAP == 1)
    msg = sprintf(' Report Average Precision ');
    preprocess.Message = [preprocess.Message msg]; 
end;

% load the data
D = [];
output_file = [];
pred_file = [];
if (isfield(preprocess, 'input_file') & (~isempty(preprocess.input_file))), 
    % process the filenames
    input_file = preprocess.input_file;
    output_file = preprocess.output_file;
    pred_file = preprocess.pred_file;

    D = dlmread_format(input_file);

    fid = fopen(output_file, preprocess.OutputFlag);
    if (fid < 0),
        if ((~isfield(preprocess, 'test_file')) | (isempty(preprocess.test_file))), 
            output_file = sprintf('%s.result', input_file);
        else
            output_file = sprintf('%s.result', preprocess.test_file);
        end;
        preprocess.output_file = output_file;
        fid = fopen(output_file, preprocess.OutputFlag);
    end;
    if (preprocess.OutputFormat == 0),
        fprintf(fid, '\nProcessing Filename: %s, Data: %d, Feature: %d, Class: %d\n', ...
            preprocess.input_file, size(D,1), size(D,2)-1, length(unique(D(:, size(D,2))))); 
        fprintf(fid, 'Classifier:%s\nMessage:%s\n',classifier, preprocess.Message);
    end;
    fclose(fid);    

    fid = fopen(pred_file, preprocess.OutputFlag);
    if (fid < 0),
        if ((~isfield(preprocess, 'test_file')) | (isempty(preprocess.test_file))), 
            pred_file = sprintf('%s.pred', input_file);
        else
            pred_file = sprintf('%s.pred', preprocess.test_file);
        end;
        preprocess.pred_file = pred_file;
        fid = fopen(pred_file, preprocess.OutputFlag);
    end;
    fclose(fid);    

    fprintf('Finished loading %s.............\n', input_file);
    fprintf('Output Results to %s.............\n', output_file);
    fprintf('Output Predictions to %s.............\n', pred_file);
end;

switch (preprocess.Evaluation)
    case {0,3,4}
        % Train Test
        EvaluationHandle = @Train_Test_Validate;
    case 1
        % Cross Validate
        EvaluationHandle = @Cross_Validate;
    case 2
        % Test File Validate
        if ((~isfield(preprocess, 'test_file')) | (isempty(preprocess.test_file))), 
            error('The test file is not provided!');
        end;     
        D_test = dlmread_format(preprocess.test_file);        
        fprintf('Finished loading the test file %s.............\n', preprocess.test_file);
        preprocess.TrainTestSplitBoundary = size(D, 1);
        preprocess.Shuffled = 0;
        if (size(D, 2) > size(D_test, 2)), 
            fprintf('Warning: the feature number of the training set is larger than the testing set!\n');
            D = [D(:, 1:size(D_test, 2) - 1) D(:, size(D, 2))];
        end;
        if (size(D, 2) < size(D_test, 2)), 
            fprintf('Warning: the feature number of the testing set is larger than the training set!\n');
            D_test = [D_test(:, 1:size(D, 2)-1) D_test(:, size(D_test, 2))];
        end;        
        D = [D; D_test];
        EvaluationHandle = @Train_Test_Validate;   
end;

if (isempty(D)),
    if (~isempty(input_data)),
        D = input_data;
    else
        error('The input data are not provided!');
    end;
end;

t0 = clock;;
fprintf('Message:%s\n', preprocess.Message);
run = feval(EvaluationHandle, D, classifier);
run.ElapseTime = etime(clock,t0);

% Cross validation and shuffled 
if ((preprocess.Evaluation == 1) && (preprocess.Shuffled == 1)), 
    run.Y_pred(preprocess.shuffleindex, :) = run.Y_pred;
    run.Y_pred(:,1) = 1:size(run.Y_pred, 1);
end;

OutputResult = [];
if (isfield(run, 'Err')), OutputResult = [OutputResult sprintf('Error = %f, ', run.Err)]; end;
if (isfield(run, 'Prec')), OutputResult = [OutputResult sprintf('Precision = %f, ', run.Prec)]; end;
if (isfield(run, 'Rec')), OutputResult = [OutputResult sprintf('Recall = %f, ', run.Rec)]; end;
if (isfield(run, 'F1')), OutputResult = [OutputResult sprintf('F1 = %f, ', run.F1)]; end;
if (isfield(run, 'AvgPrec')), OutputResult = [OutputResult sprintf('MAP = %f, ', run.AvgPrec)]; end;
if (isfield(run, 'BaseAvgPrec')), OutputResult = [OutputResult sprintf('MBAP = %f, ', run.BaseAvgPrec)]; end;
if (isfield(run, 'ElapseTime')), OutputResult = [OutputResult sprintf('Time = %f, ', run.ElapseTime)]; end;
fprintf('%s\n', OutputResult);

if (~isempty(output_file)) 
    if ((preprocess.OutputFormat == 0) | (preprocess.OutputFormat == 1)),
        fid = fopen(output_file, 'a');
        fprintf(fid, '%s\n', OutputResult);
        fclose(fid);    
    end;
end;
if (~isempty(pred_file)) 
    fid = fopen(pred_file, 'w');
    if (preprocess.OutputFormat == 0),
        if (size(run.Y_pred, 2) == 4), 
            % fprintf(fid, 'Index\tProb\t\tPred\tTruth\n');
            fprintf(fid, '%d\t%f\t%d\t%d\n', run.Y_pred');
        else
            % fprintf(fid, 'Index\tProb\t\tPred\tTruth\tShotID\n');
            fprintf(fid, '%d\t%f\t%d\t%d\t%d\n', run.Y_pred');
        end;
    elseif (preprocess.OutputFormat == 1), % Only work when number of classes is 2
        fprintf(fid, 'Label: '); fprintf(fid, '%d ', preprocess.OrgClassSet); fprintf(fid, '\n');
        ProbClass1 = run.Y_pred(:, 2) .* (run.Y_pred(:, 3) == 1)  + (1 - run.Y_pred(:, 2)) .* (run.Y_pred(:, 3) ~= 1);
        fprintf(fid, '%d\t%f\t%f\n', [preprocess.OrgClassSet(run.Y_pred(:, 3)) ProbClass1 (1 - ProbClass1)]');    
    end;
    fclose(fid);    
end;

% Save the dataset information
if (preprocess.TrainOnly == 1),
    fprintf('Saving data info to the model file %s.mat\n', preprocess.model_file);
    class_set = preprocess.OrgClassSet;
    save(sprintf('%s.mat', preprocess.model_file), 'class_set', 'classifier');
end;

function Report_Error()

fprintf(' Example: Suppose you are in root directory\n');
fprintf(' Example: test_classify.exe \"classify -t demo/DataExample1.train.txt -sh 1 -- train_only -m demo/DataExample1.libSVM.model -- LibSVM -Kernel 0 -CostFactor 3\" \n');
fprintf(' Example: test_classify.exe \"classify -t demo/DataExample1.test.txt -sh 1 -- test_only -m demo/DataExample1.libSVM.model -- LibSVM -Kernel 0 -CostFactor 3\" \n');
fprintf(' Please refer to http://finalfantasyxi.inf.cs.cmu.edu/tmp/MATLABArsenal.htm for more examples \n');
error('  The command must begin with Classify     ');

function D = dlmread_format(input_file)

global preprocess;

if (preprocess.InputFormat == 2),
    strcmd = sprintf('!perl %s/ConvertFileInputSparse.pl %s %s.stdout', preprocess.WorkingDir, input_file, input_file);
    fprintf('!perl %s/ConvertFileInputSparse.pl %s %s.stdout\n', preprocess.WorkingDir, input_file, input_file); 
    % strcmd = sprintf('!%s/ConvertSparse.exe %s %s.stdout', preprocess.WorkingDir, input_file, input_file);
    % fprintf('!%s/ConvertSparse.exe %s %s.stdout\n', preprocess.WorkingDir, input_file, input_file);    
    eval(strcmd);
    preprocess.Sparse = 1;
    D = dlmread(sprintf('%s.stdout', input_file));
elseif (preprocess.InputFormat == 1),
    preprocess.Sparse = 1;
    D = dlmread(input_file);    
else
    D = dlmread(input_file);
end;

if (isempty(D)), 
    error(' the input file not found! '); 
end;
if (preprocess.Sparse == 1),
    D = spconvert(D);
end;