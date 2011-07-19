for i = 1:2
    file = protocol{i,1}
    desc = protocol{i,2}
    time = protocol{i,3}
    rgb = imread(file);
    image(rgb);
    pause(time);
   
end