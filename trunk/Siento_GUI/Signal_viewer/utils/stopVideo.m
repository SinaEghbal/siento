function stopVideo(handles)
global tim;

mp = handles.MovieControl;

mp.controls.stop

currentP = handles.startPhysio;

config_clip;
set(handles.axes1,'xlim',currentP+[0 physioInterval]);
set(handles.axes2,'xlim',currentP+[0 physioInterval]);
set(handles.axes3,'xlim',currentP+[0 physioInterval]);

stop(tim);