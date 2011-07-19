function [setCh, setChValue]=setCh(s, channels)
    %send command for channel setup
    fwrite(s,18);%hex-0x12
    setCh1 = fread(s);
    setCh=setCh1

    s.RequestToSend = 'off';
    s.RequestToSend = 'on';

    %send active channels
    fwrite(s,  bin2dec(channels), 'uint32');
    setChValue1 = fread(s);
    setChValue = setChValue1
end
