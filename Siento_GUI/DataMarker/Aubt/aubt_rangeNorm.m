function data_ = aubt_rangeNorm (data, a, b)
% Expects as input a matrix and normalizes each column
% into the interval [a b].
%
%  data = aubt_rangeNorm (data, a, b)
%   
%   input:
%   data:    matrix with input values
%   a:       lower interval boundary (default: 0)
%   b:       upper interval boundary (default: 1)
%
%   output:
%   data_:   columnwise normalized matrix
%
%   2006, Johannes Wagner <go.joe@gmx.de>

if nargin < 3
    a = 0;
    b = 1;
end

minv = repmat (min (data), size (data, 1), 1);
maxv = repmat (max (data), size (data, 1), 1);
data_ = ((data - minv ) .* (b-a) ./ (maxv - minv)) + a;
