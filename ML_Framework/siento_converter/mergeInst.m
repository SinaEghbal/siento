%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2012
%------------------------------------------------------------------
%------------------------------------------------------------------

function [x] = mergeInst(inDir, outDir, opSys)
%merge features from all files

if opSys==1;
    sep='/';
elseif opSys==2
    sep='\';
end

filesDir=dir(inDir);%dir info for files path
mkdir(outDir);

set=1;%enable for selecting header from only first file
dataset={};
for m=1:length(filesDir)
    [path,name,ext,ver] = fileparts(filesDir(m).name);
    
    if strcmp(ext,'.csv')%.mat files
        disp(name);
        loadFiles=[inDir sep name ext];
        C=textread(loadFiles,'%s','delimiter','\n','bufsize', 100000095);
        
        if set==1
            featnames=C{1};
            dataset=[dataset;featnames];
            set=0;
        end

        for y=2:length(C)
            rows=C{y};
            dataset=[dataset;rows];
        end
        clear rows featnames;
    end
end

CELL2CSV([outDir, sep ,'mergeInst.csv'],dataset,',');

x=1;
end

