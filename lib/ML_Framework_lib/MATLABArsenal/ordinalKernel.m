% ordinalKernel: optimization module for kernel logistic regression

function [ alpha ] = ordinalKernel(y, x, y_pair, x_pair1, x_pair2, kerneltype, kernelpara, regftr, pairftr, costfactor, print, alpha)

% check input
if nargin < 2, x = []; end;
y=round(y(:)); [my ny]=size(y); [mx nx]=size(x);
if (mx > 0) & (mx ~= my), 
    error('row dimension of x does not equal the length of y'); 
end;
if (length(unique(y)) ~= 2), error('The number of classes is larger than 2!'); end; 

% initial calculations
tol=1e-6; incr=10; decr=2;

if ((sum(y == 1) == 0) | (sum(y == -1) == 0)),
    class_set = unique(y);
    class_set = [(class_set == 1)' * class_set; (class_set ~= 1)' * class_set]; % 1 must be the positive class label;  
    y =  (y == class_set(1)) - (y ~= class_set(1));
end;

extx = [x; x_pair1; x_pair2];
mextx = size(extx, 1);

% starting values
if nargin<3, y_pair = []; end;
if nargin<4, x_pair1 = []; end;
if nargin<5, x_pair2 = []; end;
if nargin<6, kerneltype = 0; end;
if nargin<7, kernelpara = 0; end;
if nargin<8, regftr = 0; end;
if nargin<9, pairftr = 1; end;
if nargin<10, costfactor = 1; end;
if nargin<11, print = 0; end;
if nargin<12, alpha = zeros(mextx, 1); end;

% Build the kernel matrix
switch (kerneltype) 
    case 0 
        kernel = extx * extx'; 
    case 1
        kernel = (1 + extx * extx') .^ 2;
    case 2
        kernel = eye(mextx);
        for i = 1:mextx
            k = repmat(extx(i, :), size(extx, 1), 1) - extx;
            kernel(:, i) = sum(k .* k, 2);
        end;
        kernel = exp(-kernelpara * kernel);
end;

vx = 1:size(x, 1);
vx_pair1 = size(x, 1) + 1 : size(x, 1) + size(x_pair1, 1);
vx_pair2 = size(x, 1) + size(x_pair1, 1) + 1 : size(x, 1) + size(x_pair1, 1) + size(x_pair2, 1);

c = (y == 1)' * costfactor + (y == -1)';
y_pair = (y_pair > 0) - (y_pair < 0);
Khead = kernel(vx_pair1, :) - diag(y_pair) * kernel(vx_pair2, :);  K = kernel(vx, :);
options = optimset('GradObj','on', 'Display', 'none', 'Hessian', 'on', 'MaxIter', 1000);
if (exist('fminunc.m')),
    [alpha, fval] = fminunc(@LRKernel, alpha, options, y, x, Khead, K, kernel, regftr, pairftr, c);
else
    fprintf('Warning: no fminunc detected, using fminsearch instead which could be slow\n');
    [alpha, fval] = fminsearch(@LRKernel, alpha, options, y, x, Khead, K, kernel, regftr, pairftr, c);
end;

function [dev, dl, d2l] = LRKernel(tb, y, x, Khead, K, kernel, regftr, pairftr, c)
% Compute log-likelihood 

dev = sum(c' .* log(1 + exp(-y .* (K * tb)))) + ...
      pairftr * sum(log(1 + exp(-Khead * tb))) + ...
      pairftr * sum(log(1 + exp(Khead * tb))) + ...
      regftr / 2 * tb' * kernel * tb; 

% first derivativez
% xhead = (x_pair1 - repmat(y_pair, 1, size(x_pair1, 2)) .* x_pair2);
% Khead = kernel(vx_pair1, :) - diag(y_pair) * kernel(vx_pair2, :);  
% K = kernel(vx, :);

p = c' .* exp(K * tb) ./ (1 + exp(K * tb)); 
p1 = exp(Khead * tb) ./ (1 + exp(Khead * tb));

dl = - K' * (c' .* (y == 1)) + K' * p + pairftr * (-Khead' * (1-p1)) + pairftr * (Khead' * p1) + regftr * kernel * tb;  

% second derivative
d2l = K' * diag(p .* (1 - p)) * K + 2 * pairftr * Khead' * diag(p1 .* (1 - p1)) * Khead + regftr * kernel * eye(size(tb, 1));
