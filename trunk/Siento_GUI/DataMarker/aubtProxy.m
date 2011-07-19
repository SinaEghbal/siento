%% Aubt Interface function
% filename: input raw data
% outFolder: folder where files are created

function [featmat1  featnames1 featmat2  featnames2 featmat3  featnames3] = aubtProxy(ecg, gsr, emg, hz)

% featmat1='dd';
% featnames1='uu';
[featmat1, featnames1] = aubt_extractFeatECG (ecg, hz);
[featmat2, featnames2] = aubt_extractFeatSC (gsr, hz);
[featmat3, featnames3] = aubt_extractFeatEMG (emg, hz);
%       
% [featVec, featNames] = eval (featExtractFunc); 
% featmat(i,:) = featVec;

% save (fullfile(processingPath,[filename 'Feat.mat']), 'featmat', 'labels', 'featnames', 'labelnames');
end