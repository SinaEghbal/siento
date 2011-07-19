function data_ = aubt_getAmpl (data)
% Expects as input a periodical signal swinging 
% around the x-axis and calculates the value of each
% maximum and minimum in the signal. The output
% is a step signal which has the same length as 
% the input signal.
%
%  data_ = getAmpl (data, hz)
%   
%   input:
%   data:     a periodical signal swinging around the x-axis
%
%   output:
%   data_:    a step signal with the amplitudes
%
%   2005, Johannes Wagner <go.joe@gmx.de>

data = abs (data);
mind = not (logical (aubt_getMaxima (data)));
data (mind) = 0;

data_ = zeros (size (data));
i = 1;
while data(i) == 0
    i = i+1;
end
lastind = i;
data_(1:lastind) = data(lastind);

for j = i:length (data)
   if data(j) ~= 0
       middle = floor (lastind + (j - lastind) / 2);
       data_(lastind:middle) = data(lastind);
       data_(middle+1:j) = data(j);
       lastind = j;       
   end
end
data_(lastind:j) = data(lastind);






