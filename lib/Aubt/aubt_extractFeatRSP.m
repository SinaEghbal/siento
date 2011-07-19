function [featvec, featnames] = aubt_extractFeatRSP (data, hz)
% Extracts features from a rsp signal.
%
%  values = aubt_extractFeatRSP (data, hz)
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

data = aubt_lowpassFilter (data, hz, 0.45);
pulse = downsample (aubt_getPulseFreq (aubt_getMaxima (data), hz), hz);
ampl = downsample (aubt_getAmpl (aubt_diffFilter (data)), hz);

pulseLen = length (data);
amplLen = length (data);

% feature extraction

% spec range

k = k + 1;
featvec (k) = aubt_getSpecRange (data, hz, 0.0, 0.1);
featnames{k} = 'rsp-specRange1';
k = k + 1;
featvec (k) = aubt_getSpecRange (data, hz, 0.1, 0.2);
featnames{k} = 'rsp-specRange2';
k = k + 1;
featvec (k) = aubt_getSpecRange (data, hz, 0.2, 0.3);
featnames{k} = 'rsp-specRange3';
k = k + 1;
featvec (k) = aubt_getSpecRange (data, hz, 0.3, 0.4);
featnames{k} = 'rsp-specRange4';

% statistical features

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'rsp-mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'rsp-median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'rsp-std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'rsp-min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'rsp-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'rsp-range';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (data))) / dataLen; 
featnames{k} = 'rsp-maxRatio';

data = diff (data);

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'rsp1Diff-mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'rsp1Diff-median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'rsp1Diff-std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'rsp1Diff-min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'rsp1Diff-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2);  
featnames{k} = 'rsp1Diff-range';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (data))) / dataLen; 
featnames{k} = 'rsp1Diff-maxRatio';

data = diff (data);

k = k + 1;
featvec (k) = mean (data);
featnames{k} = 'rsp2Diff-mean';
k = k + 1;
featvec (k) = median (data);
featnames{k} = 'rsp2Diff-median';
k = k + 1;
featvec (k) = std (data);
featnames{k} = 'rsp2Diff-std';
k = k + 1;
featvec (k) = min (data); 
featnames{k} = 'rsp2Diff-min';
k = k + 1;
featvec (k) = max (data); 
featnames{k} = 'rsp2Diff-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'rsp2Diff-range';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (data))) / dataLen; 
featnames{k} = 'rsp2Diff-maxRatio';

% pulse

k = k + 1;
featvec (k) = mean (pulse);
featnames{k} = 'rspPulse-mean';
k = k + 1;
featvec (k) = median (pulse);
featnames{k} = 'rspPulse-median';
k = k + 1;
featvec (k) = std (pulse);
featnames{k} = 'rspPulse-std';
k = k + 1;
featvec (k) = min (pulse); 
featnames{k} = 'rspPulse-min';
k = k + 1;
featvec (k) = max (pulse); 
featnames{k} = 'rspPulse-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'rspPulse-range';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (pulse))) / pulseLen; 
featnames{k} = 'rspPulse-maxRatio';

pulse = aubt_diffFilter (pulse);

k = k + 1;
featvec (k) = mean (pulse);
featnames{k} = 'rspPulse1Diff-mean';
k = k + 1;
featvec (k) = median (pulse);
featnames{k} = 'rspPulse1Diff-median';
k = k + 1;
featvec (k) = std (pulse);
featnames{k} = 'rspPulse1Diff-std';
k = k + 1;
featvec (k) = min (pulse); 
featnames{k} = 'rspPulse1Diff-min';
k = k + 1;
featvec (k) = max (pulse); 
featnames{k} = 'rspPulse1Diff-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'rspPulse1Diff-range';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (pulse))) / pulseLen; 
featnames{k} = 'rspPulse1Diff-maxRatio';

pulse = aubt_diffFilter (pulse);

k = k + 1;
featvec (k) = mean (pulse);
featnames{k} = 'rspPulse2Diff-mean';
k = k + 1;
featvec (k) = median (pulse);
featnames{k} = 'rspPulse2Diff-median';
k = k + 1;
featvec (k) = std (pulse);
featnames{k} = 'rspPulse2Diff-std';
k = k + 1;
featvec (k) = min (pulse); 
featnames{k} = 'rspPulse2Diff-min';
k = k + 1;
featvec (k) = max (pulse); 
featnames{k} = 'rspPulse2Diff-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'rspPulse2Diff-range';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (pulse))) / pulseLen; 
featnames{k} = 'rspPulse2Diff-maxRatio';

% ampl

k = k + 1;
featvec (k) = mean (ampl);
featnames{k} = 'rspAmpl-mean';
k = k + 1;
featvec (k) = median (ampl);
featnames{k} = 'rspAmpl-median';
k = k + 1;
featvec (k) = std (ampl);
featnames{k} = 'rspAmpl-std';
k = k + 1;
featvec (k) = min (ampl); 
featnames{k} = 'rspAmpl-min';
k = k + 1;
featvec (k) = max (ampl); 
featnames{k} = 'rspAmpl-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'rspAmpl-range';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (ampl))) / amplLen; 
featnames{k} = 'rspAmpl-maxRatio';

ampl = aubt_diffFilter (ampl);

k = k + 1;
featvec (k) = mean (ampl);
featnames{k} = 'rspAmpl1Diff-mean';
k = k + 1;
featvec (k) = median (ampl);
featnames{k} = 'rspAmpl1Diff-median';
k = k + 1;
featvec (k) = std (ampl);
featnames{k} = 'rspAmpl1Diff-std';
k = k + 1;
featvec (k) = min (ampl); 
featnames{k} = 'rspAmpl1Diff-min';
k = k + 1;
featvec (k) = max (ampl); 
featnames{k} = 'rspAmpl1Diff-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'rspAmpl1Diff-range';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (ampl))) / amplLen; 
featnames{k} = 'rspAmpl1Diff-maxRatio';

ampl = aubt_diffFilter (ampl);

k = k + 1;
featvec (k) = mean (ampl);
featnames{k} = 'rspAmpl2Diff-mean';
k = k + 1;
featvec (k) = median (ampl);
featnames{k} = 'rspAmpl2Diff-median';
k = k + 1;
featvec (k) = std (ampl);
featnames{k} = 'rspAmpl2Diff-std';
k = k + 1;
featvec (k) = min (ampl); 
featnames{k} = 'rspAmpl2Diff-min';
k = k + 1;
featvec (k) = max (ampl); 
featnames{k} = 'rspAmpl2Diff-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'rspAmpl2Diff-range';
k = k + 1;
featvec (k) = (sum (aubt_getMaxima (ampl))) / amplLen; 
featnames{k} = 'rspAmpl2Diff-maxRatio';

