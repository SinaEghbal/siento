function stopVideo(handles)
mp = handles.MovieControl;
mp2 = handles.MovieControl2;

mp.controls.stop
mp2.controls.stop

config_clip;
set(mp.controls,'CurrentPosition',startVid1);
set(mp2.controls,'CurrentPosition',startVid2);