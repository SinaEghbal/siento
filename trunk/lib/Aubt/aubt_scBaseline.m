function data_ = aubt_scBaseline (data)
% Expects as input a sc-signal and tries to approximate the
% baseline of the signal by calculating lines between two successive
% minimas. Afterwards the baseline is substracted from the
% original signal.
%
%  data_ = aubt_scBaseline (data)
%   
%   input:
%   data:     a sc-signal
%
%   output:
%   data_:    the input signal substracted by an approximation of its baseline
%
%   2005, Johannes Wagner <go.joe@gmx.de>

% scmin = DetectMinima(data);
scmin = find(aubt_getMinima(data) == 1);
baseline = data;
for j = 1:length(scmin)-1
    baseline(scmin(j):scmin(j+1)) = aubt_getLine(data(scmin(j)), data(scmin(j+1)), scmin(j+1)-scmin(j)+1);
end
data_ = data - baseline;

