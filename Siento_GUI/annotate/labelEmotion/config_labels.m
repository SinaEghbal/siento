mylabels={
    'Hot' 
    'Curious' 
    'Bored' 
    'Sexy'
    'Frustrated' 
    'Bing'
    }

if length(mylabels)>12
    h=msgbox('Some Labels My Not Appear','Exceeded Maximum Labls','warn') 
    pause(4);
    close(h);
end