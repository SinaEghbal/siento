function [pind, qind, sind, tind] = aubt_detecPQST (signal, hz, rind)
% Expects an ECG signal and a corresponding vector with the fiducial
% locations of the r-waves as input and tries to detected the position of the
% P and T waves and the Q and S peak. Therefore positive and negative peaks
% on both sides of each r location are seeked. To achieve better results
% this is done in the approximation of a wavelet decomposition. 
% Decomposition is done without downsampling. The algorithm is quite
% similar to that proposed by  S.C. Saxena, et al:
%
%   "Feature extraction from ECG signals using 
%   wavelet transforms for disease diagnostics", 
%   International Journal of Systems Science, 
%   2002, volume 33, number 13, pages 1073–1085
%
%  [pind, qind, sind, tind] = aubt_detecPQST (signal, hz, rind)
%
%  input:
%  signal   the ECG signal
%  hz       sample rate of the signal
%  rind     fiducial points of the r waves
%
%  output:
%  pind     a column vector containing the detected p wave indeces
%  qind     a column vector containing the detected q peak indeces
%  sind     a column vector containing the detected s peak indeces
%  tind     a column vector containing the detected t wave indeces
%
%
% 2005, Johannes Wagner <go.joe@gmx.de>

order = 2;
flow = [-0.001077301084996,0.004777257511011,0.000553842200994,-0.031582039318031,0.027522865530016,0.097501605587079,-0.129766867567096,-0.226264693965169,0.315250351709243,0.751133908021578,0.494623890398385,0.11154074335008]; % db6

% tic

len = length (signal);

cA = aubt_lowdwt (signal, flow);
for i = 2:order
    cA = aubt_lowdwt (cA, flow);
end

% org = 0.05
qrswin = round (0.05 * hz);
pwin = 0.25; % percent of rr interval
twin = 0.4; % percent of rr interval

for i = 1:length (rind)
    [maxval, maxind] = max (cA(max (1, rind(i)-qrswin):min (rind(i)+qrswin, len)));
    rind(i) = maxind + max (1, rind(i)-qrswin) - 1;
end

qind = zeros (length (rind)-2, 1, 'uint32');
sind = zeros (length (rind)-2, 1, 'uint32');
pind = zeros (length (rind)-2, 1, 'uint32');
tind = zeros (length (rind)-2, 1, 'uint32');

for i = 2:length (rind)-1
    % q peak
    r = rind(i);
    while cA(r) - cA(r-1) > 0
       r = r - 1; 
    end
    qind(i-1) = r;
    % s peak
    r = rind(i);
    while cA(r) - cA(r+1) > 0
       r = r + 1; 
    end
    sind(i-1) = r;
    % p peak
    qwinstart = round (qind(i-1) - pwin * (rind(i)-rind(i-1)));
    [maxval, maxind] = max (cA(qwinstart:qind(i-1)));
    pind(i-1) = qwinstart + maxind - 1;
    % t peak
    twinend = round (sind(i-1) + twin * (rind(i+1)-rind(i)));
    [maxval, maxind] = max (cA(sind(i-1):twinend));
    tind(i-1) = sind(i-1) + maxind - 1;
end

% toc

