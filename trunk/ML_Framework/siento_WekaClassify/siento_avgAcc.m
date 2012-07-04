%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2012
%------------------------------------------------------------------
%------------------------------------------------------------------

function [doneR]=siento_avgAcc(opSys,indir,outdir,numSub,fName)
%Calculates the mean/std of accuracy and kappa

if opSys==1;
    sep='/';
elseif opSys==2
    sep='\'
end

indir=[indir sep 'acc'];
mkdir(outdir)
fid=fopen([outdir, sep, fName '.txt'],'w');

rootDir= dir(indir);%root dir
for i=1:length(rootDir)
    if ~strncmp(rootDir(i).name,'.',1)
        featDir=dir([indir sep rootDir(i).name]);
        for j=1:length(featDir)
            featFile=featDir(j).name;
            [path,name,ext,ver] = fileparts(featFile);
            if strcmp(ext,'.csv')
                loadFiles=[indir sep rootDir(i).name];% .csv file path
                C=textread(loadFiles,'%s','delimiter','\n');
                
                mod={};
                acc=[];
                kap=[];
                modality1=[];
                modality2=[];
                for y=2:length(C)
                    rows=C{y};
                    rows=regexp(rows,',','split');
                    modality1=regexp(rows(1),'_','split');
                    modality2=regexp(modality1{1}(end),')','split');
                    mod{y-1}=modality2{1}(1);%modality list
                    acc(y-1)=str2double(cell2mat(rows(2)));%accuracy list
                    kap(y-1)=str2double(cell2mat(rows(9)));%kappa list               
                end
                C=[];
                fprintf(fid,'%s\n',name); %csv filename
                
                %modality header
                m=1;
                fprintf(fid,',');
                while m<=length(mod)
                    fprintf(fid,'%s,',cell2mat(mod{m}));
                    m=m+numSub;
                end
                fprintf(fid,'%s','(modality)');
                fprintf(fid,'\n');
                
                %accuracy-mean
                m=1;
                n=numSub;
                fprintf(fid,',');
                while m<=length(acc)
                    fprintf(fid,'%s,',num2str(mean(acc(m:n))));
                    m=m+numSub;
                    n=n+numSub;
                end
                fprintf(fid,'%s','(mean-acc)');
                fprintf(fid,'\n');
                
                %accuracy-std
                m=1;
                n=numSub;
                fprintf(fid,',');
                while m<=length(acc)
                    fprintf(fid,'%s,',num2str(std(acc(m:n))));
                    m=m+numSub;
                    n=n+numSub;
                end
                fprintf(fid,'%s','(std-acc)');
                fprintf(fid,'\n');

                %kappa-mean
                m=1;
                n=numSub;
                fprintf(fid,',');
                while m<=length(kap)
                    fprintf(fid,'%s,',num2str(mean(kap(m:n))));
                    m=m+numSub;
                    n=n+numSub;
                end
                fprintf(fid,'%s','(mean-kappa)');
                fprintf(fid,'\n');

                %kappa-std 
                m=1;
                n=numSub;
                fprintf(fid,',');
                while m<=length(kap)
                    fprintf(fid,'%s,',num2str(std(kap(m:n))));
                    m=m+numSub;
                    n=n+numSub;
                end
                fprintf(fid,'%s','(std-kappa)');
                fprintf(fid,'\n');
                fprintf(fid,'\n');                
            end
        end
    end
end
fid(close);
doneR=1;