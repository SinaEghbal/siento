function data_ = aubt_getRWaves (data, hz)
% Expects an ecg-signal as input and looks for
% its r-waves. The output is a pulse signal
% with 1 indicating a r-wave and 0 otherwise.
%
% For detailed information about the detection of the r-wave 
% please see 'aubt_detecR'.
%
%  data_ = aubt_getRWaves (data, hz)
%   
%   input:
%   data:     an ecg-signal
%   hz:       sample rate
%   wtyp:     name of the wavelet function (default = 'haar')
%   order:    order of the decomposition (default = 1)
%
%   output:
%   data_:    a pulse signal
%
%   2005, Johannes Wagner <go.joe@gmx.de>

if nargin < 3 | isempty (wtyp)
    wtyp = 'haar';
end
if nargin < 4 | isempty (order)
    order = 1;
end

r = aubt_detecR (data, hz, wtyp, order);
data_ = zeros (length (data), 1);
data_(r) = 1;
            