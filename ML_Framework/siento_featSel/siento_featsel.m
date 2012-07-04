%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2011
%------------------------------------------------------------------
%------------------------------------------------------------------

function [ x ] = siento_featsel(inDir, outDir, featRange, sel, rk, lp, cp, opSys,fName)
%feature selection based on Chi-Sq & CFS Tehcniques

if opSys==1;
    sep='/';
    cd (strcat(lp,'/DMML/fspackage'));%change to FS lib dir
elseif opSys==2
    sep='\';
    cd (strcat(lp,'\DMML\fspackage'));%change to FS lib dir
end

fRange=regexp(featRange,':','split');
fRange=str2num(char(fRange));

filesDir=dir(inDir);%dir info for files path

mkdir([outDir, sep, 'Report'])
fid=fopen([outDir sep, 'Report', sep, fName '_featReport.txt'],'a');

    for m=1:length(filesDir)    %run for all available data files
        [path,name,ext,ver] = fileparts(filesDir(m).name);
        
        if strcmp(ext,'.mat')   %.mat feature files
            disp(name);
            wekaFeat=[];
            wekaLabel=[];
            wekaCSV=[];
            
            fprintf(fid,'----------------------\n');
            fprintf(fid,'%s',name);%changed
            fprintf(fid,'\n');
            
            filename=[inDir, sep, name, ext];
            load(filename); %Data_Set(n*m); Labels(n); LabelNames(m)
            Label_List=double(nominal(Labels));        
            loadWeka(['lib' filesep 'weka']);%load weka packages
            if sel==1 %chi-sq
                fs=fsChiSquare(Data_Set(:,fRange(1):fRange(2)),Label_List);
                featValue=sort(fs.W,'descend');
                totalFeat=sum((featValue>0));
                if rk==0
                    featList=fs.fRank(1:totalFeat);
                    featValue=featValue(1:totalFeat);
                elseif rk>0
                    featList=fs.fRank(1:rk);
                    featValue=featValue(1:rk);
                end
            elseif sel==2 %CFS
                featvalue=0;
                fs=fsCFS(Data_Set(:,fRange(1):fRange(2)),Label_List);
                featList=(fs.fList)';
            end
            fsNames=[];
            featSet=[];
            index=0;
            for i=1:length(featList)
                index=(fRange(1)+featList(i))-1;
                fsNames=[fsNames; LabelNames(index)];
                featSet=[featSet,Data_Set(:,index)];
            end

            if sel==2
                featValue=zeros(1,length(fsNames),1);
            end

            featValue=featValue';
%             featSel=strcaRt(num2str(featValue), ' --: ');
            featSel='';
            featSel=strcat(featSel,fsNames);
            
            [p q]=size(featSel);
            for i=1:p
%                 fprintf(fid,'%s\n',featSel{i,:}); %save to .txt
                fprintf(fid,'%s\n',featSel{i,:}); %changed
            end
%             fprintf(fid,'\n');

            LabelNames=fsNames';
            Data_Set=featSet;
            
            %save to .mat
            matFile=[outDir, sep, 'MAT', sep, fName, sep, name, '.mat'];  
            mkdir([outDir, sep, 'MAT', sep, fName]);
            save(matFile,'LabelNames','Data_Set','Labels');
            
            %save to .csv (weka format)
            wekaFeat=[LabelNames;num2cell(Data_Set)];
            wekaLabel=['Class';Labels];
            wekaCSV=[wekaFeat,wekaLabel];
            wekaFile=[outDir, sep, 'Weka', sep, fName, sep, name, '.csv'];  
            mkdir([outDir, sep, 'Weka', sep, fName])
            CELL2CSV(wekaFile,wekaCSV,',');
                        
            clear LabelNames Labels1 Data_Set;
        end
    end
    if opSys==1;
        cd (cp);%switch back to work dir
    elseif opSys==2
        cd (cp);%switch back to work dir
    end
fid(close);
x=1;
end

