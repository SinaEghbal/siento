% libSVM: wrapper for libSVM
%
% Parameters:
% para: parameters 
%   1. Kernel: kernel type, 0: linear, 1: poly, 2: RBF, default: 0
%   2. KernelParam: kernel parameter, default: 0.05
%   3. CostFactor: weighting between postive data and negative data, default: 1
%   4. Threshold: decision threshold for posterior probability, default: 0.5
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
% ParseParameter, GetModelFilename

function  [Y_compute, Y_prob] = libSVM(para, X_train, Y_train, X_test, Y_test, num_class, class_set)
   
global temp_train_file temp_test_file temp_output_file libSVM_dir; 
global preprocess; 

verbosity = preprocess.Verbosity;
p = str2num(char(ParseParameter(para, {'-Kernel';'-KernelParam'; '-CostFactor'; '-Threshold'; '-SVMType'; '-nu'}, {'0';'0.05';'1';'0.5';'0';'0.5'})));
switch p(1)
    case 0
      s = '';      
    case 1
      s = sprintf('-d %.10g -g 1', p(2));
    case 2
      s = sprintf('-g %.10g', p(2));
    case 3
      s = sprintf('-r %.10g', p(2)); 
    case 4
      s = sprintf('-u "%s"', p(2));
end
        
% set up the commands
temp_model_file = GetModelFilename;
train_cmd = sprintf('!%s/svmtrain -b %d -s %d -t %d %s -w1 %f -n %f %s %s > log', libSVM_dir, (p(5) ~= 2), p(5), p(1), s, p(3), p(6), temp_train_file, temp_model_file);           
test_cmd = sprintf('!%s/svmpredict -b %d %s %s %s >> log', libSVM_dir, (p(5) ~= 2), temp_test_file, temp_model_file, temp_output_file);     

[num_train_data, num_feature] = size(X_train);   
[num_test_data, num_feature] = size(X_test);   

if (~isempty(X_train)),
    % Parameter Estimation
    fid = fopen(temp_train_file, 'w');
    for i = 1:num_train_data,
        Xi = X_train(i, :);
        % Remove all zero entries
        if (all(Xi == 0)), continue; end; 
        % Write label as the first entry
        s = sprintf('%d ', Y_train(i));
        % Then follow 'feature:value' pairs
        ind = find(Xi);
        s = [s sprintf(['%i:' '%.10g' ' '], [ind' full(Xi(ind))']')];
        fprintf(fid, '%s\n', s);
    end
    fclose(fid);
    % Train the SVM
    if (verbosity >= 1), fprintf('Running: %s........\n', train_cmd); end;
    eval(train_cmd);
    if (verbosity >= 1), end;
end;

% Prediction
fid = fopen(temp_test_file, 'w');
for i = 1:num_test_data,
  Xi = X_test(i, :);
  % Write label as the first entry
  s = sprintf('%d ', Y_test(i));
  % Then follow 'feature:value' pairs
  ind = find(Xi);
  if (isempty(ind)), ind = [1]; end;
  s = [s sprintf(['%i:' '%.10g' ' '], [ind' full(Xi(ind))']')];
  fprintf(fid, '%s\n', s);
end
fclose(fid);
if (verbosity >= 1), fprintf('Running: %s........\n', test_cmd); end;
eval(test_cmd);

% Read the result file
if (p(5) == 2), % for one-class SVM
    fid = fopen(temp_output_file, 'r');
    Y_compute = fscanf(fid, '%f');
    % convert [1, -1] labels to [1, 2] labels
    Y_compute = (Y_compute == 1) * 1 + (Y_compute == -1) * 2;
    Y_prob = 0.5 * ones(size(Y_compute));
    fclose(fid);
    return;  
end;

fid = fopen(temp_output_file, 'r');
line = fgets(fid);
labels = sscanf(line(8:length(line)), '%d');
Y = fscanf(fid, '%f');
fclose(fid);

Y = (reshape(Y, [], num_test_data))';    
Y_compute = int16(Y(:, 1));

% convert the labels into probability
threshold = p(4);
if (length(labels) == 2), 
    % binary class
    Y_prob = Y(:, find(labels == 1) + 1); 
    if (threshold ~= 0.5), 
        Y_compute = class_set(1) * (Y_prob >= threshold) + class_set(2) * (Y_prob < threshold);
    end;
else
    % multiple classes
    Y_prob = max(Y(:, 2:size(Y,2)), [], 2);
end;