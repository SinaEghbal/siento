%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2012
%------------------------------------------------------------------
%------------------------------------------------------------------

function x = siento_wekaClassify(indir, outdir, classifier_string,cost,fName,opSys,codePath)
%Wrapper for Weka classifiers (use library version only)

if opSys==1;
    sep='/';
elseif opSys==2
    sep='\';
end

mkdir(outdir);

accMat=[];
prfMat=[];

accHeader=[{'title'},{'accuracy'},{'miPrecision'},{'miRecall'},{'miF1'},{'MaPrecision'},{'MaRecall'},{'MaF1'},{'kappameasure'},{'zeroR_Acc'}];
accMat=[accHeader];

rootDir= dir(indir);%root dir

for i=1:length(rootDir)
    if ~strncmp(rootDir(i).name,'.',1)
        featDir=dir([indir sep rootDir(i).name]);%feature dir
        for j=1:length(featDir)
            featFile=featDir(j).name; %feature file
            [path,name,ext,ver] = fileparts(featFile);
            if strcmp(ext,'.mat')
                
                %------------ individual classfication ----------
                featset=[];
                labels=[];
%                 disp([name '-(' rootDir(i).name ')']);
                fileName=[indir sep rootDir(i).name sep name ext];% .mat file path
                load(fileName);
                featset=Data_Set; %feature set values
                labels=Labels; %class labels
                LabelList=double(nominal(labels));%labels in numeric
                clear Data_Set Labels;
                
                classLabels=unique(LabelList);
                uLabNames=unique(labels);
                
                numInst=[];
                minInst=0;
                for p=1:length(classLabels)%find num of instances/class
                    numInst(p)=sum(classLabels(p)==LabelList);
                end
                minInst=min(numInst);
                maxInst=max(numInst);
                sumInst=sum(numInst);
                
                if cost==1 %create train.cost file for cost matrix 
                    fid=fopen([codePath, sep, 'train.cost'],'w');
                    fprintf(fid,'%s\n','% Rows	Columns');
                    fprintf(fid,'%d\t',length(classLabels));
                    fprintf(fid,'%d\t',length(classLabels));
                    fprintf(fid,'%s\n',''); %print to file
                    fprintf(fid,'%s\n','% Matrix elements');
                    
                    for m=1:length(classLabels)
                        for n=1:length(classLabels)
                            if n==m
                                fprintf(fid,'%0.1f\t',0.0);
                            else
                                fprintf(fid,'%0.1f\t',(numInst(n)));
                            end
                        end
                        fprintf(fid,'%s\n',''); %print to file                        
                    end
                    fid(close);
                end                
                
                DataClass=[featset, LabelList]; %dataset with nominal class (feed to classfier)
                run = Arsenal(classifier_string,DataClass);
                NLAB_OUT = run.Y_pred(:,3);
                [Performance_Measures, Performance_Measures1, ...
                    ConfusionMatrix, KResults,AllResults] = confm(NLAB_OUT,labels);
                
                %calculate ZeroR (baseline accuracy)
                zeroR='classify -sf 1 -- cross_validate -t 10 -- ZeroR';
                run_zeroR = Arsenal(zeroR,DataClass);
                NLAB_OUT_zeroR = run_zeroR.Y_pred(:,3);
                [Performance_Measures_zeroR, Performance_Measures1_zeroR, ...
                    ConfusionMatrix_zeroR, KResults_zeroR,AllResults_zeroR] = confm(NLAB_OUT_zeroR,labels);
                
                titleName=[name '-(' rootDir(i).name ')'];
                disp(titleName);
                
                %----> write classification label
                labelTitleMat=[];
                labelListMat=[];
                labelTitleMat=[{rootDir(i).name},{'class'}];
                labelListMat=[num2cell(NLAB_OUT),labels];
                labelTitleMat=[labelTitleMat;labelListMat];                
                labelDir=[outdir, sep, 'classifier_labels', sep, fName, sep, rootDir(i).name, sep, 'clOut'];                
                mkdir(labelDir); 
                CELL2CSV([labelDir, sep , titleName,'.csv'],labelTitleMat,',');%write accuracy
                %---->
                
                %{accuracy,miPrecision,miRecall,miF1,MaPrecision,MaRecall,MaF1,kappameasure,zeroR_acc}
                accMat=[accMat;[{titleName},AllResults(1:8),AllResults_zeroR(1)]];
                
                %{precision, recall, f-measure}
                prfMat=[prfMat;[{titleName},{'precision'},{'recall'},{'f-measure'}]];
                prfMat=[prfMat; [uLabNames, num2cell([AllResults{1,9}(:), AllResults{1,10}(:), AllResults{1,11}(:)])]];
                
                %------------------------------------------------
                
            end
        end
    end
end
%AllResults(1:8)
mkdir([outdir,sep,'acc']);
mkdir(([outdir,sep,'prf']));
CELL2CSV([outdir, sep, 'acc', sep , fName,'_acc.csv'],accMat,',');%write accuracy
CELL2CSV([outdir, sep, 'prf', sep , fName,'_prf.csv'],prfMat,',');%write prec-recall-f1
x=1;
end

