function value = getSpecRange (data, hz, r1, r2)
% Expects as input a signal vector and estimates the mean of the frequency 
% spectrum in a given range.
%
%  values = aubt_getSpecRange (data, hz, r1, r2)
%   
%   input:
%   data:       signal vector
%   hz:         samplerate of the input signal(s)
%   r1:         lower bound of the frequeny band
%   r2:         upper bound of the frequeny band
%
%   output:
%   values:     mean of the frequency spectrum
%
%   2005, Johannes Wagner <go.joe@gmx.de>

len = length (data);
spec = psd (data, len, hz/2);
spec = spec / sum (spec);
hzPerSample = hz / len;
spec = spec (ceil (r1/hzPerSample)+1:floor (r2/hzPerSample)+1);
if isempty (spec)
	value = 0;
else
	value = mean (spec);
end

