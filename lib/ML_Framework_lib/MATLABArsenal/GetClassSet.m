% GetClassSet: get the information of class_set
%
% Parameters:
% Y: the data labels
% 
% Output:
% class_set: the set of labels
% num_class: the number of labels
%
function [class_set, num_class] = GetClassSet(Y)

global preprocess;
class_set = unique(Y);
if (isfield(preprocess, 'ClassSet')),
    class_set = preprocess.ClassSet;
end;
num_class = length(class_set);