function playVideo(handles)
global tim;
config_clip;

mp = handles.MovieControl;

mp.controls.pause;

currentP  = get(mp.controls,'CurrentPosition');
currentP = currentP - startVid1 + handles.startPhysio;

mp.controls.play;

set(handles.axes1,'xlim',currentP+[0 physioInterval]);
set(handles.axes2,'xlim',currentP+[0 physioInterval]);
set(handles.axes3,'xlim',currentP+[0 physioInterval]);

    
start(tim)
