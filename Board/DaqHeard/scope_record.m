%% use sftscope to see ecg+ emg or all channels
% data recorced using DI DAQCard 1200

%% configure the path for the experiment
%config_rafa;

%% script for data acquisition
% create an analoginput object
ai = analoginput('nidaq','1'); %Dev1
%warning('off', 'daq:analoginput:adaptorobsolete'); 

% Set inputtype to NonReferencedSingleEnded
set(ai,'InputType','NonReferencedSingleEnded');

%add input channels (no semi-colon to display results)
addchannel(ai,7:-1:0,{'no0','no1','no2','ecg','no4','no5','emg','no7'})
%addchannel(ai,[4 6],{'ecg','emg'})

% set logging mode
set(ai,'LoggingMode','Disk&Memory');
set(ai,'LogFileName',fullfile (physioPath,'rafa8chanb'))
set(ai,'LogToDiskMode','index');

% set samplerate
srate = setverify(ai,'SampleRate',1024);
duration = 60;                % seconds of acquisition
slength = duration*srate;  % number of samples in duration
set(ai, 'SampleRate',srate)
set(ai,'SamplesPerTrigger',slength)


% start scope
%softscope('scope-ecg-emg.si')
softscope('scope-8c.si')
