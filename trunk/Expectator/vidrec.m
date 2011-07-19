function vidrec(vid)
    % Configure the number of frames to be logged.
    set(vid, 'FramesPerTrigger',130);
    % Open a live preview window. Focus camera onto a moving pendulum.
    preview(vid);
    % Initiate the acquisition.
    start(vid);
    % Extract frames from memory.
   % [data, time]=getdata(vid);
end