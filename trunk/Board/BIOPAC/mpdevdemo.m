%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2004 BIOPAC Systems, Inc. (Modifications made by Sazzad, LSG)
%
% This software is provided 'as-is', without any express or implied warranty.
% In no event will BIOPAC Systems, Inc. or BIOPAC Systems, Inc. employees be 
% held liable for any damages arising from the use of this software.
%
% Permission is granted to anyone to use this software for any purpose, 
% including commercial applications, and to alter it and redistribute it 
% freely, subject to the following restrictions:
%
% 1. The origin of this software must not be misrepresented; you must not 
% claim that you wrote the original software. If you use this software in a 
% product, an acknowledgment (see the following) in the product documentation
% is required.
%
% Portions Copyright 2004 BIOPAC Systems, Inc.
%
% 2. Altered source versions must be plainly marked as such, and must not be 
% misrepresented as being the original software.
%
% 3. This notice may not be removed or altered from any source distribution.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function retval = mpdevdemo(dll, dothdir, mptype, mpmethod, sn)
% MPDEVDEMO BIOPAC Hardware API Demonstration for MATLAB
% This function will illustrate how to use the BIOPAC Hardware API in
% MATLAB
% Usage:
%   retval      return value for diagnostic purposes
%   dll         fullpath to mpdev.dll (ie C:\mpdev.dll)
%   dothdir     directory where mdpev.h 
%   mptype      enumerated value for MP device, refer to the documentation
%   mpmethod    enumerated value for MP communication method, refer to the
%   documentation
%   sn          Serial Number of the mp150 if necessary

libname = 'mpdev';
doth = 'mpdev.h';

%parameter error checking
if nargin < 5
    error('Not enough arguements. MPDEVDEMO requires 5 arguemnets');
end

if isnumeric(dll) || isnumeric(dothdir)
    error('DLL and Header Directory has to be string')
end

if exist(dll) ~= 3 && exist(dll) ~= 2
    error('DLL file does not exist');
end

if exist(strcat(dothdir,doth)) ~= 2
    error('Header file does not exist');
end
%end parameter check

%check if the library is already loaded
if libisloaded(libname)
    calllib(libname, 'disconnectMPDev');
    unloadlibrary(libname);
end

%turn off annoying enum warnings
warning off MATLAB:loadlibrary:enumexists;

%load the library
loadlibrary(dll,strcat(dothdir,doth));
fprintf(1,'\nMPDEV.DLL LOADED!!!\n');
libfunctions(libname, '-full');

%begin demonstration
try
    %fprintf(1,'Hit any key to continue...\n');
 pause(1);
    
    %start Acquisition Daemon Demo
    fprintf(1,'Acquisition Daemon Demo...\n');
    retval = startAcquisitionDemo(dothdir,libname,mptype, mpmethod, sn);
   
    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Acquisition Daemon Demo Failed.\n');
        calllib(libname, 'disconnectMPDev')
    end
    
catch
    %disonnect cleanly in case of system error
    calllib(libname, 'disconnectMPDev');
    unloadlibrary(libname);
    %return 'ERROR' and rethrow actual systerm error
    retval = 'ERROR';
    rethrow(lasterror);
end

unloadlibrary(libname);

%-----------------------------------------------------------------

function retval = startAcquisitionDemo(dothdir, libname,mptype, mpmethod, sn)
    %Connect
    fprintf(1,'Connecting...\n');

    [retval, sn] = calllib(libname,'connectMPDev',mptype,mpmethod,sn);

    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Failed to Connect.\n');
        calllib(libname, 'disconnectMPDev');
        return
    end

    fprintf(1,'Connected\n');

    %Configure
    fprintf(1,'Setting Sample Rate to 200 Hz\n');

    retval = calllib(libname, 'setSampleRate', 5.0);

    if ~strcmp(retval,'MPSUCCESS')
       fprintf(1,'Failed to Set Sample Rate.\n');
       calllib(libname, 'disconnectMPDev');
       return
    end

    fprintf(1,'Sample Rate Set\n');
    
    fprintf(1,'Setting to Acquire on Channels 1, 2\n');
    
    %set channels here --> int32(0):channel off, int32(0):channel off 
    aCH = [int32(1),int32(1),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0)];
    
    [retval, aCH] = calllib(libname, 'setAcqChannels',aCH);

    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Failed to Set Acq Channels.\n');
        calllib(libname, 'disconnectMPDev');
        return
    end
    
    fprintf(1,'Channels Set\n');

    %Acquire
    fprintf(1,'Start Acquisition Daemon\n');
    
    retval = calllib(libname, 'startMPAcqDaemon');
  
    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Failed to Start Acquisition Daemon.\n');
        calllib(libname, 'disconnectMPDev');
        return
    end
    
    fprintf(1,'Start Acquisition\n');

    retval = calllib(libname, 'startAcquisition');

    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Failed to Start Acquisition.\n');
        calllib(libname, 'disconnectMPDev');
        return
    end
    
    %Download and Plot 5000 samples in realtime
    fprintf(1,'Download and Plot 5000 samples in Real-Time\n');
    numRead = 0;
    numValuesToRead = 200*3; %collect 1 second worth of data points per iteration
    %change here for recording duration-->>
    remaining = 5000*1; %collect 5000 samples per channel; (n=1, 12.5 sec) 
    %-->>
    tbuff(1:numValuesToRead) = double(0); %initialize the correct amount of data
    bval = 0;
    offset = 1;
    
    % create new figure
    %figure;
    
    global rtCh1;
    global rtCh2;
    %loop until there still some data to acquire
    while(remaining > 0)
       
       if numValuesToRead > remaining
               numValuesToRead = remaining;
       end
       
       [retval, tbuff, numRead]  = calllib(libname, 'receiveMPData',tbuff, numValuesToRead, numRead);
       
       if ~strcmp(retval,'MPSUCCESS')
           fprintf(1,'Failed to receive MP data.\n');
           calllib(libname, 'disconnectMPDev');
           return
       else
            buff(offset:offset+double(numRead(1))-1) = tbuff(1:double(numRead(1))); 
            
            %Process
            len = length(buff);
            ch1data = buff(1:2:len); %channel 1
            ch2data = buff(2:2:len); %channel 2
            %ch15data = buff(3:3:len); %channel 3
            
            X(1:len) = (1:len);
            %plot graph
%             pause(1/100);
%             subplot(2,1,1);
%             plot(X(1:length(ch1data)),ch1data,'g-');
%             title('Data Plot of for Channel 1, 2');
%          %   subplot(2,1,2);
%           %  plot(X(1:length(ch2data)),ch2data,'b-');
% %             subplot(3,1,3);
% %             plot(X(1:length(ch3data)),ch3data,'r-');
%             xlabel('Nth Sample');
            
            rtCh1=ch1data;
            rtCh2=ch2data;
            
            
                       
       end
       offset = offset + double(numValuesToRead);
       remaining = remaining-double(numValuesToRead);
    end
    
    %can save the whole recording as .mat here -->>
%   save ch1data;
%   save ch1data;


  
    %stop acquisition
   fprintf(1,'Stop Acquisition\n');
    
   %disconnect
   fprintf(1,'Disconnecting...\n')
   retval = calllib(libname, 'disconnectMPDev');
   retval = calllib(libname, 'stopAcquisition');
   if ~strcmp(retval,'MPSUCCESS')
       fprintf(1,'Failed to Stop\n');
       calllib(libname, 'disconnectMPDev');
       return
   end


       
%-----------------------------------------------------------------
