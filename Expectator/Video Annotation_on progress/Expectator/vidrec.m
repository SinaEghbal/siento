function frames = vidrec(vid, k, i2, ts)
%     % Configure the number of frames to be logged.
%     set(vid, 'FramesPerTrigger',100);
%     % Open a live preview window. Focus camera onto a moving pendulum.
%     preview(vid);
%     % Initiate the acquisition.
%     start(vid);
    
    clc; %clear all; 
    img = getsnapshot(vid);
    m=figure;
    h   = imshow(img)%,[],'InitialMagnification',100);
    set(h,'EraseMode','none');
    flag=0;%IAPS control flag
   
    for i=1:10
        clc;
        img = getsnapshot(vid);
        set(h,'CData',img);
                
        if flag == 0 
            %IAPS photo playback
            imgH=IAPS(k, i2, ts);
            set(0,'CurrentFigure',m);
            t1=text(8.2, 8.3, 'IAPS Started','visible','on');
            flag=1;
        end
        
        if i==3
            set(t1,'visible','off');
        elseif i==8
            close(imgH);%close IAPS picture
            t2=text(8.2, 8.3, 'IAPS Ended','visible','on');        
        elseif i>9
            set(t2,'visible','off');
        end
        
        %capture frames for video
         frames(i)= getframe;
    end

end