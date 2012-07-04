% Classify: main classification module
%
% Parameters:
% classifier_str: classifier description string
% X_train: training examples
% Y_train: training labels
% X_test: testing examples
% Y_test: testing labels 
% num_class: number of classes
% class_set: set of class labels such as [1,-1], the first one is the
% positive label
%
% Require functions: 
% ParseParameter, GetModelFilename, ordinalNormal

function  [Y_compute, Y_prob] = Classify(classifier_str, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess; 
% Check if the size of class_set is the same as num_class
if (length(unique(class_set)) ~= num_class), 
    error('Error: the number of class_set does not match with num_class!');
end;

% Dismension reduction by fisher linear discriminant analysis
if ((preprocess.FLD > 0) & (size(X_train, 2) > preprocess.FLD)) 
    [X_train X_test] = FLD(X_train, Y_train, X_test, Y_test, class_set);
end;

% Parse the classification string
[classifier, para, additional_classifier] = ParseCmd(classifier_str, '--');
% Translate the classifiers to propoer setting
if (strcmp(classifier, 'DecisionTree') == 1),
    classifier = 'WekaClassify';
    additional_classifier = strcat('trees.J48 ', para); 
    para = '-MultiClassWrapper 0';
elseif (strcmp(classifier, 'NaiveBayes') == 1),
    classifier = 'WekaClassify';
    additional_classifier = strcat('bayes.NaiveBayes ', para); 
    para = '-MultiClassWrapper 0';
end;

if (strcmpi(classifier, 'ZeroR')~=0),
    % Zero-output 
    Y_compute = ones(size(Y_test)); 
    Y_prob = zeros(size(Y_test));       
elseif (isempty(additional_classifier)),
    % Process the meta-classifier
    [Y_compute, Y_prob] = feval(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set); 
else
    % Process the base classifier
    [Y_compute, Y_prob] = feval(classifier, additional_classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set); 
end;

if (isempty(Y_compute) | isempty(Y_prob)),
    error('Y_compute or Y_prob is empty!');
end;

% Normalize the output prediction to be consistent with the training set, only when the number of classes is 2
if ((preprocess.NormalizePred == 1) && (num_class == 2) && (preprocess.ActualNumClass == 1)),
    pos_ratio = sum(Y_train == class_set(1)) / length(Y_train);
    Y_prob_sort = -sort(-Y_prob);
    Y_threshold = Y_prob_sort(fix(pos_ratio * length(Y_test)));
    Y_compute = (Y_prob > Y_threshold) * class_set(1) + (Y_prob <= Y_threshold) * class_set(2);
end;

function [X_train, X_test] = FLD(X_train, Y_train, X_test, Y_test, class_set)

global preprocess;

% Dimension reduction using fisher linear discriminat analysis
fprintf('FLD: reduce to %d dimension\n', preprocess.FLD);
if (~isempty(X_train)),
    [X_train, discrim_vec] = FisherLDA(X_train, Y_train, preprocess.FLD, class_set);
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'discrim_vec');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    discrim_vec = model.discrim_vec;
    clear model;
end;
X_test = X_test * discrim_vec(:, 1:preprocess.FLD);
if (~isempty(preprocess.DimReductionFile)),
    dlmwrite(preprocess.DimReductionFile, [X_train Y_train; X_test Y_test]);    
end;

% List of classifiers
%
% if (preprocess.Ensemble == 1) %Up-Sampling
%     Y_compute = UpSampling(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set);           
% elseif (preprocess.Ensemble == 2) %Down-Sampling
%     Y_compute = DownSampling(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (preprocess.Ensemble == 3) %Meta Classify, Majority Vote
%     Y_compute = MetaClassifyWithVoting(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (preprocess.Ensemble == 4) %Hierachy Classify
%     Y_compute = HierarchyClassify_Dev(classifier, para, X_train, Y_train, X_test, Y_test, num_class);   
% elseif (preprocess.Ensemble == 5) %Sum Rule
%     Y_compute = MetaClassifyWithSumRule(classifier, para, X_train, Y_train, X_test, Y_test, num_class);   
% elseif (preprocess.Ensemble == 6) %Stacking Classification
%     Y_compute = StackedClassify(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (preprocess.Ensemble == 7) %Active Learning
%     [Y_compute, Y_prob] = ActiveLearning(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (preprocess.Ensemble == 8) %Meta Classify with multiple feature sets
%     [Y_compute, Y_prob] = MetaClassifyWithMultiFSet(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (preprocess.Ensemble == 9) %Learn Order
%     [Y_compute, Y_prob] = LearnOrder_PairWise(classifier, para, X_train, Y_train, X_test, Y_test, num_class);    
% else
%     [Y_compute, Y_prob] = Classify(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% end;

% if (strcmp(classifier, 'SMO')~=0)
%     [Y_compute, Y_prob] = WekaClassify('SMO', para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (strcmp(classifier, 'SVM_LIGHT')~=0)
%     [Y_compute, Y_prob] = svm_light(para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (strcmp(classifier, 'SVM_LIGHT_TRAN')~=0)
%     [Y_compute, Y_prob] = svm_light_transductive(para, X_train, Y_train, X_test, Y_test, num_class);    
% elseif (strcmp(classifier, 'MY_SVM')~=0)
%     [Y_compute, Y_prob] = mySVM(para, X_train, Y_train, X_test, Y_test, num_class);    
% elseif (strcmp(classifier, 'j48')~=0)
%     [Y_compute, Y_prob] = WekaClassify('j48.J48', para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (strcmp(classifier, 'NaiveBayes')~=0)
%     [Y_compute, Y_prob] = WekaClassify(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (strcmp(classifier, 'LinearRegression')~=0)
%     [Y_compute, Y_prob] = WekaClassify(classifier, para, X_train, Y_train, X_test, Y_test, num_class);    
% elseif (strcmp(classifier, 'LWR')~=0)
%     [Y_compute, Y_prob] = WekaClassify(classifier, para, X_train, Y_train, X_test, Y_test, num_class);    
% elseif (strcmp(classifier, 'kNN')~=0)
%     [Y_compute, Y_prob] = kNN(para, X_train, Y_train, X_test, Y_test, num_class, class_set);
% elseif (strcmp(classifier, 'ME')~=0)
%     [Y_compute, Y_prob] = IIS_classify(X_train, Y_train, X_test);
%     %Y_compute = train_cg_multiple(X_train, Y_train, X_test);
% elseif (strcmp(classifier, 'NeuralNet')~=0)
%     [Y_compute, Y_prob] = NeuralNet(X_train, Y_train, X_test, para); 
% elseif (strcmp(classifier, 'NNSearch')~=0)    
%     [Y_compute, Y_prob] = NNSearch(para, X_train, X_test); 
% elseif (strcmp(classifier, 'LogitReg')~=0)
%     [Y_compute, Y_prob] = LogitReg(X_train, Y_train, X_test);   
% elseif (strcmp(classifier, 'LogitRegKernel')~=0)
%     [Y_compute, Y_prob] = LogitRegKernel(X_train, Y_train, X_test, para);       
% end;