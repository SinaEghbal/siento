function [featvec, featnames] = aubt_extractFeatSC (data, hz)
% Extracts features from a sc signal.
%
%  values = aubt_extractFeatSC (data, hz)
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
data = aubt_scBaseline (data);

% feature extraction

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'sc-mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'sc-median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'sc-std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'sc-min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'sc-max';
k = k + 1;
featvec (k) = (sum (aubt_getMinima (data))) / dataLen; 
featnames{k} = 'sc-minRatio';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (data))) / dataLen; 
featnames{k} = 'sc-maxRatio';

data = aubt_diffFilter (data);

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'sc1Diff-mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'sc1Diff-median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'sc1Diff-std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'sc1Diff-min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'sc1Diff-max';
k = k + 1;
featvec (k) = (sum (aubt_getMinima (data))) / dataLen; 
featnames{k} = 'sc1Diff-minRatio';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (data))) / dataLen; 
featnames{k} = 'sc1Diff-maxRatio';

data = aubt_diffFilter (data);

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'sc2Diff-mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'sc2Diff-median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'sc2Diff-std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'sc2Diff-min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'sc2Diff-max';
k = k + 1;
featvec (k) = (sum (aubt_getMinima (data))) / dataLen; 
featnames{k} = 'sc2Diff-minRatio';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (data))) / dataLen; 
featnames{k} = 'sc2Diff-maxRatio';
