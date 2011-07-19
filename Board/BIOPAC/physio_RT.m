%% Physio.m process physiological data
% preprocess data breaking in windows
% emometric(windowlength, numberofwindows, leadin,leadout,
% processingPath,physioPath)

%format raw .mat physio files to AuBT raw format


%emometric(15,30,0,0, processingPath,physioPath);

% for each signal extrat features using aubt
 %for filename = {'ecg-files.mat', 'emg-files.mat', 'sc-files.mat'}

disp(' ');
disp('Generating dataset for the classification task........');
%read AuBT format physio files
labels = ones(100,1);
mergedfeatmat = [];
for j =1:50
mpdevdemo(path_dll,path_lib,'MP150','MPUDP','610A-00007DE');
global rtCh1;
global rtCh2;
rtCh1inv=rtCh1';
rtCh2inv=rtCh2';
featExtractFunc1 = 'aubt_extractFeatECG (rtCh1inv, 400)';
featExtractFunc2 = 'aubt_extractFeatEMG (rtCh2inv, 400)';
      
[featVec1, featNames1] = eval (featExtractFunc1);
[featVec2, featNames2] = eval (featExtractFunc2);
 
mergedfeatvector = [featVec1 featVec2];
% mergedfeatvector =  featVec2;

mergedfeatmat = [mergedfeatmat; mergedfeatvector];
if (j> 5)
aubt_fisherPlot(mergedfeatmat,labels(1:j),findcolor(labels(1:j)),3);
end
pause(1);
end;
%merge feature names
%mergedfeatnames = strvcat(mergedfeatnames, featnames);









