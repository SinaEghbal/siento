function signal = emgGen( duration )
%EMGGEN Generate an EMG signal simulating repeated muscle contractions
%   Duration is length of signal in seconds (must be an integer), with one 
%   muscle contraction every second
%   Noise added
res=100; %set resolution

xe = sin(pi/res:pi/res:pi).*sin(200*pi/res:200*pi/res:200*pi);   % Single muscle contraction
xr = repmat(xe,1,duration); % Replicate it to create more data
x = xr + 0.1.*randn(1,length(xr));  % Add noise
signal = x';
end