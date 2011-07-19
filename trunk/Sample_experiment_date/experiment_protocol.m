%% protocol - describes the experiment for running
% creates a matrix for simulink to read

% protocol[filenames, descriptions, times]

% filenames in the stimulus folder that will be shown
% descriptions: 1 sentence
% times: in secs
% mode could be fixed times or wait for subject to press continue

protocol = { 
    %    fullfile(stimulusPath,'8emotions','Slide01.jpg'),  char('Title
    %    page'),  10;
    fullfile('Sample_experiment_date/Stimulus','8emotions','Slide01.jpg'),  char('Title page'),  10;
    fullfile('Sample_experiment_date/Stimulus','8emotions','Slide02.jpg'),  char('Purpose'), 10};