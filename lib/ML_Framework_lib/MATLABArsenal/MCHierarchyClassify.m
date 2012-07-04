% MCHierarchyClassify: implementation for hierarchical classification using
% classifier ensembles
%
% Parameters:
% classifier: base classifier 
% para: parameters 
%   1. PosRatio: ratio of positive examples after sampling, default: 10
%   2. DevSet: sample a new validation set from training data or not, default: 0
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
% ParseParameter, Classify

function  [Y_compute, Y_prob] = MCHierarchyClassify(classifier, para, X_train, Y_train, X_test, Y_test, num_class, class_set)

if (num_class ~= 2), 
    error('Error: The number of classes is larger than 2!');
end;

p = str2num(char(ParseParameter(para, {'-PosRatio'; '-DevSet'}, {'0.5';'0'})));
sizefactor = p(1);
SampleDevSet = p(2);

[meta_classifier, para_meta_classifier, classifier] = ParseCmd(classifier, '--');
if (isempty(classifier)), 
    error('The bottom level classifier is not provided!');
end;

num_test = size(Y_test, 1);
data_neg = X_train(Y_train ~= class_set(1), :);
data_pos = X_train(Y_train == class_set(1), :);

% Sample the nearest examples as the development set
X_develop = [];
Y_develop = [];
if (SampleDevSet == 0),
    for j = 1:size(Y_test, 1)
        Distance = [];
        for k= 1:size(X_train, 1)
            %Distance = [Distance; sqrt(sum((X_train(k,:) - X_test(j,:)) .* (X_train(k,:) -  X_test(j,:))))];
            distance = sum(X_train(k, :) .* X_test(j,:));
            distance = distance / sqrt(sum(X_train(k, :) .* X_train(k, :)));
            distance = distance / sqrt(sum(X_test(j, :) .* X_test(j, :)));
            Distance = [Distance; distance];
        end;
        [junk, index] = max(Distance);
        X_develop = [X_develop; X_train(index, :)];
        Y_develop = [Y_develop; Y_train(index, :)];
    end;
else, 
    X_develop = X_train;
    Y_develop = Y_train;
end;

num_positive = sum(Y_train == class_set(1));
num_negative = sum(Y_train ~= class_set(1));
num_develop_positive = sum(Y_develop == class_set(1));
num_develop_negative = sum(Y_develop ~= class_set(1));

downsize = fix((1 - sizefactor) / sizefactor * num_positive);
num_group = fix(num_negative / downsize);
downsize = fix(num_negative / num_group);
fprintf('Sizefactor: %f GroupNum: %d PosSize: %d NegSize: %d PosDev: %d NegDev: %d\n', ...
            sizefactor, num_group, num_positive, num_negative, num_develop_positive, num_develop_negative);

X_combinetest = [X_develop; X_test];
Y_combinetest = [Y_develop; Y_test];
num_develop = size(Y_develop, 1);
num_train = size(Y_train, 1);

% Build up the classifier ensembles
Y_all = zeros(size(Y_combinetest, 1), num_group);
for i = 1:num_group
    data_additional = data_neg(floor((i-1)*num_negative/num_group)+1 : floor(i*num_negative/num_group), :);
    X_train = [data_pos; data_additional];
       
    label_pos = ones(size(data_pos, 1), 1) * class_set(1);
    label_additional = ones(size(data_additional, 1), 1) * class_set(2);
    Y_train = [label_pos; label_additional];
    
    [Y_compute, Y_prob] = Classify(classifier, X_train, Y_train, X_combinetest, Y_combinetest, num_class, class_set);
    Y_all(:, i) = Y_prob;    
end;

% Fuse the classifiers
D_develop = Y_all(1:num_develop, :);
D_test = Y_all(num_develop+1:num_develop+num_test, :);
[Y_compute, Y_prob]  = Classify(strcat(meta_classifier, ' ', para_meta_classifier), D_develop, Y_develop, D_test, Y_test, num_class, class_set);

