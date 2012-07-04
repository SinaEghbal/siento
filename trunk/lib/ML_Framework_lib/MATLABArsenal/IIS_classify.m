% IIS_classify: implementation for improved iterative scaling for maximum entropy models
%
% Parameters:
% para: parameters
%   1. MinValue: the feature value to replace 0, default: 1e-7
%   2. Iter: learning iterations, default: 50
%   3. MinDiff: minimum log-likelihood difference for convergence, default: 1e-7
%   4. RegFactor: regularization factor, default: 0
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

function [Y_compute, Y_prob] = IIS_classify(para, X_train, Y_train, X_test, Y_test, num_class, class_set)

global preprocess;
p = str2num(char(ParseParameter(para, {'-MinValue';'-Iter'; '-MinDiff'; '-RegFactor'}, {'1e-7';'50';'1e-7';'0'})));

% Parameter estimation
if (~isempty(X_train)),
    weights = ParaEst(p, X_train, Y_train, num_class, class_set);
    if (preprocess.TrainOnly == 1),
        save(strcat(GetModelFilename, '.mat'), 'weights');
    end;
else
    model = load(strcat(GetModelFilename, '.mat'));
    weights = model.weights;
    clear model;
end;

% Prediction
mod_prob = exp(weights' * X_test');
mod_prob = (mod_prob ./ repmat(sum(mod_prob), num_class, 1))'; 
[Y_prob, run] = max(mod_prob, [], 2);
Y_compute = class_set(run);
if (num_class == 2), 
	Y_prob = mod_prob(:, 1);
end;

function weights = ParaEst(p, X_train, Y_train, num_class, class_set)

min_value = p(1);
max_iter = p(2);
min_diff = p(3);
regfactor = p(4);

% Initialize the weights
[num_data, num_feature] = size(X_train);
weights = zeros(num_feature, num_class);

% feature selection
X_train = ((X_train == 0) .* min_value + X_train)';

% compute the empirical estimation for the features both the positive and the negative class
label_index = ([0:(num_data - 1)])' .* num_class;
for i = 1:num_class
	emp_feature_exp_vec(:, i) = sum(X_train(:, Y_train == class_set(i)), 2);   
    label_index(Y_train == class_set(i)) = label_index(Y_train == class_set(i)) + i;
end

% compute the f*f_sum
X_sum = sum(X_train)';
X_feature_sum = Scale_Cols(X_train, X_sum);

% Improved Iterative Scaling
fprintf('Iter:%4d, LL:%11.7f', 0, 0);
old_avgLL = 0; avgLL = 0;

for iter = 1:max_iter
   % compute the logarithm likelihood
   mod_prob = exp(weights' * X_train);
   sum_prob = sum(mod_prob)';
   mod_prob = Scale_Cols(mod_prob, 1 ./ sum_prob);
   if (sum(mod_prob <= 0) > 0), break; end;
   mod_prob = mod_prob + 1e-10 * (mod_prob <= 0);
      
   % compute the change in the feature
   mod_feature_exp_vec = X_train * mod_prob';
   first_der = emp_feature_exp_vec - mod_feature_exp_vec + regfactor * weights; % - 1/(sigma * sigma) * weights;
   sec_der = X_feature_sum * mod_prob' + regfactor; % + 1/(sigma * sigma);
   delta = first_der ./ sec_der;   
   
   % weights = weights + delta;
   old_avgLL = avgLL;
   [step, avgLL] = fminsearch(@LL, 0, [], weights, delta, X_train, label_index, num_data); 
   weights = weights + step * delta;
   
   % compute the average logarithm likelihood
   avgLL = -sum(log(mod_prob(label_index))) ./ num_data;

   % print out the LL information
   if rem(iter, 1) == 0
      fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\bIter:%4d, LL:%11.7f', iter, avgLL);
   end
   if (abs(avgLL - old_avgLL) < min_diff), break; end;       
end
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function avgLL = LL(step, weights, delta, X, label_index, num_data)

weights1 = weights + step * delta;
mod_prob = exp(weights1' * X);
sum_prob = sum(mod_prob)';
mod_prob = Scale_Cols(mod_prob, 1 ./ sum_prob);
 if (sum(mod_prob <= 0) > 0), avgLL = 1e+4; return; end;
mod_prob = mod_prob + 1e-10 * (mod_prob <= 0);
avgLL = -sum(log(mod_prob(label_index))) ./ num_data;

function y = Scale_Cols(x, s)
% y(:,i) = x(:,i)*s(i)
% This is more efficient than x*diag(s)
[num_rows, num_cols] = size(x);
y = x .* repmat(s(:)', num_rows, 1);
