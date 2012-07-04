%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2011
%------------------------------------------------------------------
%------------------------------------------------------------------

function [ x ] = mergeFeat(inDir, outDir, subID, nClass,opSys)
%Combines all features under inDir to one .csv file

if opSys==1;
    sep='/';
elseif opSys==2
    sep='\';
end

mkdir(outDir);
pathCh=inDir;%root dir
filesDir1=dir(pathCh);%dir info for files path
[sNum sChar]=size(subID);
xx=0;
for n=1:sNum
    featVec=[];%store features
    labelVec=[];%store labels
    for i=3:length(filesDir1)%chFolders
        pathWin=[pathCh, sep filesDir1(i).name];%dir for winSize  
        filesDir2=dir(pathWin);
        for j=3:length(filesDir2)%winFolders
            pathFiles=[pathWin, sep filesDir2(j).name];% dir for .csv files 
            filesDir3=dir(pathFiles);
            for k=3:length(filesDir3)%csv files
                [path,name,ext,ver] = fileparts(filesDir3(k).name);
                if strncmp(subID(n,:),name,sChar)%choose only selected subjects                    
                    loadFiles=[pathFiles sep name ext];%files full path
                    C=textread(loadFiles,'%s','delimiter','\n');%read files
               
                    dataSet={};
                    featName={};
                    featSet={};
                    labelName={};
                    labelSet={};                   
                    for x=1:length(C)
                        dataSet(x,:)=regexp(C{x},',','split');%split colums
                    end                    
                    [lenR lenC]=size(dataSet);
                    xx=xx+(lenC-nClass); %total featset
                    featName=strcat(dataSet(1,1:(lenC-nClass)),['_' filesDir2(j).name]);%featre names
                    featSet=dataSet(2:end,1:(lenC-nClass));%feature values
                    labelName=dataSet(1,((lenC-nClass)+1):lenC);%labels names
                    labelSet=dataSet(2:end,((lenC-nClass)+1):lenC);%labels
                    
                    featVec=[featVec,[featName;featSet]];
                    LabelVec=[labelName;labelSet];
                    clear labelSet labelName featSet featName;
                end
            end%csv files
        end%win sizes
    end%channels      
    disp(subID(n,:));
    %write to .csv
    CELL2CSV([outDir, sep ,subID(n,:),'_merge.csv'],[featVec,LabelVec],',');
end%subjects

x=1;
end

