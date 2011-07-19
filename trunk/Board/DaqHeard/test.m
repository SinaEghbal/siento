%% plot channels using prerecorded data
%data = daqread('rafa0001b.daq');
load('-mat', '8chan');
data = [c0' c1' c2' c3' c4' c5' c6' c7'];

%addchannel(ai,7:-1:0,{'no0','no1','no2','ecg','no4','no5','emg','no7'}) 
% according to manual, DAQCArd 1200
ecg_column = 4;   
emg_column = 6;

srate = 1024;
duration = 60;                % seconds of acquisition
%ts = (0:srate*duration-1)/srate;          % samples in duration
ts = (0:length(data)-1)/srate;

% prepare for FFT
T = 1/srate;                     % Sample time
% L = 1000;                     % Length of signal
% t = (0:L-1)*T;                % Time vector
t = duration;
L = t * srate;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
widthFT = NFFT/2+1; % xaxis width 
%widthFT =100;
f = srate/2*linspace(0,1,widthFT);

% clean and plot

% raw ecg data: data(:,ecg_column)

% and FFT
Y = fft(data(:,ecg_column),NFFT)/L;
%widthFT = NFFT/2+1; % xaxis width 
% Plot single-sided amplitude spectrum.
REcgFT = 2*abs(Y(1:widthFT));

%  filtered ECG data
ecg = bio_cleaner_rafa (srate,40,data(:,ecg_column));

% and FFT 
Y = fft(ecg,NFFT)/L;
%widthFT = NFFT/2+1; % xaxis width 
ecgFT = 2*abs(Y(1:widthFT));

% filetered EMG data
emg = bio_cleaner_rafa (srate,40,data(:,emg_column));
% And FFT
Y = fft(emg,NFFT)/L;
emgFT = 2*abs(Y(1:widthFT));


%  X1:  vector of x data - time
X1 = ts;
%  Y1:  vector of y data - raw ecg
Y1 = data(:,ecg_column);
%  X2:  vector of x data - freq
X2 = f;
%  Y2:  vector of y data - Raw ecg FT
Y2 = REcgFT;
%  Y3:  vector of y data - Filt ECG
Y3 = ecg;
%  Y4:  vector of y data  - Filt ECG FT
Y4 = ecgFT;
%  Y5:  vector of y data - Filt EMG
Y5 = emg;
%  X3:  vector of x data - Freq
X3 = f;
%  Y6:  vector of y data - Filt EMG FT
Y6 = emgFT;

HeartRate = 60;
C1 = HeartRate;
createfigure(X1, Y1, X2, Y2, Y3, Y4, Y5, X3, Y6, C1);
