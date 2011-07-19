%% PHYSIO Data Marker & EMOTIONML Creator
 %get physio file and the annotation file
 %sync the physio file with annotaion timing
 %create emotionml files with physio links with corresponding emotions
  
 %Steps:
 %open matlab data file
 load 'siento_sub1_2009-11-13_2';
 ECG=data(:,1);
 GSR=data(:,2);
 EMG=data(:,3);


% config_sync;
timePhysioAbs=hms2sec(11,42,52);
timeVidAbs=hms2sec(11,43,41);
 
A = importdata('new_video.txt');

vidStart = regexp(A(1),',','split');
vidStartT=vidStart{:};

physioStartT = abs((timePhysioAbs-timeVidAbs)) + str2num(char(vidStartT(2)));

j=1;
while j<=length(A)
    splitAnn=regexp(A(j),',','split');
    splitAnn=splitAnn{:};
    labelStartT=str2num(char(splitAnn(2)));
    labelEndT=str2num(char(splitAnn(3)));
    affect = char(splitAnn(4));
 
    physioEndT=physioStartT + (labelEndT - labelStartT);
    
    ecgAffect=ECG(physioStartT*1000:physioEndT*1000);
    save(['ecg/ecg' int2str(j)] ,'ecgAffect', 'affect');
    
    gsrAffect=EMG(physioStartT*1000:physioEndT*1000);
    save(['gsr/emg' int2str(j)] ,'gsrAffect', 'affect');
    
    emgAffect=ECG(physioStartT*1000:physioEndT*1000);
    save(['emg/emg' int2str(j)] ,'emgAffect', 'affect');

    physioStartT=labelEndT
    j=j+1;
end















