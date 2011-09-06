%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering
%   University of Sydney, 2011
%------------------------------------------------------------------
%------------------------------------------------------------------

% %%Sync & Feature Extraction Program (IAPS-Cognitive Physio Data)
%channels: ECG, EMG, GSR, Resp

function [featExt]=vHeart_FeatEx_EmoCog(subjectID,filesPath,winSizeECG,sRate,dSample,featdir)

warning off all;
filesDir=dir(filesPath);%dir info for files path
x=1;
for m=1:length(filesDir)
    [path,name,ext,ver] = fileparts(filesDir(m).name);
    for n=1:length(subjectID(:,1))
        if strncmp(subjectID(n,:),name,22)%choose only selected subjects
            if strcmp(ext,'.mat')%.mat files
                loadPhysio(x,:)=[filesPath '\' name ext];%.mat physio path
                physioSplit= regexp(name,'_','split');
                physioATS(x,:)=physioSplit(4);%physio abs time stamp
                x=x+1;
            elseif strcmp(ext, '.txt')%.txt files
                loadAnn(x,:)=[filesPath '\' name ext];%.txt annotation path
            end
        end
    end
end
mkdir(featdir);%create directory for features (.mat)

for j=1:(x-1)
    load(loadPhysio(j,:));%load physio file
    
    data=downsample(data,dSample);%-->down sample all physio channels
    nsRate=(sRate/dSample);%new sample rate
    lenPhysio=size(data,1);%length of physio data
    
    fid = fopen(loadAnn(j,:));%load annotation
    C = textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s','delimiter', ',');
    fclose(fid); 

    subjectFeatDir=[featdir '\'];
    mkdir(subjectFeatDir);%create directory for features 
    Absolute_Time = datenum(physioATS(j), 'HH-MM-SS')*24*60*60; %in seconds
    
    %annotation
    emotionCat=C{2};    %given emotion 
    taskLevel=C{3};     %given task level 
    startXX=C{4};       %start of IAPS
    startT=C{5};        %start of task
    endT_NT=C{6};       %end image(no tasks)
    selfTask=C{9};      %report task
    selfEmotion=C{10};  %report emotion
    
    lenFile=length(C{1}(:,1));
    emotionCat=emotionCat(3:(lenFile-1)); %given emotion 
    taskLevel=taskLevel(3:(lenFile-1)); %given task level        
    startT=vertcat(startT(3:12), endT_NT(13:24), startT(25:(lenFile-1))); %start of task
    selfTask=selfTask(3:(lenFile-1)); %report task
    selfEmotion=selfEmotion(3:(lenFile-1)); %report emotion

    for t=1:length(startT)
        startTime=char(startT{t});
        if t<=10 | t>=23
            %task only and task+emotion instances
%             start_times(t) = datenum(startTimeXX,'HH:MM:SS')*24*60*60; % emotion in seconds
            start_times(t) = datenum(startTime,'HH:MM:SS')*24*60*60; % task in seconds
        else
            %IAPS/Emotion only instances (due to expriment program bug)
%             start_times(t) = (datenum(startTimeXX,'HH:MM:SS')*24*60*60)-14; % emoiton in seconds
            start_times(t) = (datenum(startTime,'HH:MM:SS')*24*60*60)-14; % task in seconds
        end
    end

    k = 1;
    featmat = [];
    featmatECG = [];
    featmatGSR = [];
    featmatRESP = [];
    valCatVec=[];
    arCatVec=[];
    dimCatVec=[];
    valSelfVec=[];
    arSelfVec=[];
    dimSelfVec=[];
    taskCatVec=[];
    taskSelfVec=[];
 
    while k <= length (start_times)
        Start_Trial = start_times(k); % in seconds
        Start_Index = (Start_Trial - Absolute_Time) * nsRate;   %--> start time        
        End_IndexECG = (Start_Index + winSizeECG * nsRate)-1;   %--> end time for ecg window
        
        if lenPhysio<End_IndexECG
            break;
        end        
        Trial_ChunkECG = data(Start_Index:End_IndexECG,1); %trial chunk        
        ecgAffect= Trial_ChunkECG;%ecg data
                
        %feature extraction from ecg
        [ECGfeatvc ECGfeatnames] = vHeart_extractFeatECG (ecgAffect,nsRate);
        featmat = [featmat;ECGfeatvc];           

        %extracting theoretical categories          
            if strcmp(emotionCat(k), '0-NoP_Task')
                valCat={'TaskOnly'};
                arCat={'TaskOnly'};
                dimCat={'TaskOnly'};
            elseif strcmp(emotionCat(k), '1-Pic_NoT')
                valCat={'ImageOnly'};
                arCat={'ImageOnly'};
                dimCat={'ImageOnly'};
            elseif strcmp(emotionCat(k), '2-HV_LA')
                valCat={'HighValence'};
                arCat={'LowArousal'};
                dimCat={'HighValence-LowArousal'};
            elseif strcmp(emotionCat(k), '3-HV_MA')
                valCat={'HighValence'};
                arCat={'MediumArousal'};
                dimCat={'HighValence-MediumArousal'};
            elseif strcmp(emotionCat(k), '4-HV_HA')
                valCat={'HighValence'};
                arCat={'HighArousal'};
                dimCat={'HighValence-HighArousal'};
            elseif strcmp(emotionCat(k), '5-LV_LA')
                valCat={'LowValence'};
                arCat={'LowArousal'};
                dimCat={'LowValence-LowArousal'};
            elseif strcmp(emotionCat(k), '6-LV_MA')
                valCat={'LowValence'};
                arCat={'MediumArousal'};
                dimCat={'LowValence-MediumArousal'};                
            elseif strcmp(emotionCat(k), '7-LV_HA')
                valCat={'LowValence'};
                arCat={'HighArousal'};
                dimCat={'LowValence-HighArousal'};
            end
            valCatVec = [valCatVec;valCat];
            arCatVec = [arCatVec;arCat];
            dimCatVec = [dimCatVec;dimCat];
        
        %extracting self reports
        if strcmp(selfEmotion(k),'1')
            valSelf={'MediumValence'};
            arSelf={'LowArousal'};
            dimSelf={'MediumValence-LowArousal'};
        elseif strcmp(selfEmotion(k),'2')
            valSelf={'HighValence'};
            arSelf={'LowArousal'};
            dimSelf={'HighValence-LowArousal'};
        elseif strcmp(selfEmotion(k),'3')
            valSelf={'MediumValence'};
            arSelf={'MediumArousal'};
            dimSelf={'MediumValence-MediumArousal'};
        elseif strcmp(selfEmotion(k),'4')
            valSelf={'HighValence'};
            arSelf={'MediumArousal'};
            dimSelf={'HighValence-MediumArousal'};
        elseif strcmp(selfEmotion(k),'5')
            valSelf={'HighValence'};
            arSelf={'HighArousal'};
            dimSelf={'HighValence-HighArousal'};
        elseif strcmp(selfEmotion(k),'6')
            valSelf={'MediumValence'};
            arSelf={'HighArousal'};
            dimSelf={'MediumValence-HighArousal'};
        elseif strcmp(selfEmotion(k),'7')
            valSelf={'LowValence'};
            arSelf={'HighArousal'};
            dimSelf={'LowValence-HighArousal'};
        elseif strcmp(selfEmotion(k),'8')
            valSelf={'LowValence'};
            arSelf={'MediumArousal'};
            dimSelf={'LowValence-MediumArousal'};
        elseif strcmp(selfEmotion(k),'9')
            valSelf={'LowValence'};
            arSelf={'LowArousal'};
            dimSelf={'LowValence-LowArousal'};
        else
            valSelf={'TaskOnly'};
            arSelf={'TaskOnly'};
            dimSelf={'TaskOnly'};
        end
        valSelfVec = [valSelfVec;valSelf];
        arSelfVec = [arSelfVec;arSelf];
        dimSelfVec = [dimSelfVec;dimSelf];
        
        taskCatVec=[taskCatVec,taskLevel(k)];%task level vector
        taskSelfVec=[taskSelfVec,selfTask(k)];%task report vector
        
        subjectID(j,:)
        k = k+ 1
    end
    
featmat = num2cell(featmat);
featMatClass = [featmat,dimCatVec,valCatVec,arCatVec,dimSelfVec,valSelfVec,...
    arSelfVec, taskCatVec', taskSelfVec'];    
featnames = [ECGfeatnames, 'CatDimension','CatValence','CatArousal', 'SelfDimension','SelfValence',...
        'SelfArousal','TaskLevel','SelfTask'];    
data_set = [featnames;featMatClass];
%save all features
CELL2CSV([subjectFeatDir, '/',subjectID(j,:),'_ecg12.csv'],data_set,',');   
clear data lenPhysio;
end
% clear all;
featExt=1;%end