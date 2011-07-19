function [signal] = bio_cleaner_2ways (fc,low_p,input_signal)
% bio_CLEANER: [signal] = bio_cleaner (fc,low_p,input_signal) clean BIO signals from  power line noise and its armonics (up to FC/2)and perform low pass
% filter at LOW_P frequency. FC is the sample rate in Hz. default notch at
% 50Hz edit to change

fQf=35;
NOf0=0;
bw=0;
signal= input_signal;

while NOf0<fc/2-50,
    %Apply a 50Hz and multiple notch filters:
    % notch frequency
    NOf0= NOf0+50;

    % normalise frequency in 'pi radiant per sample'
    wNO = NOf0/(fc/2);
    bw = wNO/fQf;
    [bNO,aNO] = iirnotch(wNO,bw);
    %Apply filter
    signal = filtfilt(bNO,aNO,signal);
end;

%t=(0:length(signal_f)-1)/fc;
%Build a 40 Hz low pass filter against the HF noise in the building

% normalise frequency in 'pi radiant per sample'
order=50;        % Order 50 !!
NOf0=low_p;
wNO = NOf0/(fc/2);
bNO=fir1(order,wNO); % defaults to lowpass filter

%Apply low pass filter
signal = filtfilt(bNO,1,signal);

% represent acquired data
%figure, plot(t,signal_f(:,2:3))