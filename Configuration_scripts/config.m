%% configure experiment folder
% uncomment Mac or Windows

% % Mac
% tmlPath = fullfile('/Users/rafa/MATLAB/','tml')
% experimentPath = '/Users/rafa/Desktop/Matlab/siento-exps/Mar23/'
% processingPath = fullfile(experimentPath,'Processing')
% textPath= fullfile(experimentPath,'Text')
% physioPath= fullfile(experimentPath,'Physio')
% stimulusPath = fullfile(experimentPath,'Stimulus')
% fileName_convertor='camrS001R01'; %name of first file only


% Windows
tmlPath = fullfile('C:\Matlab','tml');
experimentPath = 'C:\Experiment\Apr30-09';
processingPath = fullfile(experimentPath,'Processing');
%textPath= fullfile(experimentPath,'Text');
physioPath= fullfile(experimentPath,'Physio');
stimulusPath = fullfile(experimentPath,'Stimulus');
protocolPath = fullfile(experimentPath,'Protocol');
SAMPath = fullfile(experimentPath,'SAM');
fileName_convertor='omarS001R01'; %name of first file only
path_dll='C:\Matlab\Siento\lib\BHAPI\mpdev.dll';
path_lib='C:\Matlab\Siento\lib\BHAPI\';
numSets=3;     %number of photo sets

%--------->>>>     CHANGE raw file name according to BCI2000 format
% fileName_convertor='camrS001R01'; %name of first file only
%--------->>>>     ------------------------------------------------

