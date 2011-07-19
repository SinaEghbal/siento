function [featvec, featnames] = aubt_extractFeatEMG (data, hz)
% Extracts features from a emg signal.
%
%  values = aubt_extractFeatEMG (data, hz)
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

data = aubt_cutPeaks (data, aubt_getQuartile (data, 0.03), aubt_getQuartile (data, 0.97));
data = aubt_lowpassFilter (data, hz, 0.4);
data = aubt_varNorm (data);

% feature extraction

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'emg-mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'emg-median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'emg-std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'emg-min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'emg-max';
k = k + 1;
featvec (k) = (sum (aubt_getMinima (data))) / dataLen; 
featnames{k} = 'emg-minRatio';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (data))) / dataLen; 
featnames{k} = 'emg-maxRatio';

data = aubt_diffFilter (data);

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'emg1Diff-mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'emg1Diff-median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'emg1Diff-std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'emg1Diff-min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'emg1Diff-max';
k = k + 1;
featvec (k) = (sum (aubt_getMinima (data))) / dataLen; 
featnames{k} = 'emg1Diff-minRatio';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (data))) / dataLen; 
featnames{k} = 'emg1Diff-maxRatio';

data = aubt_diffFilter (data);

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'emg2Diff-mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'emg2Diff-median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'emg2Diff-std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'emg2Diff-min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'emg2Diff-max';
k = k + 1;
featvec (k) = (sum (aubt_getMinima (data))) / dataLen; 
featnames{k} = 'emg2Diff-minRatio';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (data))) / dataLen; 
featnames{k} = 'emg2Diff-maxRatio';
