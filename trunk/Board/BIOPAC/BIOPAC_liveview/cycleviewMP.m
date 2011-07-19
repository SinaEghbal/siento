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


function retval = cycleviewMP(dll, dothdir, mptype, mpmethod, sn)
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

    retval = calllib(libname, 'setSampleRate', 1.0);

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
    remaining = 5000*3; %collect 5000 samples per channel
    tbuff(1:numValuesToRead) = double(0); %initialize the correct amount of data
    bval = 0;
    offset = 1;
    
% create new figure
% figure;%commented

% Empty figures

%--------cyclelife--->>
% pl1 = subplot(321);
% pl2 = subplot(322);
% pl3 = subplot(323);
% pl4= subplot(324);
% pl5 = subplot(325);
% pl6 = subplot(326);
%--------cyclelife--->>
figure1 = figure('PaperSize',[20.98 29.68]);   
    
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
%             buff(offset:offset+double(numRead(1))-1) = tbuff(1:double(numRead(1))); 
            buff(1:double(numRead(1)))= tbuff(1:double(numRead(1)));
            %Process
            len = length(buff);
            
            %--------cyclelife--->>
            duration=len/600;
            srate=200; %sample rate
            ts = (0:srate*duration-1)/srate;          % samples in duration
%             xlabel('Samples'); 
%             ylabel('Signal Level (mVolts)')
%             axis([pl1 pl3 pl5],[0 duration -5 5]), grid on
%             axis([pl2 pl4 pl6],[0 100 0 5]), grid on
            %--------cyclelife--->>
            
            ch1data = buff(1:3:len);%data from channel 1(ecg)
            ch2data = buff(2:3:len);%data from channel 2(emg)
            
            X(1:len) = (1:len);
            %plot graph
            pause(1/100);

%--------cyclelife--->>
% prepare for FFT
T = 1/srate;                     % Sample time
% L = 1000;                     % Length of signal
% t = (0:L-1)*T;                % Time vector
t = duration;
L = t * srate;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
widthFT = NFFT/2+1; % xaxis width 
%widthFT =100;
f = srate/2*linspace(0,1,widthFT);

% clean and plot

% raw ecg data: data(:,ecg_column)
% and FFT
Y = fft(ch1data,NFFT)/L;
widthFT = NFFT/2+1; % xaxis width 
% Plot single-sided amplitude spectrum.
REcgFT = 2*abs(Y(1:widthFT));

%  filtered ECG data
ecg = bio_cleaner_rafa (srate,40,ch1data);

% and FFT 
Y = fft(ecg,NFFT)/L;
%widthFT = NFFT/2+1; % xaxis width 
ecgFT = 2*abs(Y(1:widthFT));

% filetered EMG data
emg = bio_cleaner_rafa (srate,40,ch2data);
% And FFT
Y = fft(emg,NFFT)/L;
emgFT = 2*abs(Y(1:widthFT));

%  X1:  vector of x data - time
X1 = ts;
%  Y1:  vector of y data - raw ecg
Y1 = ch1data;
%  X2:  vector of x data - freq
X2 = f;
%  Y2:  vector of y data - Raw ecg FT
Y2 = REcgFT;
%  Y3:  vector of y data - Filt ECG
Y3 = ecg;
%  Y4:  vector of y data  - Filt ECG FT
Y4 = ecgFT;
%  Y5:  vector of y data - Filt EMG
Y5 = emg;
%  X3:  vector of x data - Freq
X3 = f;
%  Y6:  vector of y data - Filt EMG FT
Y6 = emgFT;

%AUBT features--------->>
% calculate heart beat
rind = aubt_detecR (ecg, srate);
% rrintervals = diff (double (rind)) ./ srate;
% hrv = 60./rrintervals;  % beats per minute
rr = double(diff (rind));

mHRV = mean (rr) %mean HRV
sHRV = std (rr) %strandard dev HRV

mEMG=mean(emg);%mean EMG
sEMG=std (emg);%standard dev EMG
%---------------------->> 

createfigure(figure1, X1, Y1, X2, Y2, Y3, Y4, Y5, X3, Y6, mHRV, sHRV, mEMG, sEMG);

%---------cyclelive-------->>
       end
       offset = offset + double(numValuesToRead);
       remaining = remaining-double(numValuesToRead);
    end
   
   %stop acquisition
   fprintf(1,'Stop Acquisition\n');

   retval = calllib(libname, 'stopAcquisition');
   if ~strcmp(retval,'MPSUCCESS')
       fprintf(1,'Failed to Stop\n');
       calllib(libname, 'disconnectMPDev');
       return
   end
    
   %disconnect
   fprintf(1,'Disconnecting...\n')
   retval = calllib(libname, 'disconnectMPDev');

    

%-----------------------------------------------------------------
