%config;

%% parse emotionML elements
% load emotiomML file
% XMLRepository where the video and xml files are stored
XMLRepository = '/Users/rafa/MATLAB/siento/Expectator/Testing';
str1=fileread(fullfile(XMLRepository,'emotionML.xml'));
%emotiomML Parse Variables
str2=xml_parseany(str1);
%retrieve emotiomML variables to matlab
xmlNS2=str2.ATTRIBUTE.xmlns;

%video annotation related information
catSet=str2.emotion{1}.category{1}.ATTRIBUTE.set;
catName=str2.emotion{1}.category{1}.ATTRIBUTE.name;
linkURI1=str2.emotion{1}.link{1}.ATTRIBUTE.uri;
linkRole1=str2.emotion{1}.link{1}.ATTRIBUTE.role;
linkStart1=str2.emotion{1}.link{1}.ATTRIBUTE.start;
linkEnd1=str2.emotion{1}.link{1}.ATTRIBUTE.end;
linkURI2=str2.emotion{1}.link{2}.ATTRIBUTE.uri;
linkRole2=str2.emotion{1}.link{2}.ATTRIBUTE.role;
linkStart2=str2.emotion{1}.link{2}.ATTRIBUTE.start;
linkEnd2=str2.emotion{1}.link{2}.ATTRIBUTE.end;

%% get the frames from the video
disp(['1.' linkRole1]);
disp(['2.' linkRole2]);

sel=input('Enter Video Segment Choice [1 2]:');

if sel==1
    startT=str2num(linkStart1);
    endT=str2num(linkEnd1);
elseif sel==2
    startT=str2num(linkStart2);
    endT=str2num(linkEnd2);
end

readerObj=mmreader(fullfile(XMLRepository,'vid.avi'));%video frame object
vidFrames=read(readerObj, [startT endT]); %capture the frames
numFrames=(endT-startT)+1;
% numFrames=get(readerObj, 'numberOfFrames');%number of frames

for k=1:numFrames
    mov(k).cdata=vidFrames(:,:,:,k);
    mov(k).colormap=[];
end
%create figure
hf=figure;
set(hf,'position', [150 150 readerObj.Width readerObj.Height]);
movie(hf, mov,1, readerObj.FrameRate);%create movie based on frames
close(hf);%figure closes
