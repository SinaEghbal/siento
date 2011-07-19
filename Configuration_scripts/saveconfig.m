% script to save a confguartion file that conatains information about
% subjects name, age, # of emottions, protocol used, lenght of session,
% date of session, clasification performance, classifier name,
% physiological signals used, sampling rate, text on off , path to the files etc...



configfile.SubjectName = 'Omar';
configfile.Subjectage = 25;
configfile.Date = '1/1/2009';
configfile.Protocol = 'AISAP';
configfile.Sessionlenght = 30; % in seconds
configfile.Emotions = labelnames;
configfile.Signals = {'ecg';'emg';'sc'};
configfile.Samplerate = 1000;
configfile.Features = featnames;
configfile.text = 'off'; %on;
configfile.Classresult = results;

save(fullfile(experimentPath,'configfile'),'configfile');