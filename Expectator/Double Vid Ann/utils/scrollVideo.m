function scrollVideo(handles)
mp = handles.MovieControl;
mp2 = handles.MovieControl2;

config_clip;


mp.controls.pause;
mp2.controls.pause;

currentP  = get(mp.controls,'CurrentPosition');
if (currentP < startVid1)
    set(mp.controls,'CurrentPosition',startVid1);
    currentP  = get(mp.controls,'CurrentPosition');
end

currentP = currentP - startVid1 + startVid2;
set(mp2.controls,'CurrentPosition',currentP);
mp.controls.play;
mp2.controls.play;
mp.controls.pause;
mp2.controls.pause;
