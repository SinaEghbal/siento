function [signal] = bio_cleaner_rafa (srate,low_p,input_signal)
% bio_CLEANER: [signal] = bio_cleaner (srate,low_p,input_signal) 
% clean BIO signals from  power line noise and its armonics (up to srate/2)and perform low pass
% filter at LOW_P frequency. srate is the sample rate in Hz. 
% default notch at 50Hz edit to change

signal = input_signal;

% Australia
% NotchFreq = 50;
% USA
NotchFreq = 60;

% Design and plot an IIR notch filter that removes a NotchFreq Hz tone from a
% signal at 1000 Hz (srate). For this example, set the Q factor for the filter
% to 35 and use it to specify the filter bandwidth:
fQf=35;
wNO = NotchFreq / (srate / 2);
bw = wNO / fQf;
[bNO,aNO] = iirnotch(wNO,bw);
signal = filtfilt(bNO,aNO,signal);


% while NOf0<srate/2-NotchFreq,
%     %Apply a 50/60Hz and multiple notch filters:
%     % notch frequency
%     NOf0= NOf0+ NotchFreq;
% 
%     % normalise frequency in 'pi radiant per sample'
%     wNO = NOf0/(srate/2);
%     bw = wNO/fQf;
%     [bNO,aNO] = iirnotch(wNO,bw);
%     %Apply filter
%     signal = filtfilt(bNO,aNO,signal);
% end;
% 
%t=(0:length(signal_f)-1)/srate;
%Build a 40 Hz low pass filter against the HF noise in the building

% normalise frequency in 'pi radiant per sample'
order=50;        % Order 50 !!
NOf0=low_p;
wNO = NOf0/(srate/2);
bNO=fir1(order,wNO); % defaults to lowpass filter

%Apply low pass filter
signal = filtfilt(bNO,1,signal);

% represent acquired data
%figure, plot(t,signal_f(:,2:3))