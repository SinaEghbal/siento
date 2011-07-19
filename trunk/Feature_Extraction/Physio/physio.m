function [mergedfeatmat mergedfeatnames, labels] = physio()
%% Physio.m process physiological data
% preprocess data breaking in windows
% emometric(windowlength, numberofwindows, leadin,leadout,
% processingPath,physioPath)
config;
%format raw .mat physio files to AuBT raw format
emometricnew(20,134,0,0, processingPath,physioPath);

% for each signal extrat features using aubt
 %for filename = {'ecg-files.mat', 'emg-files.mat', 'sc-files.mat'}
 
mergedfeatmat = [];
mergedfeatnames = [];

disp(' ');
disp('Generating dataset for the classification task........');
%read AuBT format physio files
for i=1:3

switch(i)
    case 1
        filename = 'ecg-files.mat'; %ecg
    case 2
        filename = 'sc-files.mat'; %sc
    case 3
        filename = 'emg-files.mat'; %emg

end
%pass parameters to the physio feature extractor 
[featmat featnames] = aubtProxy(processingPath, filename); 
%merge physio feature matrix
mergedfeatmat = [mergedfeatmat featmat];
%merge feature names
mergedfeatnames = strvcat(mergedfeatnames, featnames);
end   %for
labels = load(fullfile(processingPath, 'labels.mat'));

display (' Finished..')
end




