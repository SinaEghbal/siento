function data_ = aubt_diffFilter (data)
% Expects as input any signal and approximates the derivation
% of the signal by calculating the difference between to
% successive values. The first value of the derivated signal
% is repeated to keep the original length.
%
%  data_ = aubt_diffFilter (data, minVal, maxVal)
%   
%   input:
%   data:     any signal
%
%   output:
%   data_:    the derivation of the signal
%
%   2005, Johannes Wagner <go.joe@gmx.de>

data_ = zeros (size (data));
data_(2:length(data_)) = diff (data);
data_(1) = data_(2);