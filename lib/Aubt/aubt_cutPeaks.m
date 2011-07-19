function data = aubt_cutPeaks (data, minVal, maxVal)
% Expects as input a signal vector and trims the values
% to the interval [minVal, maxVal].
%
%  data = aubt_cutPeaks (data, minVal, maxVal)
%   
%   input:
%   data:     a signal vector
%   minVal:   lower bound of the interval
%   minVal:   upper bound of the interval
%
%   output:
%   data:     the trimmed signal
%
%
%   2005, Johannes Wagner <go.joe@gmx.de>

data(data > maxVal) = maxVal;
data(data < minVal) = minVal;