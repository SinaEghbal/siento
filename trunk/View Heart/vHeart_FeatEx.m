%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering
%   University of Sydney, 2011
%------------------------------------------------------------------
%------------------------------------------------------------------

% %%Sync & Feature Extraction for View Heart project (AutoTutor 2009)
%channels: ECG
function [featExt]=vHeart_FeatEx(subjectID,filesPath,winSizeECG,sRate,dSample,featdir)
warning off;
filesDir=dir(filesPath);%dir info for files path
x=1;
for m=1:length(filesDir)
    [path,name,ext,ver] = fileparts(filesDir(m).name);
    for n=1:length(subjectID(:,1))
        if strncmp(subjectID(n,:),name,22)%choose only selected subjects
            if strcmp(ext,'.mat')%.mat files
                loadPhysio(x,:)=[filesPath '\' name ext];%.mat physio path
                physioSplit(x,:)= regexp(name,'_','split');
                physioATS=physioSplit(:,4);%physio abs time stamp
            elseif strcmp(ext, '.txt')%.txt files
                loadAnn(x,:)=[filesPath '\' name ext];%.txt annotation path
                annSplit(x,:)= regexp(name,'_','split');
                annATS=annSplit(:,4);%video abs time stamp
                x=x+1;
            end
        end
    end
end
mkdir(featdir);%create directory for features
% physioATS
% annATS
for j=1:(x-1)
    load(loadPhysio(j,:));%load physio file    
    data=downsample(data,dSample);%-->down sample all physio channels
    nsRate=(sRate/dSample);%new sample rate    
    fid = fopen(loadAnn(j,:));%load annotation
    C = textscan(fid,'%s%s%s%s%s%s','delimiter', ',');
    fclose(fid);
    
    subjectFeatDir=[featdir '\'];
    Absolute_Time_physio = datenum(physioATS(j), 'HH-MM-SS')*24*60*60; %in seconds
    Absolute_Time_ann= datenum(annATS(j), 'HH-MM-SS')*24*60*60; %in seconds
    annStart_sec=C{2};%col for start time seconds      
    lenPhysio=length(data);%length of physio data
    
    k = 1;
    featmat = [];
    catSelfVec=[];  
    while k <= length (annStart_sec)%instance
        start_times = Absolute_Time_ann + cell2mat(annStart_sec(k));
        Start_Trial = start_times;
        Start_Index = (Start_Trial - Absolute_Time_physio) * nsRate; %start time
        End_IndexECG = (Start_Index + winSizeECG * nsRate)-1;%end time for ecg window        
        if lenPhysio<End_IndexECG
            break;
        end
        Trial_ChunkECG = data(Start_Index:End_IndexECG,1); %ecg chunk
        ecgAffect= Trial_ChunkECG;%ecg data
        
        %feature extraction from ecg
        [ECGfeatvc ECGfeatnames] = vHeart_extractFeatECG (ecgAffect,nsRate);
        featmat = [featmat;ECGfeatvc];
        
        %extracting categories
        catSelf=C{4}(k);
        catSelfVec = [catSelfVec;catSelf];
        k = k+ 1;        
    end
    featmat = num2cell(featmat);
    featMatClass = [featmat,catSelfVec];
    featnames = [ECGfeatnames,'Affect'];    
    data_set = [featnames;featMatClass];
%     save all features
    CELL2CSV([subjectFeatDir, '/',subjectID(j,:),'_ecg12.csv'],data_set,',');   
end
clear all;
featExt=1;




