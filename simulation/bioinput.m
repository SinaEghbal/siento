function [sammat,ch1,ch2,ch3,ch4]=bioinput()
config;
dirOutput = dir(fullfile(stimulusPath,'*.jpg'));
fileNames = {dirOutput.name}';
numFrames = numel(fileNames);
global fileNameRec;
figure;
timeSpan = 1; %time for reviewing physiological data
sizeSets=length(fileNames)/numSets;
k=1;
j=0;
load (fullfile(processingPath,'simu_data_index.mat'), 'j','k');
if(j==0 && k==1)
    experiment_protocol;
    run_protocol;
    j=1;
end
if(k>(sizeSets*j))
    j=j+1; %increment set number
    if(j>numSets)
        %display thank you screen, hold for 30 seconds and terminate
        i=imread(fullfile(protocolPath,strcat('end',int2str(j-1),'.jpg')));
        imshow(i);Maximize(figure(1));
        pause(30);
        model_terminate;
    end
    if(j~=1)
        %display intermediate screen and pause for 2 minutes
        i=imread(fullfile(protocolPath,strcat('end',int2str(j-1),'.jpg')));
        imshow(i);Maximize(figure(1));
        pause();
    end
    %prompt user input to begin next set of slides
    i=imread(fullfile(protocolPath,strcat('start',int2str(j),'.jpg')));
    imshow(i);Maximize(figure(1));
    pause;
end
i=imread(fullfile(protocolPath,strcat('prep.jpg')));
imshow(i);Maximize(figure(1));
pause(2);
i = imread(fullfile(stimulusPath,fileNames{k}));
imshow(i);Maximize(figure(1));
title(sprintf('Stimulus Image # %d',k));

%pause(60); %pause after stimulus display but before trigger recording
% start recording (trigger recording equipment)
mpdevdemo(path_dll,path_lib,'MP150','MPUDP','610A-00007DE');
global rtCh1;
global rtCh2;
global rtCh3;
global rtCh4;
ch1=rtCh1;
ch2=rtCh2;
ch3=rtCh3;
ch4=rtCh4;

%save raw signal data to .mat file
save(fullfile(physioPath,strcat('Image',int2str(k))),'ch1','ch2','ch3','ch4');

%Plot
subplot(2,2,1);
plot(ch1);
subplot(2,2,2);
plot(ch2);
subplot(2,2,3);
plot(ch3);
subplot(2,2,4);
plot(ch4);
pause(timeSpan);
close all;

% self-report of emotion using SAM or another assessment tool
fileNameRec=fileNames(k);

sam;
% global time1;
% wait(time1);
global a;
global v;
%load (fullfile(SAMPath,'rate.mat'),'v','a');
sammat=[a,v];

%save sam report to .mat file
save(fullfile(SAMPath,strcat('Image',int2str(k))),'sammat');
%increment image index
k=k+1;
save (fullfile(processingPath,'simu_data_index.mat'), 'k','j');