for i = 1:16
    file = protocol{i,1}
    desc = protocol{i,2}
    time = protocol{i,3}
    rgb = imread(file,'jpeg');
%     dim=length(size(rgb));
%     if(dim(3)==1)
%         rgb(:,:,2)=rgb(:,:,1);
%         rgb(:,:,3)=rgb(:,:,1);
%     end
    imshow(rgb);
    Maximize(figure(1));
    %image(rgb);
    %pause(time);
    pause();
   
end
close all;