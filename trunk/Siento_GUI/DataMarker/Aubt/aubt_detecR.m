function rind = aubt_detecR (signal, hz)
% Expects an ECG signal as input and tries to detected the position of the
% R waves. Therefore a continuously updated threshold is applied to the 
% detail of a wavelet decomposition. To achieve better results the 
% decomposition is done without downsampling. The algorithm is quite
% similar to that proposed by  S.C. Saxena, et al:
%
%   "Feature extraction from ECG signals using 
%   wavelet transforms for disease diagnostics", 
%   International Journal of Systems Science, 
%   2002, volume 33, number 13, pages 1073–1085
%
%  rind = aubt_detecR (signal, hz)
%
%  input:
%  signal   the ECG signal
%  hz       sample rate of the signal
%
%  output:
%  rind     a column vector containing the detected r-wave indeces
%
%
% 2005, Johannes Wagner <go.joe@gmx.de>

order = 1;
len = length (signal);
fhigh = [-0.707106781186548; 0.707106781186548]; % haar filter

% wavelet decomposition
cD = aubt_highdwt (signal, fhigh);
for i = 2:order
    cD = aubt_highdwt (cD, fhigh);
end

% define length of search windows
epswin = round (1.6 * hz);
qrswin = round (0.07 * hz);
skipwin = round (0.3 * hz);

% try to detec r waves

% 1. define a threshold eps for windows of the length epswin
j = 1;
eps = zeros (1, ceil (len / epswin));
epsind = zeros (1, ceil (len / epswin));
for i = 1:epswin:len
    [eps(j), epsind(j)] = max (abs (cD(i:min (i+epswin-1, len))));
    epsind(j) = i + epsind(j) - 1;
    j = j + 1;
end

% 2. find the maxima in each window
j = 1;
rind_ = uint32 ([]);
for i = 1:epswin:len
    r = find (abs (cD(i:min (i+epswin-1, len))) > 0.4*eps(j));
    j = j + 1;
    rind_ = [rind_; i + r - 1];
end

% 3. no find the r positions in the original signal
rind = uint32 ([]);
i = 1;
while i <= length (rind_)
    [maxval, maxind] = max (signal(max(1,rind_(i)-qrswin):min(len,rind_(i)+qrswin)));
    maxind = max (1, rind_(i)-qrswin) + maxind - 1;
    rind = [rind; maxind];
    while i <= length (rind_) & rind_(i) < maxind + skipwin
        i = i + 1;     
    end
end

% delete the first, the last and multiple indeces
for i = 2:length (rind)-1
    if rind(i) == rind(i-1);
        rind(i) = [];
    end
end

