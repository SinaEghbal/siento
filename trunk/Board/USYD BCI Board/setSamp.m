function [setsamp, samprate]=setSamp(s, sampRate)
    %send command for sample rate setting
    fwrite(s, 20);%hex-0x14
    setsamp1 = fread(s);
    setsamp=setsamp1

    s.RequestToSend = 'off';
    s.RequestToSend = 'on';

    %SETSRATE value
    msg1=char(bitshift(sampRate,-8));
    msg2=char(sampRate);
    msg=[msg1 msg2];

    fwrite(s, msg, 'char');
    samprate1 = fread(s);
    samprate= samprate1(1)*256 + samprate1(2)
end
