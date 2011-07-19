function [featvec, featnames] = aubt_extractFeatECG (data, hz)
% Extracts features from a ecg signal.
%
%  values = aubt_extractFeatECG (data, hz)
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

%%%%%%%%%%%%%%%%%%%%%
%%% PREPROCESSING %%%
%%%%%%%%%%%%%%%%%%%%%

% calculate pqrst complex
rind = aubt_detecR (data, hz);
[pind, qind, sind, tind] = aubt_detecPQST (data, hz, rind);

% convert rr intervals to heart rate
hz_hrv = hz;
rrintervals = diff (double (rind)) ./ hz;
hrv = 60./rrintervals;  % beats per minute

%%%%%%%%%%%%%%%%
%%% FEATURES %%%
%%%%%%%%%%%%%%%%

k = 1;

rdst = diff (rind);
pdst = diff (pind);
qdst = diff (qind);
sdst = diff (sind);
tdst = diff (tind);
ptmean = zeros (length (pind), 1);
for i = 1:length (pind)
    ptmean(i) = mean (data(pind(i):tind(i)));
end

featvec(k) = mean (rdst) * (1000 / hz);
featnames{k} = 'ecgR-mean';
k = k + 1;
featvec(k) = median (rdst) * (1000 / hz);
featnames{k} = 'ecgR-median';
k = k + 1;
% featvec(k) = std (rdst) * (1000 / hz);
% featnames{k} = 'ecgR-std';
% k = k + 1;
featvec (k) = min (rdst); 
featnames{k} = 'ecgR-min';
k = k + 1;
featvec (k) = max (rdst); 
featnames{k} = 'ecgR-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgR-range';
k = k + 1;

featvec(k) = mean (pdst) * (1000 / hz);
featnames{k} = 'ecgP-mean';
k = k + 1;
featvec(k) = median (pdst) * (1000 / hz);
featnames{k} = 'ecgP-median';
k = k + 1;
% featvec(k) = std (pdst) * (1000 / hz);
% featnames{k} = 'ecgP-std';
% k = k + 1;
featvec (k) = min (pdst); 
featnames{k} = 'ecgP-min';
k = k + 1;
featvec (k) = max (pdst); 
featnames{k} = 'ecgP-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgP-range';
k = k + 1;

featvec(k) = mean (qdst) * (1000 / hz);
featnames{k} = 'ecgQ-mean';
k = k + 1;
featvec(k) = median (qdst) * (1000 / hz);
featnames{k} = 'ecgQ-median';
k = k + 1;
% featvec(k) = std (qdst) * (1000 / hz);
% featnames{k} = 'ecgQ-std';
% k = k + 1;
featvec (k) = min (qdst); 
featnames{k} = 'ecgQ-min';
k = k + 1;
featvec (k) = max (qdst); 
featnames{k} = 'ecgQ-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgQ-range';
k = k + 1;

featvec(k) = mean (sdst) * (1000 / hz);
featnames{k} = 'ecgS-mean';
k = k + 1;
featvec(k) = median (sdst) * (1000 / hz);
featnames{k} = 'ecgS-median';
k = k + 1;
% featvec(k) = std (sdst) * (1000 / hz);
% featnames{k} = 'ecgS-std';
% k = k + 1;
featvec (k) = min (sdst); 
featnames{k} = 'ecgS-min';
k = k + 1;
featvec (k) = max (sdst); 
featnames{k} = 'ecgS-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgS-range';
k = k + 1;

featvec(k) = mean (tdst) * (1000 / hz);
featnames{k} = 'ecgT-mean';
k = k + 1;
featvec(k) = median (tdst) * (1000 / hz);
featnames{k} = 'ecgT-median';
k = k + 1;
% featvec(k) = std (tdst) * (1000 / hz);
% featnames{k} = 'ecgT-std';
% k = k + 1;
featvec (k) = min (tdst); 
featnames{k} = 'ecgT-min';
k = k + 1;
featvec (k) = max (tdst); 
featnames{k} = 'ecgT-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgT-range';
k = k + 1;

pqdst = qind - pind;
featvec(k) = mean (pqdst) * (1000 / hz);
featnames{k} = 'ecgPQ-mean';
k = k + 1;
featvec(k) = median (pqdst) * (1000 / hz);
featnames{k} = 'ecgPQ-median';
k = k + 1;
% featvec(k) = std (pqdst) * (1000 / hz);
% featnames{k} = 'ecgPQ-std';
% k = k + 1;
featvec (k) = min (pqdst); 
featnames{k} = 'ecgPQ-min';
k = k + 1;
featvec (k) = max (pqdst); 
featnames{k} = 'ecgPQ-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgPQ-range';
k = k + 1;
clear pqdst;

