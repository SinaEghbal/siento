%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2012
%------------------------------------------------------------------
%------------------------------------------------------------------

% %Siento Top Module (Main)
clc;
clear all;
%% Toolbox Set
% % Define the paths for library and codes

% rehash toolbox; 
% clear classes;

%-----Mac---------
% codePath='/My_Drive/Drive1/USYD_Research/sazzadPhD_SVN/myFramework';
% libPath='/My_Drive/Drive1/USYD_Research/sazzadPhD_SVN/myLib';

%-----Winhows-----
codePath='C:\Siento\ML_Framework';
libPath='C:\Siento\lib\ML_Framework_lib';

myCodes = genpath(codePath);
myLib = genpath(libPath);
addpath(myCodes);%framework path
addpath(myLib);%library path

%define OS
opSys=2; % 1-Mac; 2-Windows
%% files I/O
% %location for input and output files
%dir for input/output files

if opSys==1
    %-----Mac---------
%     indir='/My_Drive/Drive1/USYD_Research/Research Data/IAPS Journal/EmoCog_Norm/1_UserDep/2_FeatSelection/cfs/Arousal/MAT';
%     outdir='/My_Drive/Drive1/USYD_Research/Research Data/IAPS Journal/EmoCog_Norm/1_UserDep/4_CVPara_knn';    
elseif opSys==2
    %-----Windows-----
    indir='D:\Dropbox\Research\Research Data\Vote_Classifier\1_UserDep\2_Classification';
    outdir='D:\Dropbox\Research\Research Data\Vote_Classifier\1_UserDep\2_Classification\results';
end
%% subject IDs
%subject ID from experiment

subjectID=[
% 'siento_iaps_sub1_2010-09-06'        
% 'siento_iaps_sub1_2010-09-07'     
% 'siento_iaps_sub1_2010-09-08'      
% 'siento_iaps_sub1_2010-09-10'      
% 'siento_iaps_sub1_2010-09-13'       
% 'siento_iaps_sub1_2010-09-14'         
% 'siento_iaps_sub1_2010-09-15'         
% 'siento_iaps_sub2_2010-09-15'          
% 'siento_iaps_sub1_2010-09-16'        
% 'siento_iaps_sub2_2010-09-16'         
% 'siento_iaps_sub1_2010-09-17'         
% 'siento_iaps_sub1_2010-09-20'         
% 'siento_iaps_sub2_2010-09-20'         
% 'siento_iaps_sub1_2010-09-21'         
% 'siento_iaps_sub1_2010-09-23'         
% 'siento_iaps_sub2_2010-09-23'         
% 'siento_iaps_sub1_2010-09-24'         
% 'siento_iaps_sub1_2010-09-29'         
% 'siento_iaps_sub1_2010-09-30'         
% 'siento_iaps_sub2_2010-09-30'         
% 'siento_iaps_sub1_2010-10-13'         
];

%% Feature Merge
% %Combine features from different files, channels, window sizes (subjectID)

% nClasses=1;%total number of class col in file
% 
% merge1=mergeFeat(indir, outdir, subjectID, nClasses,opSys);
% 
% if merge1==1 
%     disp('Feat Merge COMPLETE');
% end
%% Instance Merge
% %Merge all features from all instances (dump CSV)

% merge2= mergeInst(indir, outdir, opSys)
% 
%  if merge2==1
%      disp('Instance Merge COMPLETE');
%  end
%% Selective Class
% %Select instances based on selected class (dump CSV files)

% colNum=2; %col used from RIGHT
% className='MediumValence';
% filename='arousal_MV';
% selClass= selectiveClass(indir, outdir, colNum, className, filename, opSys)
% 
%  if selClass==1
%      disp('Selective Class COMPLETE');
%  end
%% Normalize Features
% %Normalize all features (dump CSV)

% nClasses=8;%total number of class col in file
% 
% norm1=normFeat(indir, outdir, nClasses, opSys);
% 
% if norm1==1 
%     disp('Feat Normalize COMPLETE');
% end
%% CSV to Mat convertor
% %dump CSV weka format files in indir and find converted MAT files in outdir

% numClasses=1;%total number of class col in file
% setClass=1;%col number (from left) for selected class 
% conv=csv2mat(indir, outdir, numClasses, setClass,opSys)
% 
% if conv==1 
%     disp('CSV to MAT conversion complete');
% end
%% Feature Selection
% %Chi-Square & Correlation Feature Selection (CFS) Tehcniques
% %dump MAT format files in indir for siento_featsel()

