%------------------------------------------------------------------
%------------------------------------------------------------------
%   Author: Md. Sazzad Hussain (sazzad.hussain@sydney.edu.au)
%   Learning and Affect Technologies Engineering (LATTE)
%   University of Sydney, 2011
%------------------------------------------------------------------
%------------------------------------------------------------------

% %Feature extraction program for View Heart project
clc;
clear all;
%% Toolbox Set
p = genpath('C:\Users\Hamed\Documents\MATLAB\Aubt\');
addpath(p);

%% configuration: sync, feature extraction
%General settings
%subject ID from experiment
subjectID=[
'nicta1_sub1_2010-11-09'
% 'nicta1_sub1_2010-11-10'
% 'nicta1_sub1_2010-11-11'
% 'nicta1_sub1_2010-11-12'
% 'nicta1_sub1_2010-11-15'
% 'nicta1_sub1_2010-11-16'
% 'nicta1_sub2_2010-11-08'
% 'nicta1_sub2_2010-11-09'
% 'nicta1_sub2_2010-11-10'
% 'nicta1_sub2_2010-11-11'
% 'nicta1_sub2_2010-11-12'
% 'nicta1_sub2_2010-11-15'
% 'nicta1_sub2_2010-11-16'
% 'nicta1_sub3_2010-11-08'
% 'nicta1_sub3_2010-11-09'
% 'nicta1_sub3_2010-11-10'
% 'nicta1_sub3_2010-11-15'
% 'nicta1_sub3_2010-11-16'
% 'nicta1_sub4_2010-11-16'
 ];
%% files I/O
% %location for input and output files
%dir for input files
indir='C:\Users\Hamed\Documents\MATLAB\Sazzad\rawNICTA\';
%dir for output files
outdir='C:\Users\Hamed\Documents\MATLAB\Sazzad\rawNICTA\featNICTA';
%% configure physio/channels
% % window size, sampling rate, downsample size
winSizeECG=14;  %ECG
sRate=1000; %original sample rate
dSample=5;  %downsample 

%% feature extraction from viewHeart
% featExt=vHeart_FeatEx(subjectID,indir,winSizeECG,sRate,dSample,outdir);
% if featExt==1 
%     disp('Feat Ext COMPLETE (View Heart - ECG)');
% end

%% feature extraction from IAPS-congnitiveLoad
featExt3=vHeart_FeatEx_EmoCog(subjectID,indir,winSizeECG,sRate,dSample,outdir);
if featExt3==1 
    disp('Feat Ext COMPLETE (EmoCog: View Heart - ECG)');
end
%note: check aubtProxy
%% Toolbox clear
rmpath(p);