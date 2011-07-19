function [s]=openPort(portN)
%creats serial object, opens port & replys status of port
    s=serial(portN);%create port object
    %set serial properties
    set(s,'BaudRate',921600,'DataBits',8,'Parity','none','StopBits',1);
    s.FlowControl = 'none';
    InputBufferSize=2048;%serial read buffer size in byte
    fopen(s);%open port
    message = s.status%reply port status
end