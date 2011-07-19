function playVideo(handles)
config_clip;

mp = handles.MovieControl;
mp2 = handles.MovieControl2;

if (stopAuto)
    set(mp,'enabled',0);
end

mp.controls.pause;
mp2.controls.pause;

currentP  = get(mp.controls,'CurrentPosition');
currentP = currentP - startVid1 + startVid2;
set(mp2.controls,'CurrentPosition',currentP);

mp.controls.play;
mp2.controls.play;

