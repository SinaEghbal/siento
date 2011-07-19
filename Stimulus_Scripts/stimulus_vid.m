%% Run stimulus protocol
% stimulus module loads a series of images (all those in the experiments'
% stimuls directory) and runs the rater (SAM) after each

% Load directory structure
config;
% Create an array of filenames that make up the image sequence
%fileFolder = fullfile(stimulusPath,'toolbox','images','imdemos');
dirOutput = dir(fullfile(stimulusPath,'*.jpg'));
fileNames = {dirOutput.name}';
numFrames = numel(fileNames);
global fileNameRec;

% Show each stimulus image
h=figure;
timeSpan = 5; % time for stimuls in sec

%emotionML properties
xmlNS='http://www.w3.org/2008/11/emotiomml';%namespace
v.ATTRIBUTE.xmlns=xmlNS; %namespace variable for emotionML

for k = 1:numFrames
    i = imread(fullfile(stimulusPath,fileNames{k}));
    
    %set/name emotionML category
    catSet='IAPS';
    catName=fileNames{k};
    %category set/name variables for emotionML
    v.emotion(k).category.ATTRIBUTE.set=catSet;
    v.emotion(k).category.ATTRIBUTE.name=catName;
    %initialize camera usb
    [vid, aviobj, my_log] = usbinit();    
    %emotionML video link
    link=my_log;  
    
    %start video recording
    vidrec(vid);
    pause(1);
    %show IAPS image
    figure(h),imshow(i);
    title(sprintf('Stimulus Image # %d',k));
    %the current number of frames written to disk by the DiskLogger 
    frameNo = vid.DiskLoggerFrameCount; 
    %start recording (trigger recording equipment)
    start1=frameNo;
    end1=frameNo + 25;
    annMsg1='Started IAPS';
    
    %link uri variable for emotionML
    v.emotion(k).link.ATTRIBUTE(1).uri=link;
    %link role/start/end variables for emotionML
    v.emotion(k).link(1).ATTRIBUTE.role=annMsg1;
    v.emotion(k).link(1).ATTRIBUTE.start=start1;
    v.emotion(k).link(1).ATTRIBUTE.end=end1;
    %have to take the video frame time information (IAPS started)
    pause(timeSpan);
      
%---------for SAM--------->
%     % self-report of emotion using SAM or another assessment tool
%     fileNameRec=fileNames(k);%store the image filename for sam
%     sam;

    close(h);  % figure closes
    %have to take the video frame time information (IAPS ended)
    frameNo = vid.DiskLoggerFrameCount; %the current number of frames written to disk by the DiskLogger
    start2=frameNo;
    end2=frameNo + 25;
    annMsg2='Ended IAPS';
    %link uri variable for emotionML
    v.emotion(k).link(2).ATTRIBUTE.uri=link;
    v.emotion(k).link(2).ATTRIBUTE.role=annMsg2;
    v.emotion(k).link(2).ATTRIBUTE.start=start2;
    v.emotion(k).link(2).ATTRIBUTE.end=end2;
    %   elapsed_time = getTime(vid,frameNo);
    pause(5);
    usbclose(vid, aviobj);
    % wait for the user to be ready for next image
    %pause;      
end

%% create the XML/emotionML 
str1=xml_formatany(v, 'emotionml');
% Save the XML document.
dlmwrite('emotionML.xml', str1, '')

