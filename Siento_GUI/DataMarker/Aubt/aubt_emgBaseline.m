function data_ = aubt_emgBaseline (data, rwaves, hz, cutoff)
% Expects as input a emg-signal and tries to approximate the
% baseline of the signal by firstly removing artefacts of the
% ecg-signal and then applying a lowpass-filter. Afterwards
% the baseline is substracted from the original signal.
%
%  data_ = aubt_emgBaseline (data, rwaves, hz, [cutoff])
%   
%   input:
%   data:     a emg-signal
%   rwaves:   the corresponding rwaves of the ecg-signal
%             (see aubt_getRWaves)
%   hz:       the sample rate of the emg-signal
%   cutoff:   the cutoff frequency used by the lowpass-filter
%             (default = 1.0 hz)
%
%   output:
%   data_:    the input signal substracted by an approximation of its baseline
%
%   2005, Johannes Wagner <go.joe@gmx.de>

if nargin < 4 | isempty (cutoff)
    cutoff = 1.0;    
end

pass = aubt_lowpassFilter (data, hz, cutoff);

data_ = abs (data - pass);
dSize = length (data_);
r = (1:length(rwaves));
r = r(rwaves > 0);
rSize = length(r);

for l=1:rSize-1
    
    [maxVal, maxInd] = max (data_(round (r(l)/8):round (r(l+1)/8)));
    maxInd = round(maxInd + r(l) / 8) - 1; 
    
    minIndR = maxInd;
    minIndL = maxInd;
    while minIndL > 1 & data_(minIndL) > data_(minIndL-1)
        minIndL = minIndL - 1;
    end
    while minIndR < dSize-1 & data_(minIndR) > data_(minIndR+1)
        minIndR = minIndR + 1;
    end
    data_(minIndL:minIndR) = aubt_getLine (data_(minIndL), data_(minIndR), minIndR-minIndL+1);
    
end

