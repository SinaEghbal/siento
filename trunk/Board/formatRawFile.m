%% configure the paths for experiment
config;

%% read daq file format
[data1 t]=daqread(fullfile (processingPath, 'Camr0001.daq'));  
%data=data for all channels
%t=time

isi=length(data1)/length(t);
data1=data1(:,4); %chosen channel
data=bio_cleaner_2ways (1000,50,data1);

%% save the data in .mat format
%save (fullfile (processingPath, 'Camr0001.mat'), 'data', 'isi');

%% plot the raw data and the filtered data
subplot(2,1,1);
plot(data1)
subplot(2,1,2);
plot(data)

%% to plot all channels for testing purpose
% subplot(4,2,1);
% plot(data(3000:6000,1))
% subplot(4,2,2);
% plot(data(3000:6000,2))
% subplot(4,2,3);
% plot(data(3000:6000,3))
% subplot(4,2,4);
% plot(data(3000:6000,4))
% 
% subplot(4,2,5);
% plot(data(3000:6000,5))
% subplot(4,2,6);
% plot(data(3000:6000,6))
% subplot(4,2,7);
% plot(data(3000:6000,7))
% subplot(4,2,8);
% plot(data(3000:6000,8))

