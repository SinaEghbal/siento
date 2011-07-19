function Qk = aubt_getQuartile (data, k)
% Returns the k quartile.
%
%  Qk = aubt_getQuartile (data, k)
%   
%   input:
%   data:     any signal vector
%   k:        value between [0..1]
%
%   output:
%   Qk:       the k% quartile
%
%   2005, Johannes Wagner <go.joe@gmx.de>

% samplesize
ssize = length (data);

% special cases
if k <= 0
    Qk = min (data);
    return;
elseif k >= 1
    Qk = max (data);
    return;
end

% STEP 1 - rank the data
y = sort(data);

% STEP 2 - find k% of the sample size, n.
result = round (k * ssize);

% STEP 4 - Find the number in this position.
Qk = y(result);

