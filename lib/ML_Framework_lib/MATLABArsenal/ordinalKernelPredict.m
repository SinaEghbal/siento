% ordinalKernelPredict: compute prediction for kernel logistic regression
%

function [L_output, kernel] = ordinalKernelPredict(alpha, D_train, D_test, kerneltype, kernelpara)

if nargin<4, kerneltype = 0; end;
if nargin<5, kernelpara = 0; end;

switch (kerneltype) 
    case 0 
        kernel = D_test * D_train'; 
    case 1
        kernel = (1 + D_test * D_train') .^ 2;
    case 2
        num_test = size(D_test, 1);
        num_train = size(D_train, 1);        
        kernel = zeros(num_test, num_train);
        for i = 1:num_test
            for j = 1:num_train
                kernel(i, j) = (D_test(i, :) - D_train(j, :)) * (D_test(i, :) - D_train(j, :))';
            end;
        end;
        kernel = exp(-kernelpara * kernel);
end;

L_output = kernel * alpha; 