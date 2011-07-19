function cls = usbinit(vid, aviobj)
% Remove video input object from memory.
aviobj = close(vid.DiskLogger); 
delete(vid)
clear vid
end