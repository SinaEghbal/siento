%% configure the path for the experiment
config;

%% script for data acquisition
% create an analoginput object
ai = analoginput('nidaq','1'); %Dev1

% Set inputtype to NonReferencedSingleEnded
set(ai,'InputType','NonReferencedSingleEnded');

%add input channels (no semi-colon to display results)
%addchannel(ai,0,'CH0')
%addchannel(ai,1,'CH1');
%addchannel(ai,2,'CH2');
%addchannel(ai,3,'CH3');
addchannel(ai,4,'CH4');
%addchannel(ai,5,'CH5');
%addchannel(ai,6,'CH6');
%addchannel(ai,7,'CH7');
%addchannel(ai,8,'CH8');
%addchannel(ai,9,'CH9');
%addchannel(ai,10,'CH10');
%addchannel(ai,11,'CH11');
%addchannel(ai,12,'CH12');

% set logging mode
set(ai,'LoggingMode','Disk&Memory');
set(ai,'LogFileName',fullfile (processingPath,'Camr0001'));
set(ai,'LogToDiskMode','index');

% set samplerate
true_srate = setverify(ai,'SampleRate',1000)

% start scope
softscope(ai)


