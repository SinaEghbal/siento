%configure the video file
clear;
vidObj=mmreader('DELTA.MPG');
vidFrames=read(vidObj);

m=myplay(vidFrames);
%startup the affect label module
emolabel;


% [s,w] = dos('tasklist');
% nProcesses = numel(regexp(w,'(^|\n)MATLAB.exe'));
% for n = 1:(3-nProcesses),  % Starts new processes if there are less than 3
%   dos('MATLAB R2009a -nosplash -r why &');  % Starts a process and runs the
%                                             %   built-in function "why.m"
% end
