function [featvec, featnames] = example_extractFeatFunc (data, hz)
% Feature extraction example function.
%
%  values = example_extractFeatFunc (data, hz)
%   
%   input:
%   data:       vector with signal values
%   hz:         sample rate
%
%   output:
%   featvec:    row vector with feature values
%   featnames:  cell array with feature names
%
%   2006, Johannes Wagner <go.joe@gmx.de>

k = 0;

dataLen = length (data);

% preprocessing

data = aubt_lowpassFilter (data, hz, 0.3);

% feature extraction

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'max';

