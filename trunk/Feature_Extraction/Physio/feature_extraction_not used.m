%% Aubt Interface function

function aubtProxy(filename)


for i = 1:length (files)
  files{i} = [filepath files{i}];
end

fileNum = length (files);

%featExtractFunc = 'aubt_extractFeatSC (signal, hz)';
featExtractFunc = 'aubt_extractFeatEMG (signal, hz)';
%featExtractFunc = 'aubt_extractFeatRSP (signal, handles.sampleRate)';

for i = 1:fileNum
data = [];
signal = [];
load (files{i}, '-mat');
[featVec, featNames] = eval (featExtractFunc); 
featmat(i,:) = featVec;
end

[filename2 filepath2] = uigetfile ({'*.mat'});
filename2 = [filepath2 filename2];
load (filename2);

featnames = char (featNames);

save ('EMG_Feat.mat', 'featmat', 'labels', 'featnames', 'labelnames');