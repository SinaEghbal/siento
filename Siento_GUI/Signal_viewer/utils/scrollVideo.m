function scrollVideo(handles)
global tim;

mp = handles.MovieControl;

config_clip;


mp.controls.pause;

currentP  = get(mp.controls,'CurrentPosition');
if (currentP < startVid1)
    set(mp.controls,'CurrentPosition',startVid1);
    currentP  = get(mp.controls,'CurrentPosition');
end

currentP = currentP - startVid1 + handles.startPhysio;
mp.controls.play;
mp.controls.pause;
set(handles.axes1,'xlim',currentP+[0 physioInterval]);
set(handles.axes2,'xlim',currentP+[0 physioInterval]);
set(handles.axes3,'xlim',currentP+[0 physioInterval]);

stop(tim);