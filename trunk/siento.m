%% siento.m
% package for processing text and physiological signals

%% configuration
% all global parameters refering to the code location and experiment is set
% up in config. This file will have to be customized for each
% computer/user. Only commit changes that should be taken into all configs
% (e.g. new parameters)
warning off all;
config;


%% read data about specific experiment
%open(experimentPath/exp.txt)

%% for Text
% Import all docs in Folder to Matla - >generate Fi
% import text file using tml
% check the number of files - assert
% OUTPUT: matrix D (E, FeatD)
%init
%[ D  T  M ]= textProc(textPath,tmlPath);

%D = textProc('/Users/rafa/Desktop/Matlab/siento-exps/Mar23/Text','/Users/rafa/MATLAB/tml');

%% human tag
% read text file
% OUTPUT: matrix T(E,1)

%% for Physio
% ask for parameters: sampling freq, time window
% for each emotion/photo E in folder F
% import MAT file from ACQ
% import Tag file
% break it in chuncks for Augsgbio -> saved in temp
% convert to feature (using augsburg)
% OUTPUT: matrix P ( E, FeatP, T)
% [filename filepath] = uigetfile ({'*.mat'});
% filename = [filepath filename];

%convert files to .matlab
%convertor

% run physio code
load (fullfile(processingPath,'labels.mat'));
disp('Processing physiological data and breaking it into windows...... ');
disp(' ');
physio;
disp(' ');
disp('Running Classifier.....');
disp(' ');

% mergedfeatmat = [labels mergedfeatmat];
% mergedfeatmat = sortrows(mergedfeatmat,1);

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% // added omar to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% integrate tml data with
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% physio data
% norowsemotion = length(D)/length(labelnames); % Determine how many files we have for each emotion D is the tml doc matrix 
% noofrep = length(labels)/length(labelnames);   % Determine how many times do we need to repeat the tml data rows to conform with the # of rows in physio data
%  temp = 1;                       
%  x = [];
%  for i= 1:length(labelnames)
%   x1 = M(temp:i*norowsemotion,:);     
%   x1 = repmat(x1,noofrep,1);
%   temp = i*norowsemotion + 1;
%   x = [ x; x1];
% end
% 
%  mergedfeatmat = [mergedfeatmat x];
%  
% [l k] = size(M);
%  
%z = 1:K; % give label names to the tml word list as numbers 1 to ..
%mergedfeatnames = [mergedfeatnames z];
 
% dataset = [mergedfeatnames; mergedfeatmat];

 dataset =  mergedfeatmat;



%% for SAM
% read text file or scrupt for entry data
%OUTPUT: matrix S(E, 15)


%% Merge
% D = [D E S T]

%% Classifier model M
% 10 fold cross validation
% run weka?
% OUTPUT: report on accuracy for M
%load (fullfile(processingPath,'labels.mat'));
run_classifier1('knn', dataset, labels)
%results = run_classifier('knn', dataset, labels)
%fisherproject;
%results;

%% save report for future use
% report would include the information in 
%saveconfig;
%disp(results)
