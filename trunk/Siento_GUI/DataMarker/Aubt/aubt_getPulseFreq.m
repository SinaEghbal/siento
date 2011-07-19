function data_ = aubt_getPulseFreq (data, hz)
% Expects a pulse signal as input and
% transforms it to a frequency signal.
% The frequencies are calculated from the
% distance of two successive pulse values.
% The output is a step signal.
%
%  data_ = getPluseFreq (data, params)
%   
%   input:
%   data:     a pulssignal (pulse > 0, 0 otherwise)
%   hz:       samplerate of the pulse signal
%
%   output:
%   data_:    a step signal
%
%   2005, Johannes Wagner <go.joe@gmx.de>

data_ = zeros (size (data));
dSize = length (data);

j = 1;
while data(j) == 0
   j = j+1; 
end
lastp = j;
j = j+1;
while data(j) == 0
   j = j+1; 
end
actf = hz / (j - lastp);
data_(1:j) = actf;
lastp = j;
for i = j+1:dSize
    if data(i) ~= 0
       actf = hz / (i - lastp); 
       data_(lastp:i) = actf;
       lastp = i;
    end    
end
data_(lastp:i) = actf;




