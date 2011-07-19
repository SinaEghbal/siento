function data_ = aubt_getMaxima (data)
% Expects any signal as input and looks for its maxima. 
% The output is a pulse signal of same length as the 
% input signal with a 1 indicating a maximum and a 0 otherwise.
%
%  data_ = aubt_getMaxima (data)
%   
%   input:
%   data:     any signal
%
%   output:
%   data_:    a pulse signal
%
%   2005, Johannes Wagner <go.joe@gmx.de>

len = length (data);
data_ = zeros (size (data));
for i = 2:len-1
    if data(i-1) < data(i) & data(i) > data(i+1) 
        data_(i) = 1;
    end
end
    