function [killAcq]=stopAcq(s)
    %KILLACQ
    fwrite(s, 17);%hex-0x15
    killAcq = fread(s);
end