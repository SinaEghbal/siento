%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2011
%------------------------------------------------------------------
%------------------------------------------------------------------

function [x]=csv2mat(inDir, outDir,numClasses,setClass,opSys)
%converts comma-seperated csv file to .mat format (for classfier)

if opSys==1;
    sep='/';
elseif opSys==2
    sep='\';
end

filesDir=dir(inDir);%dir info for files path
mkdir(outDir);

for m=1:length(filesDir)
    [path,name,ext,ver] = fileparts(filesDir(m).name);
    if strcmp(ext,'.csv')%.mat files
        disp(name);
        loadFiles=[inDir sep name ext];
        C=textread(loadFiles,'%s','delimiter','\n','bufsize', 100000095);
        featnames=C{1};
        LabelNames=regexp(featnames,',','split');
        LabelNames=LabelNames(1:(length(LabelNames)-numClasses));
        
        for y=2:length(C)
            rows=C{y};
            rows=regexp(rows,',','split');
            lenData=(length(rows)-numClasses);            
            Data_Set(y-1,1:lenData)=str2num(char(rows(1:lenData)));                         
            Labels(y-1,:)=rows(lenData+setClass);
        end
%         Data_Set=str2num(char(Data_Set));
        matFile=[outDir, sep, name,'.mat'];
        save(matFile,'LabelNames','Labels','Data_Set');
        clear LabelNames Labels1 Data_Set1 Data_Set Labels;
    end
end

x=1;

