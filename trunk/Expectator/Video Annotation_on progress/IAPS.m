function imgH=IAPS(k, i, ts)
    imgH=figure;
    %show image
    figure(imgH),imshow(i);
    title(sprintf('Stimulus Image # %d',k));
    %start recording (trigger recording equipment)
%     pause(ts); %time duration for viewing IAPS image


end