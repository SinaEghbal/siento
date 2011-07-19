function [path experiment protocol]= confignew ()

%% Setting path parameters
path.ExperimentPath = 'C:\Experiment\Apr30-09';

path.TmlPath = fullfile('C:\Matlab','tml');
path.TextPath= fullfile(path.ExperimentPath,'Text');

path.StimulusPath = fullfile(path.ExperimentPath,'Stimulus');
path.ProtocolPath = fullfile(path.ExperimentPath,'Protocol');

path.ProcessingPath = fullfile(path.ExperimentPath,'Processing');

path.PhysioPath= fullfile(path.ExperimentPath,'Physio');
path.SAMPath = fullfile(path.ExperimentPath,'SAM');

%% Settings experiment and protocol parameters
experiment.SubjectName = 'Omar';
experiment.SubjectAge = 25;
experiment.Date = '1/1/2009';
experiment.Protocol = 'IAPS'; %'Auto Tutor'

Protocol.Emotions = 'anger, happy, etc...';
Protocol.Signals = {'ecg';'emg';'sc'};
Protocol.SampleRate = 1000;
Protocol.SessionLength = 60; % in minutes
Protocol.NumberPic = 5; % number of pictures in a block, 1 for single picture
protocol.PicTime = 2.5; % duration of picture presentation 
Protocol.ITI = 2; % inter trial interval in seconds, rest time between pic presentation
Protocol.TrialLength = 5; % how many blocks (single) pictures should be continiuosly presenetd to the su


save(fullfile(experimentPath,'configfile'),'configfile');

end