% featWinRange=[ %feat range_modality
% '1:56_color-full'
% ];
% 
% featRange=regexp(featWinRange,'_','split');%split winRange & modalityName
% 
% fileName=char(strcat('cfs_cognitive_', featRange(2)));
% 
% selFS=2; %1-Chi-Sq; 2-CFS)
% rank=0;
% sel = siento_featsel(indir,outdir,char(featRange(1)),selFS,rank,libPath,codePath,opSys,fileName);
% 
% if sel==1
%     disp('Feature Selection complete');
% end
%% Classfication
% % %indir: feat subfolders, subfolder: feat files 
% % dump MAT format files in indir/subfolder for wekaClassify()
% % based on MatlabArsenal library

% fileHeader='cfs_arousal';
% 
% % set to same random seeds
% s = RandStream('mt19937ar','seed',0);
% RandStream.setDefaultStream(s);
% 
% dataShuffle='classify -sf 1'; %shuffle data (0-no; 1-yes)
% trainTest=' -- cross_validate -t 10'; %training-testing (crossval -t #fold)
% baseClassfier=' -- WekaClassify -MultiClassWrapper 0'; %classfer type/wrapper
% cost=0;%[1-enable costsensitive classifier]
% 
% % %------------------------------------SVM---------------------------------
% %name of resutls file
% fileName=[fileHeader '_svm'];
% %SVM
% wekaClassfier=' -- functions.SMO -C 1.0 -E 1.0 -G 0.01 -A 1000003 -T 0.0010 -P 1.0E-12 -N 0 -V -1 -W 1';
% %construct MatlabArsenal classfier string
% classifier_string=[dataShuffle trainTest baseClassfier wekaClassfier];
% %weka classification
% cl=siento_wekaClassify(indir, outdir, classifier_string,cost,fileName,opSys,codePath);
% 
% % %-----------------------------------KNN1---------------------------------
% %name of resutls file
% fileName=[fileHeader '_knn1'];
% %KNN1
% wekaClassfier=' -- lazy.IB1';
% %construct MatlabArsenal classfier string
% classifier_string=[dataShuffle trainTest baseClassfier wekaClassfier];
% %weka classification
% cl=siento_wekaClassify(indir, outdir, classifier_string,cost,fileName,opSys,codePath);
% 
% % % %------------------------------------KNN3--------------------------------
% % %name of resutls file
% % fileName=[fileHeader '_knn3'];
% % %KNN3
% % wekaClassfier=' -- lazy.IBk -K 3 -W 0';
% % %construct MatlabArsenal classfier string
% % classifier_string=[dataShuffle trainTest baseClassfier wekaClassfier];
% % %weka classification
% % cl=siento_wekaClassify(indir, outdir, classifier_string,cost,fileName,opSys,codePath);
% % 
% % %------------------------------------dTree-------------------------------
% %name of resutls file
% fileName=[fileHeader '_dtree'];
% %Decision Tree
% wekaClassfier=' -- trees.J48 -C 0.25 -M 2';
% %construct MatlabArsenal classfier string
% classifier_string=[dataShuffle trainTest baseClassfier wekaClassfier];
% %weka classification
% cl=siento_wekaClassify(indir, outdir, classifier_string,cost,fileName,opSys,codePath);
% 
% % %------------------------------------VOTE--------------------------------
% %name of resutls file
% fileName=[fileHeader '_vote'];
% %Vote Classifier (AVG): SVM1, KNN1,KNN3, J48
% % wekaClassfier=' -- meta.Vote -B "weka.classifiers.functions.SMO -C 1.0 -E 1.0 -G 0.01 -A 1000003 -T 0.0010 -P 1.0E-12 -N 0 -V -1 -W 1" -B "weka.classifiers.lazy.IB1 " -B "weka.classifiers.lazy.IBk -K 3 -W 0" -B "weka.classifiers.trees.J48 -C 0.25 -M 2"'; %classfier string from weka
% wekaClassfier=' -- meta.Vote -B "weka.classifiers.functions.SMO -C 1.0 -E 1.0 -G 0.01 -A 1000003 -T 0.0010 -P 1.0E-12 -N 0 -V -1 -W 1" -B "weka.classifiers.lazy.IB1 " -B "weka.classifiers.trees.J48 -C 0.25 -M 2"'; %classfier string from weka
% %construct MatlabArsenal classfier string
% classifier_string=[dataShuffle trainTest baseClassfier wekaClassfier];
% %weka classification
% cl=siento_wekaClassify(indir, outdir, classifier_string,cost,fileName,opSys,codePath);
% 
% % % %-----------------------------------COSTS------------------------------
% % %name of resutls file
% % fileName=[fileHeader '_cost'];
% % % %Cost Sensitive Classifier, Vote Classifier (AVG): SVM1, KNN1,KNN3, J48
% % wekaClassfier=' -- meta.CostSensitiveClassifier -S 1 -W weka.classifiers.meta.Vote -- -B "weka.classifiers.functions.SMO -C 1.0 -E 1.0 -G 0.01 -A 1000003 -T 0.0010 -P 1.0E-12 -N 0 -V -1 -W 1" -B "weka.classifiers.lazy.IB1 " -B "weka.classifiers.lazy.IBk -K 3 -W 0" -B "weka.classifiers.trees.J48 -C 0.25 -M 2"'; %classfier string from weka
% % cost=1;
% % %construct MatlabArsenal classfier string
% % classifier_string=[dataShuffle trainTest baseClassfier wekaClassfier];
% % %weka classification
% % cl=siento_wekaClassify(indir, outdir, classifier_string,cost,fileName,opSys,codePath);
% 
% % % %------------------------------------Test--------------------------------
% % %name of resutls file
% % fileName=[fileHeader '_m5'];
% % wekaClassfier=' -- rules.M5Rules -M 4.0'; %classfier string from weka
% % % wekaClassfier=' -- meta.RandomCommittee -S 1 -I 10 -W weka.classifiers.trees.RandomTree -- -K 0 -M 1.0 -S 1'; %classfier string from weka
% % %construct MatlabArsenal classfier string
% % classifier_string=[dataShuffle trainTest baseClassfier wekaClassfier];
% % %weka classification
% % cl=siento_wekaClassify(indir, outdir, classifier_string,cost,fileName,opSys,codePath);
% 
% % % % %------------------------------------(CVPara)--------------------------------
% % %name of resutls file
% % fileName=[fileHeader '_CVPara_knn'];
% % 
% % %CVParameterSelection
% % wekaClassfier=' -- meta.CVParameterSelection -P "E 1.0 3.0 1.0" -P "C 0.01 100.0 2.0" -X 10 -S 1 -W weka.classifiers.functions.SMO -- -C 1.0 -E 1.0 -G 0.01 -A 1000003 -T 0.0010 -P 1.0E-12 -N 0 -V -1 -W 1';
% % % wekaClassfier=' -- meta.CVParameterSelection -X 10 -S 1 -W weka.classifiers.meta.Vote -- -B "weka.classifiers.functions.SMO -C 1.0 -E 1.0 -G 0.01 -A 1000003 -T 0.0010 -P 1.0E-12 -N 0 -V -1 -W 1" -B "weka.classifiers.lazy.IBk -K 1 -W 0" -B "weka.classifiers.trees.J48 -C 0.25 -M 2'; %classfier string from weka
% % %construct MatlabArsenal classfier string
% % classifier_string=[dataShuffle trainTest baseClassfier wekaClassfier];
% % %weka classification
% % cl=siento_wekaClassify(indir, outdir,classifier_string,cost,fileName,opSys,codePath);
% 
% if cl==1
%     disp('Classification complete');
% end
%% Decision Fusion Classificaion
% % %indir: feat/decision subfolders, subfolder: classfier decision files 
% % dump MAT format files in indir/subfolder
% % based on weighed majority voting

% fileName='decFusion_mVote';
% nFoldCV=10; %number of cross validations
% clD=siento_mvoteClassify(indir, outdir, fileName, nFoldCV, opSys);
% if clD==1
%     disp('Decision Fusion Classification complete');
% end
%% Classification Resutls
%dump all accuracy files to indir/acc & indir/prf.
%calcualtes mean/std of classification accuracy given subjects

% numSub=19;
% numClass=3;
% fName='results';
% res1=siento_avgAcc(opSys,indir,outdir,numSub,fName);
% res2=siento_avgPRF(opSys,indir,outdir,numSub,numClass,fName);
% 
% if (res1==1 & res2==1)
%     disp('Result Generated');
% end
%% Toolbox clear
rmpath(myCodes);
rmpath(myLib);