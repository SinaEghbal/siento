%load emotiomML file
str1=fileread('emotionML.xml');
%emotiomML Parse Variables
str2=xml_parseany(str1);

%% retrieve emotiomML variables to matlab
xmlNS2=str2.ATTRIBUTE.xmlns;

%ecg related information
dateTimeECG=str2.emotion{1}.ATTRIBUTE.date;
catSetECG=str2.emotion{1}.category{1}.ATTRIBUTE.set;
catNameECG=str2.emotion{1}.category{1}.ATTRIBUTE.name;
modMedECG=str2.emotion{1}.modality{1}.ATTRIBUTE.medium;
modModeECG=str2.emotion{1}.modality{1}.ATTRIBUTE.mode;
linkURIECG=str2.emotion{1}.link{1}.ATTRIBUTE.uri;

%emg related information
dateTimeEMG=str2.emotion{2}.ATTRIBUTE.date;
catSetEMG=str2.emotion{2}.category{1}.ATTRIBUTE.set;
catNameEMG=str2.emotion{2}.category{1}.ATTRIBUTE.name;
modMedEMG=str2.emotion{2}.modality{1}.ATTRIBUTE.medium;
modModeEMG=str2.emotion{2}.modality{1}.ATTRIBUTE.mode;
linkURIEMG=str2.emotion{2}.link{1}.ATTRIBUTE.uri;

%gsr related information
dateTimeGSR=str2.emotion{3}.ATTRIBUTE.date;
catSetGSR=str2.emotion{3}.category{1}.ATTRIBUTE.set;
catNameGSR=str2.emotion{3}.category{1}.ATTRIBUTE.name;
modMedGSR=str2.emotion{3}.modality{1}.ATTRIBUTE.medium;
modModeGSR=str2.emotion{3}.modality{1}.ATTRIBUTE.mode;
linkURIGSR=str2.emotion{3}.link{1}.ATTRIBUTE.uri;

%%plot the signals with their labels
%load signals
load (linkURIECG);
load (linkURIEMG);
load (linkURIGSR);

%create figure and plot signals with emotionML variavles
figure1 = figure;

% Create subplot
subplot1 = subplot(3,1,1,'Parent',figure1);
box('on');
hold('all');
% Create plot
plot(ecg,'Parent',subplot1);
% Create title
title(strcat(catSetECG, '-', catNameECG, '(', dateTimeECG, ')'));

% Create subplot
subplot2 = subplot(3,1,2,'Parent',figure1);
box('on');
hold('all');
% Create plot
plot(emg,'Parent',subplot2);
% Create title
title(strcat(catSetEMG, '-', catNameEMG,'(', dateTimeEMG, ')'));

% Create subplot
subplot3 = subplot(3,1,3,'Parent',figure1);
box('on');
hold('all');
% Create plot
plot(gsr,'Parent',subplot3);
% Create title
title(strcat(catSetGSR, '-', catNameGSR,'(', dateTimeGSR, ')'));

% Create textbox
annotation(figure1,'textbox',[0.926 0.795 0.07692 0.05545],'String',{modModeECG});
annotation(figure1,'textbox',[0.926 0.495 0.07692 0.05545],'String',{modModeEMG});
annotation(figure1,'textbox',[0.926 0.195 0.07692 0.05545],'String',{modModeGSR});
