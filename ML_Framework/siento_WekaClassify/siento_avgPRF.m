%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2012
%------------------------------------------------------------------
%------------------------------------------------------------------

function [doneR]=siento_avgPRF(opSys,indir,outdir,numSub, numClass, fName)
%Calculates the mean/std of precision, recall, F-measure

if opSys==1;
    sep='/';
elseif opSys==2
    sep='\'
end

indir=[indir sep 'prf'];
mkdir(outdir)
fid=fopen([outdir, sep, fName '_prf.txt'],'w');

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
                
                ch={};
                prec=[];
                rec=[];
                f1=[];
                modality1=[];
                modality2=[];
                for y=1:length(C)
                    rows=C{y};
                    rows=regexp(rows,',','split');
                    modality1=regexp(rows(1),'_','split');
                    modality2=regexp(modality1{1}(end),')','split');
                    ch{y}=modality2{1}(1);%modality list
                    prec(y)=str2double(cell2mat(rows(2)));%precision list
                    rec(y)=str2double(cell2mat(rows(3)));%recall list
                    f1(y)=str2double(cell2mat(rows(4)));%f1 list
                end
                C=[];
                fprintf(fid,'%s\n',name); %csv filename
                
                %modality header
                m=1;
                fprintf(fid,',');
                while m<=length(ch)
                    fprintf(fid,'%s,',cell2mat(ch{m}));
                    m=m+(numSub*(numClass+1));
                end
                fprintf(fid,'%s','(modality)');
                fprintf(fid,'\n');
                
                %precision-mean
                j=2;
                p=numClass-1;
                while j<=(numClass+1)
                    fprintf(fid,'%s,',cell2mat(ch{j}));
                    m=j;
                    precList=[];
                    while m<=length(prec)
                        precList=[precList,prec(m)];
                        if mod(m,(numSub*(numClass+1)))==((numSub*(numClass+1))-p)
                            fprintf(fid,'%s,',mean(precList));
                            precList=[];
                        elseif mod(m,(numSub*(numClass+1)))==0
                            fprintf(fid,'%s,',mean(precList));
                            precList=[];                            
                        end                        
                        m=m+(numClass+1);
                    end
                    fprintf(fid,'%s','(mean-prec)');
                    fprintf(fid,'\n');
                    j=j+1;
                    p=p-1;
                end
                
                %precision-std
                j=2;
                p=numClass-1;
                while j<=(numClass+1)
                    fprintf(fid,'%s,',cell2mat(ch{j}));
                    m=j;
                    precList=[];
                    while m<=length(prec)
                        precList=[precList,prec(m)];
                        if mod(m,(numSub*(numClass+1)))==((numSub*(numClass+1))-p)
                            fprintf(fid,'%s,',std(precList));
                            precList=[];
                        elseif mod(m,(numSub*(numClass+1)))==0
                            fprintf(fid,'%s,',std(precList));
                            precList=[];                            
                        end                        
                        m=m+(numClass+1);
                    end
                    fprintf(fid,'%s','(std-prec)');
                    fprintf(fid,'\n');
                    j=j+1;
                    p=p-1;
                end
                fprintf(fid,'\n');
                
                %recall-mean
                j=2;
                p=numClass-1;
                while j<=(numClass+1)
                    fprintf(fid,'%s,',cell2mat(ch{j}));
                    m=j;
                    recList=[];
                    while m<=length(rec)
                        recList=[recList,rec(m)];
                        if mod(m,(numSub*(numClass+1)))==((numSub*(numClass+1))-p)
                            fprintf(fid,'%s,',mean(recList));
                            recList=[];
                        elseif mod(m,(numSub*(numClass+1)))==0
                            fprintf(fid,'%s,',mean(recList));
                            recList=[];                            
                        end                        
                        m=m+(numClass+1);
                    end
                    fprintf(fid,'%s','(mean-rec)');
                    fprintf(fid,'\n');
                    j=j+1;
                    p=p-1;
                end
                
                %rec-std
                j=2;
                p=numClass-1;
                while j<=(numClass+1)
                    fprintf(fid,'%s,',cell2mat(ch{j}));
                    m=j;
                    recList=[];
                    while m<=length(rec)
                        recList=[recList,rec(m)];
                        if mod(m,(numSub*(numClass+1)))==((numSub*(numClass+1))-p)
                            fprintf(fid,'%s,',std(recList));
                            recList=[];
                        elseif mod(m,(numSub*(numClass+1)))==0
                            fprintf(fid,'%s,',std(recList));
                            recList=[];                            
                        end                        
                        m=m+(numClass+1);
                    end
                    fprintf(fid,'%s','(std-rec)');
                    fprintf(fid,'\n');
                    j=j+1;
                    p=p-1;
                end
                fprintf(fid,'\n');
                
                %fmeasure-mean
                j=2;
                p=numClass-1;
                while j<=(numClass+1)
                    fprintf(fid,'%s,',cell2mat(ch{j}));
                    m=j;
                    f1List=[];
                    while m<=length(f1)
                        f1List=[f1List,f1(m)];
                        if mod(m,(numSub*(numClass+1)))==((numSub*(numClass+1))-p)
                            fprintf(fid,'%s,',mean(f1List));
                            f1List=[];
                        elseif mod(m,(numSub*(numClass+1)))==0
                            fprintf(fid,'%s,',mean(f1List));
                            f1List=[];                            
                        end                        
                        m=m+(numClass+1);
                    end
                    fprintf(fid,'%s','(mean-f1)');
                    fprintf(fid,'\n');
                    j=j+1;
                    p=p-1;
                end
                
                %fmeasure-std
                j=2;
                p=numClass-1;
                while j<=(numClass+1)
                    fprintf(fid,'%s,',cell2mat(ch{j}));
                    m=j;
                    f1List=[];
                    while m<=length(f1)
                        f1List=[f1List,f1(m)];
                        if mod(m,(numSub*(numClass+1)))==((numSub*(numClass+1))-p)
                            fprintf(fid,'%s,',std(f1List));
                            f1List=[];
                        elseif mod(m,(numSub*(numClass+1)))==0
                            fprintf(fid,'%s,',std(f1List));
                            f1List=[];                            
                        end                        
                        m=m+(numClass+1);
                    end
                    fprintf(fid,'%s','(std-f1)');
                    fprintf(fid,'\n');
                    j=j+1;
                    p=p-1;
                end                
                fprintf(fid,'\n');  
                fprintf(fid,'\n');
            end
        end
    end
end
fid(close);
doneR=1;