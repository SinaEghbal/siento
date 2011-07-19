function data = aubt_getClassData (data, labels, c)
% returns the members of the specified class c from data
%
%  data = aubt_getClassData (data, labels, dim)
%   
%   input:
%   data:   feature matrix (one sample per row)
%   labels: label vector
%   c:      specifies the class
%
%   output:
%   data:   data with the spcified class label
%
%   2005, Johannes Wagner <go.joe@gmx.de>


data = data (not (labels - repmat(c, size(data, 1), 1)), :);