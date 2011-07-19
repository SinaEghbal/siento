%% liveView - live viewer for daq board

% configure the path for the experiment
config;

%% script for data acquisition
% create an analoginput object
ai = analoginput('nidaq','1'); %Dev1

% Set inputtype to NonReferencedSingleEnded
set(ai,'InputType','NonReferencedSingleEnded');

%add input channels (no semi-colon to display results)
%addchannel(ai,0,'CH0')
%addchannel(ai,1,'CH1');
%addchannel(ai,2,'CH2');
%addchannel(ai,3,'CH3');
addchannel(ai,4,'CH4');
%addchannel(ai,5,'CH5');
%addchannel(ai,6,'CH6');
%addchannel(ai,7,'CH7');
%addchannel(ai,8,'CH8');
%addchannel(ai,9,'CH9');
%addchannel(ai,10,'CH10');
%addchannel(ai,11,'CH11');
%addchannel(ai,12,'CH12');

% configure property values
% set logging mode
set(ai,'LoggingMode','Disk&Memory');
set(ai,'LogFileName',fullfile (processingPath,'Camr0001'));
set(ai,'LogToDiskMode','index');

true_srate = setverify(ai,'SampleRate',1024)
duration = 100;                % seconds of acquisition
slength = duration*true_srate  % number of samples in duration

set(ai, 'SampleRate',true_srate)
set(ai,'SamplesPerTrigger',slength)

preview = slength/100;
subplot(211)

%figure
P = plot(zeros(preview,1));
grid on;
T = title([sprintf('Peekdata calls: '), num2str(0)]);
xlabel('Samples'); 
ylabel('Signal Level (mVolts)')
axis([0 10000 -5 5]), grid on


% Acquire data
start(ai)
i = 5;
while ai.SamplesAcquired < ai.SamplesPerTrigger
    while ai.SamplesAcquired < 10000*i
    end
    data = peekdata(ai, 10000);
    data(:)=bio_cleaner_2ways (1000,50,data(:)); %filter channel
    set(P,'ydata',data);
    set(T,'String', [sprintf('Peekdata calls: '), num2str(i)]);
    drawnow
    i = i+ 1;
end
% make sure ai has tsopped running
wait(ai,2);

% clean up
delete(ai)
clear ai
