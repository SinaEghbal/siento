function handle_event_PlayState(varargin)
global ghandles;
%HANDLE_EVENT_PLAYER1 Summary of this function goes here
%   Detailed explanation goes here

playState1 = get(ghandles.MovieControl,'playState')

if (strcmp(playState1,'wmppsTransitioning'))
    
elseif (strcmp(playState1, 'wmppsStopped'))
    stopVideo(ghandles);
elseif (strcmp(playState1, 'wmppsPaused'))
    pauseVideo(ghandles);    
elseif (strcmp(playState1, 'wmppsPlaying'))
    playVideo(ghandles);
elseif (strcmp(playState1, 'wmppsMediaEnded'))
   
elseif (strcmp(playState1, 'wmppsScanForward'))
    ghandles.MovieControl.controls.fastForward;
    ghandles.MovieControl2.controls.fastForward;
elseif (strcmp(playState1, 'wmppsScanReverse'))
    ghandles.MovieControl.controls.fastReverse;
    ghandles.MovieControl2.controls.fastReverse;    
end

%doubleVid.playVideo(ghandles)
end

