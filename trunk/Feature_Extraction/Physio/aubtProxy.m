%% Aubt Interface function
% filename: input raw data
% outFolder: folder where files are created

function [featmat  featnames labels] = aubtProxy(processingPath, filename)
labels = 'labels.mat'; %physio labels
libPath = 'lib';

%load the specific physio file
load (fullfile(processingPath, filename));

%read all physio files (chunks)
for i = 1:length (files)
  files{i} = [files{i}];
end

fileNum = length (files);

%extract physio features
 switch filename 
    
     case 'sc-files.mat'
         featExtractFunc = 'aubt_extractFeatSC (signal, hz)';

     case 'emg-files.mat' 
        featExtractFunc = 'aubt_extractFeatEMG (signal, hz)';
        
     case 'ecg-files.mat' 
         featExtractFunc = 'aubt_extractFeatECG (signal, hz)';
      
end

for i = 1:fileNum
data = [];
signal = [];
load (files{i}, '-mat');
[featVec, featNames] = eval (featExtractFunc); 
featmat(i,:) = featVec;
end

load (fullfile(processingPath,labels));

featnames = char (featNames);

save (fullfile(processingPath,[filename 'Feat.mat']), 'featmat', 'labels', 'featnames', 'labelnames');
end