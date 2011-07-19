%% Run stimulus protocol
% stimulus module loads a series of images (all those in the experiments'
% stimuls directory) and runs the rater (SAM) after each

% Load directory structure
config

% Create an array of filenames that make up the image sequence
%fileFolder = fullfile(stimulusPath,'toolbox','images','imdemos');
dirOutput = dir(fullfile(stimulusPath,'*.jpg'))
fileNames = {dirOutput.name}'
numFrames = numel(fileNames)
global fileNameRec;
% Show each stimulus image
figure;
timeSpan = 10; % time for stimuls in sec

for k = 1:numFrames
      i = imread(fullfile(stimulusPath,fileNames{k}));
      imshow(i);
      title(sprintf('Stimulus Image # %d',k));
      
      % start recording (trigger recording equipment)
      pause(timeSpan);

      % self-report of emotion using SAM or another assessment tool
      fileNameRec=fileNames(k);%store the image filename for sam
      sam;
      
      % wait for the user to be ready for next image
      pause;
      
end