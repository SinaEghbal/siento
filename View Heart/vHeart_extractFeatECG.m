%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2011
%------------------------------------------------------------------
%------------------------------------------------------------------
%   2006, Johannes Wagner <go.joe@gmx.de>
function [featvec, featnames] = vHeart_extractFeatECG (data, hz)
k=1;

rind = aubt_detecR (data, hz);
% convert rr intervals to heart rate
hz_hrv = hz;
rrintervals = diff (double (rind)) ./ hz;
hrv = 60./rrintervals;  % beats per minute

%HR features
featvec(k) = mean(hrv);
featnames{k} = 'HR-mean';
k=k+1;
featvec(k) = median (hrv);
featnames{k} = 'HR-median';
k = k + 1;
featvec(k) = std (hrv);
featnames{k} = 'HR-std';
k = k + 1;
featvec (k) = min (hrv); 
featnames{k} = 'HR-min';
k = k + 1;
featvec (k) = max (hrv); 
featnames{k} = 'HR-max';
k = k + 1;
featvec (k) = featvec(k-1) - featvec(k-2); 
featnames{k} = 'HR-range';
k = k + 1;

%HRV features
rr = diff (rind);
rr=double(rr);
featvec(k) = mean (rr)/hz;
featnames{k} = 'IBI-mean';
k = k + 1;
featvec(k) = median (rr)/hz;
featnames{k} = 'IBI-median';
k = k + 1;
featvec(k) = std (rr)/hz;
featnames{k} = 'IBI-std';
k = k + 1;
featvec (k) = min (rr)/hz; 
featnames{k} = 'IBI-min';
k = k + 1;
featvec (k) = max (rr)/hz; 
featnames{k} = 'IBI-max';
k = k + 1;
featvec (k) = (featvec(k-1) - featvec(k-2))/hz; 
featnames{k} = 'IBI-range';