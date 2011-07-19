function signal = scGen( duration )
%SCGEN Generate a GSR signal
%   Duration is length of signal in seconds (must be an integer), with GSR 
%   signal consisting of one triangular wave
%   Noise added
resolution=100;

xe = sawtooth(0:(2*pi)/(duration*resolution*0.5):2*pi);   % Single triangular wave
xe(duration*resolution*0.5+1:duration*resolution)=-xe(1:duration*resolution*0.5);
%xr = repmat(xe,1,repeats); % Replicate it to create more data
x = xe + 0.1.*randn(1,length(xe));  % Add noise
signal = x';
end