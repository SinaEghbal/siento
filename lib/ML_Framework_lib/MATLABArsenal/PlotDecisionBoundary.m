% PlotDecisionBoundary: plot the decision boundary on a given data set
% 
% Parameters:
% data_set: the file which contains 2-D features and labels (totally 3 dims)
% classifier: the classifier string
% splitboundary: the boundary for training/testing data, default: half-half
% init_para: initial parameters for MATLABArsenal, default: none
% contour_interval: interval array for the contour lines, default: [0.2 0.5 0.8]
% 
% Required functions:
% test_classify

function h = PlotDecisionBoundary(data_set, classifier, splitboundary, init_para, contour_interval)

global preprocess;

if (nargin < 3), splitboundary = -1; end;
if (nargin < 4), init_para = ''; end;
if (nargin < 5), contour_interval = [0.2 0.5 0.8]; end;
    
% Load the data
data = dlmread(data_set);
[num_data, num_feature] = size(data);
Y = data(:, num_feature);
X = data(:, 1:2);
if (splitboundary < 0),
    splitboundary = fix(num_data / (-splitboundary));
end;

% Calculate some useful axis limits
x0 = min(X(:, 1));
x1 = max(X(:, 1));
y0 = min(X(:, 2));
y1 = max(X(:, 2));
dx = x1-x0;
dy = y1-y0;

expand = 2/50;			% Add on 5 percent each way
x0 = x0 - dx*expand;
x1 = x1 + dx*expand;
y0 = y0 - dy*expand;
y1 = y1 + dy*expand;
resolution = 50;
step = dx/resolution;
xrange = [x0:step:x1];
yrange = [y0:step:y1];

% Classification
X_train = X(1:splitboundary, :);
Y_train = Y(1:splitboundary);
X_rest = X((splitboundary+1):num_data, :);

MATLABArsenalCMD = sprintf('classify %s -v 2 -- train_test_validate -t %d -- %s', ...
    init_para, splitboundary, classifier);
run = test_classify(MATLABArsenalCMD, [X_train Y_train; X Y]);
Y_pred = run.Y_pred(:, 3);
Y_test = run.Y_pred(:, 4);
Y_pred_train = Y_pred(1:splitboundary);
Y_test_train = Y_test(1:splitboundary);
Y_pred_rest = Y_pred((splitboundary+1):num_data);

% Mesh Classification
[X1 X2] = meshgrid([x0:step:x1],[y0:step:y1]);
X_mesh = [X1(:) X2(:)];
MATLABArsenalCMD = sprintf('classify %s -- train_test_validate -t %d -- %s', ...
    init_para, splitboundary, classifier);
runmesh = test_classify(MATLABArsenalCMD, [X_train Y_train; X_mesh ones(size(X_mesh, 1), 1)]);
Y_pred_mesh = reshape(runmesh.Y_pred(:, 2), size(X1));

% Plot the data
hold on;
plot(X_train((Y_pred_train==1) & (Y_test_train==1),1),X_train((Y_pred_train==1) & (Y_test_train==1),2), 'ro', 'MarkerSize', 10);
plot(X_train((Y_pred_train==1) & (Y_test_train~=1),1),X_train((Y_pred_train==1) & (Y_test_train~=1),2), 'rx', 'MarkerSize', 10);
plot(X_train((Y_pred_train~=1) & (Y_test_train==1),1),X_train((Y_pred_train~=1) & (Y_test_train==1),2), 'bo', 'MarkerSize', 10);
plot(X_train((Y_pred_train~=1) & (Y_test_train~=1),1),X_train((Y_pred_train~=1) & (Y_test_train~=1),2), 'bx', 'MarkerSize', 10);
plot(X_rest(Y_pred_rest==1,1),X_rest(Y_pred_rest==1,2), 'r.', 'MarkerSize', 6);
plot(X_rest(Y_pred_rest~=1,1),X_rest(Y_pred_rest~=1,2), 'b.', 'MarkerSize', 6);
[c,h] = contour(xrange, yrange, Y_pred_mesh, contour_interval);
set(h,'ShowText','on');
xlabel('Dimension 1');
ylabel('Dimension 2');
title(sprintf('Training Data: first %d examples in %s', splitboundary, data_set));

