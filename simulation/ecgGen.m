function signal = ecgGen( duration )
%ECGGEN Generate an ECG signal
%   Duration is length of signal in seconds (must be integer) with heart 
%   rate at 60bpm
%   Noise added
res=100; %set resolution

xe = ecg(res);   % Single ecg wave
xr = repmat(xe,1,duration); % Replicate it to create more data
x = xr + 0.1.*randn(1,length(xr));  % Add noise
signal = x';
end

