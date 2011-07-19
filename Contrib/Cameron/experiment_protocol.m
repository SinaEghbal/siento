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
    fullfile(protocolPath,'Slide01.jpg'),  char('Slide01'),  [];
    fullfile(protocolPath,'Slide02.jpg'),  char('Slide02'),  [];
    fullfile(protocolPath,'Slide03.jpg'),  char('Slide03'),  [];
    fullfile(protocolPath,'Slide04.jpg'),  char('Slide04'),  [];
    fullfile(protocolPath,'Slide05.jpg'),  char('Slide05'),  [];
    fullfile(protocolPath,'Slide06.jpg'),  char('Slide06'),  [];
    fullfile(protocolPath,'Slide07.jpg'),  char('Slide07'),  [];
    fullfile(protocolPath,'Slide08.jpg'),  char('Slide08'),  [];
    fullfile(protocolPath,'Slide09.jpg'),  char('Slide09'),  [];
    fullfile(protocolPath,'Slide10.jpg'),  char('Slide10'),  [];
    fullfile(protocolPath,'Slide11.jpg'),  char('Slide11'),  [];
    fullfile(protocolPath,'Slide12.jpg'),  char('Slide12'),  [];
    fullfile(protocolPath,'Slide13.jpg'),  char('Slide13'),  [];
    fullfile(protocolPath,'Slide14.jpg'),  char('Slide14'),  [];
    fullfile(protocolPath,'Slide15.jpg'),  char('Slide15'),  [];
    fullfile(protocolPath,'Slide16.jpg'),  char('Slide16'),  [];
    %fullfile('Sample_experiment_date/Stimulus','8emotions','Slide02.jpg'),  char('Purpose'), 10};
   };