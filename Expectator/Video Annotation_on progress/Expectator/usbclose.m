function cls = usbinit(vid)
% Remove video input object from memory.
% aviobj = close(vid.DiskLogger); 
delete(vid)
clear vid
end