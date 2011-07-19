function [vid] = usbinit()
%create avi file
% my_log = ['vid' '.avi'];
% %apply avi compression
% aviobj = avifile(my_log, 'compression', 'None');

% Access an image acquisition device.
vid = videoinput('winvideo', 1, 'RGB24_352x288');
%vid.LoggingMode = 'disk&memory'; %log mode
% vid.DiskLogger = aviobj; %log object to disk
% set(vid, 'FramesPerTrigger',100);
end

