function nn50 = aubt_pNN50 (nn, hz)
% Returns the number of pairs of adjacent NN intervals differing by more
% than 50 ms in the entire recording divided by the total number of NN
% intervals.
%
%  nn50 = pNN50 (nn, hz)
%
%  input:
%  nn       vector with NN intervals
%  hz       sample rate of the original ECG signal
%
%  output:
%  nn50     number of pairs of adjacent NN intervals differing by more
%           than 50 ms divided by the total number of NN intervals 
%
%
% 2005, Johannes Wagner <go.joe@gmx.de>

len = length (nn);
thres = 0.05 * hz;
nn50 = sum (diff (nn) > thres) / len;