function pauseVideo(handles)
config_clip;
mp = handles.MovieControl;
mp2 = handles.MovieControl2;
mp.controls.pause
mp2.controls.pause

currentP  = get(mp.controls,'CurrentPosition');
currentP = currentP - startVid1 + startVid2;
set(mp2.controls,'CurrentPosition',currentP);
mp.controls.play;
mp2.controls.play;
mp.controls.pause;
mp2.controls.pause;
