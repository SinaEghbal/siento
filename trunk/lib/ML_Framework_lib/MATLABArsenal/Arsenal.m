% Arsenal: overall wrapper for MATLABArsenal 
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

function run = Arsenal(classifier, input_data)

if (nargin < 2), input_data = []; end;

% redirect to Test_Classify
run = Test_Classify(classifier, input_data);
return;