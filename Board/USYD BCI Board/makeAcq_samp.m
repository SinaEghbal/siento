function [signalAcq] = makeAcq_samp(samp1, samp2)
%accept 2 bytes and convert them to 1 byte decemals
    signalAcq=[];

    strStore1=bitshift(samp2, 8);%8 bit left shift on MSB
    strStore2=samp1;%LSB
    signalAcq=strStore1+strStore2;%i byte/1 sample point
end

