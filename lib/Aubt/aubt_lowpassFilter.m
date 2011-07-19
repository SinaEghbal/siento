function data_ = aubt_lowpassFilter (data, hz, cutoff, order, causal)
% Expects any signal sampled with samplerate hz
% and applies a lowpass Butterworth filter with the given
% cutoff frequency.
%
%  data_ = aubt_lowpassFilter (data, hz, cutoff, [order])
%   
%   input:
%   data:     any signal
%   hz:       samplerate of the signal
%   cutoff:   cutoff frequency of the lowpass filter
%   order:    order of the filter (default: 3)
%   causal:   0 = non-causal (default)
%             otherwise: causal (filtered sequence is run back through the filter)
%
%   output:
%   data_:    the filtered signal
%
%   2005, Johannes Wagner <go.joe@gmx.de>

if nargin < 4
    order = 3;
end
if nargin < 5
   causal = 0; 
end

offset = data(1);
[b,a] = butter (order, cutoff / (hz/2));
if causal == 0
    data_ = filter (b,a,data-offset) + offset;
else
    data_ = filtfilt (b,a,data-offset) + offset;
end
