%configure the video file
clear;
vidObj=mmreader('DELTA.MPG');
vidFrames=read(vidObj);
m=myplay(vidFrames);
emolabel;
