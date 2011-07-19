%% configuration for BCI device data acq
%port number for device
portNum='COM4';
%sampling rate
sampRate=1000;
%toatal 32 channels starting with LSB, 1-chOn, 0-chOFF
channels='00000000 00000000 00000000 00000011'; 
acqDuration=2; %duration of data acq in sec;