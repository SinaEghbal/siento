%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2012
%------------------------------------------------------------------
%------------------------------------------------------------------

function [x] = selectiveClass(inDir, outDir, colNum, className, filename, opSys)
%filter selective instances from .csv file

if opSys==1;
    sep='/';
elseif opSys==2
    sep='\';
end

filesDir=dir(inDir);%dir info for files path
% mkdir(outDir);


for m=1:length(filesDir)
    [path,name,ext,ver] = fileparts(filesDir(m).name);
    dataset_sel={};
    if strcmp(ext,'.csv')%.mat files
        disp(name);
        loadFiles=[inDir sep name ext];
        C=textread(loadFiles,'%s','delimiter','\n','bufsize', 100000095);
        dataset=regexp(C,',','split');
        selCol=(length(dataset{1})-colNum) + 1;
        
        featnames=dataset{1};
        dataset_sel=[dataset_sel;featnames];%header
        
        for x=2:length(dataset)
            if strcmp(className, dataset{x}(selCol))                
                dataset_sel=[dataset_sel;dataset{x}];%selected instances
            end
        end
        
    CELL2CSV([outDir, sep ,filename '_' name '.csv'],dataset_sel,',');
    clear dataset_sel dataset;
    end
    
    x=1;
end

