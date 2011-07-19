function [signal] = bio_cleaner2 (fc,low_p,hi_p,input_signal)
% BIO_CLEANER: [signal] = bio_cleaner (fc,low_p,hi_p,input_signal) clean BIO signals from  power line noise and its harmonics(up to FC/2)and perform low pass
% filter at LOW_P frequency and Hi Pass filter at HI_P frequency. FC is the
% sample rate in Hz. Default notch at 50Hz, edit to change

fQf=35;
NOf0=0;
bw=0;
signal= input_signal;

while NOf0<fc/2-50, %Edit here NOf0<fc/2-60
    %Apply a 50Hz and multiple notch filters:
    % notch frequency
    NOf0= NOf0+50; % And here NOf0= NOf0+60

    % normalise frequency in 'pi radiant per sample'
    wNO = NOf0/(fc/2);
    bw = wNO/fQf;
    [bNO,aNO] = iirnotch(wNO,bw);
    %Apply filter
    signal = filter(bNO,aNO,signal);
end;


% normalise frequency in 'pi radiant per sample'
%order=50;        % Order 50 !!
order=1000;
NOf0=low_p;
wNO = NOf0/(fc/2);
bNO=fir1(order,wNO); % defaults to lowpass filter

%Apply low pass filter
signal = filter(bNO,1,signal);

if hi_p ~= 0,
    NOf0=hi_p;
    wNO = NOf0/(fc/2);
    bNO=fir1(order,wNO,'high');
    %Apply high pass filter
    signal = filter(bNO,1,signal);
end;
    