qsdst = sind - qind;
featvec(k) = mean (qsdst) * (1000 / hz);
featnames{k} = 'ecgQS-mean';
k = k + 1;
featvec(k) = median (qsdst) * (1000 / hz);
featnames{k} = 'ecgQS-median';
k = k + 1;
% featvec(k) = std (qsdst) * (1000 / hz);
% featnames{k} = 'ecgQS-std';
% k = k + 1;
featvec (k) = min (qsdst); 
featnames{k} = 'ecgQS-min';
k = k + 1;
featvec (k) = max (qsdst); 
featnames{k} = 'ecgQS-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgQS-range';
k = k + 1;
clear qsdst;

stdst = tind - sind;
featvec(k) = mean (stdst) * (1000 / hz);
featnames{k} = 'ecgST-mean';
k = k + 1;
featvec(k) = median (stdst) * (1000 / hz);
featnames{k} = 'ecgST-median';
k = k + 1;
% featvec(k) = std (stdst) * (1000 / hz);
% featnames{k} = 'ecgST-std';
% k = k + 1;
featvec (k) = min (stdst); 
featnames{k} = 'ecgST-min';
k = k + 1;
featvec (k) = max (stdst); 
featnames{k} = 'ecgST-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgST-range';
k = k + 1;
clear stdst;

pampl = data(pind) - ptmean;
featvec(k) = mean (pampl);
featnames{k} = 'ecgPampl-mean';
k = k + 1;
featvec(k) = median (pampl);
featnames{k} = 'ecgPampl-median';
k = k + 1;
featvec(k) = std (pampl);
featnames{k} = 'ecgPampl-std';
k = k + 1;
featvec (k) = min (pampl); 
featnames{k} = 'ecgPampl-min';
k = k + 1;
featvec (k) = max (pampl); 
featnames{k} = 'ecgPampl-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgPampl-range';
k = k + 1;
clear pampl;

rampl = data(rind(2:length(rind)-1)) - ptmean;
featvec(k) = mean (rampl);
featnames{k} = 'ecgRampl-mean';
k = k + 1;
featvec(k) = median (rampl);
featnames{k} = 'ecgRampl-median';
k = k + 1;
featvec(k) = std (rampl);
featnames{k} = 'ecgRampl-std';
k = k + 1;
featvec (k) = min (rampl); 
featnames{k} = 'ecgRampl-min';
k = k + 1;
featvec (k) = max (rampl); 
featnames{k} = 'ecgRampl-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgRampl-range';
k = k + 1;
clear rampl;

sampl = data(sind) - ptmean;
featvec(k) = mean (sampl);
featnames{k} = 'ecgSampl-mean';
k = k + 1;
featvec(k) = median (sampl);
featnames{k} = 'ecgSampl-median';
k = k + 1;
featvec(k) = std (sampl);
featnames{k} = 'ecgSampl-std';
k = k + 1;
featvec (k) = min (sampl); 
featnames{k} = 'ecgSampl-min';
k = k + 1;
featvec (k) = max (sampl); 
featnames{k} = 'ecgSampl-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgSampl-range';
k = k + 1;
clear sampl;

% hrv features

rr = diff (rind);

featvec(k) = mean (rr);
featnames{k} = 'ecgHrv-mean';
k = k + 1;
featvec(k) = median (rr);
featnames{k} = 'ecgHrv-median';
k = k + 1;
% featvec(k) = std (rr);
% featnames{k} = 'ecgHrv-std';
% k = k + 1;
featvec (k) = min (rr); 
featnames{k} = 'ecgHrv-min';
k = k + 1;
featvec (k) = max (rr); 
featnames{k} = 'ecgHrv-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgHrv-range';
k = k + 1;
featvec(k) = aubt_pNN50 (rr, hz);
featnames{k} = 'ecgHrv-pNN50';
k = k + 1;

distr = aubt_NNdistr (hrv, 30);

featvec(k) = mean (distr);
featnames{k} = 'ecgHrvDistr-mean';
k = k + 1;
featvec(k) = median (distr);
featnames{k} = 'ecgHrvDistr-median';
k = k + 1;
featvec(k) = std (distr);
featnames{k} = 'ecgHrvDistr-std';
k = k + 1;
featvec (k) = min (distr); 
featnames{k} = 'ecgHrvDistr-min';
k = k + 1;
featvec (k) = max (distr); 
featnames{k} = 'ecgHrvDistr-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'ecgHrvDistr-range';
k = k + 1;
featvec(k) = aubt_HRVtriind (distr);
featnames{k} = 'ecgHrvDistr-triind';
k = k + 1;

featvec (k) = aubt_getSpecRange (hrv, hz_hrv, 0.0, 0.2);
featnames{k} = 'ecgHrv-specRange1';
k = k + 1;
featvec (k) = aubt_getSpecRange (hrv, hz_hrv, 0.2, 0.4);
featnames{k} = 'ecgHrv-specRange2';
k = k + 1;
featvec (k) = aubt_getSpecRange (hrv, hz_hrv, 0.4, 0.6);
featnames{k} = 'ecgHrv-specRange3';
k = k + 1;
featvec (k) = aubt_getSpecRange (hrv, hz_hrv, 0.6, 0.8);
featnames{k} = 'ecgHrv-specRange4';
