%% liveView - live viewer for daq board

% configure the path for the experiment
config;

%% script for data acquisition
% create an analoginput object
ai = analoginput('winsound'); %Dev1

% Set inputtype to NonReferencedSingleEnded
%set(ai,'InputType','NonReferencedSingleEnded');

addchannel(ai,1);

% configure property values
% set logging mode
set(ai,'LoggingMode','Disk&Memory');
set(ai,'LogFileName',fullfile (processingPath,'Camr0001'));
set(ai,'LogToDiskMode','index');

true_srate = setverify(ai,'SampleRate',44100)
duration = 10;                % seconds of acquisition
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
axis([0 10000 -0.2 0.2]), grid on


% Acquire data
start(ai)
i = 5;
while ai.SamplesAcquired < ai.SamplesPerTrigger
    while ai.SamplesAcquired < 2048*i
    end
    data = peekdata(ai, 10000);
    cl_data= bio_cleaner_2ways (44100,50,data(:)); %filter channel
    set(P,'ydata',data);
    set(T,'String', [sprintf('Peekdata calls: '), num2str(i)]);
    drawnow
    i = i+ 1;
end
% make sure ai has tsopped running
% wait(ai,2);
% data = getdata(ai)
% plot(data)

% clean up
delete(ai)
clear ai
