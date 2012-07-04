% ordinalNormal: optimization for logistic regression.  
%

function [alpha, fval] = ordinalNormal(y, x, regftr, costfactor, print, beta )

if nargin < 2, x = []; end;
[my ny]=size(y); [mx nx]=size(x); 
if (mx > 0) & (mx ~= my), 
    disp('row dimension of x does not equal the length of y'); return; 
end;
if (length(unique(y)) ~= 2), error('The number of classes is larger than 2!'); end; 

if ((sum(y == 1) == 0) | (sum(y == -1) == 0)),
    class_set = unique(y);
    class_set = [(class_set == 1)' * class_set; (class_set ~= 1)' * class_set]; % 1 must be the positive class label;  
    y =  (y == class_set(1)) - (y ~= class_set(1));
end;

% starting values
if nargin<3, regftr = 0.01; end;
if nargin<4, costfactor = 1; end;
if nargin<5, print = 0; end;
if nargin<6, alpha = ones(nx,1)/nx; end;

% costfactor = sum(y == -1) / sum(y == 1); 
c = (y == 1)' * costfactor + (y == -1)';

options = optimset('GradObj','on', 'Display', 'none', 'Hessian', 'on');
if (exist('fminunc.m')),
    [alpha, fval] = fminunc(@LR, alpha, options, y ,x, regftr, c);
else
    fprintf('Warning: no fminunc detected, using fminsearch instead which could be slow\n');
    [alpha, fval] = fminsearch(@LR, alpha, options, y ,x, regftr, c);
end;

function [dev, dl, d2l] = LR(tb, y ,x, regftr, c)

% log-likelihood
dev = sum(c' .* log(1 + exp(-y .* (x * tb)))) + regftr / 2 * tb' * tb; 

% first derivative
p = c' .* exp(x * tb) ./ (1 + exp(x * tb)); 
dl = - x' * (c' .* (y == 1)) + x' * p + regftr * tb;  

% second derivative
% d2l = - x' * diag(p .* (1 - p)) * x + regftr * eye(size(tb, 1));
% Change to 
d2l = x' * (repmat(p .* (1 - p), 1, size(tb, 1)) .* x) + regftr * eye(size(tb, 1));
