%file should be .xls with col following order: subject, model, ch_all, ch1,
%ch2, ch3

[filename, pathname] = uigetfile('*.xls', 'Pick  a file .xls');
xlsSheet='FB';

[numeric,txt,raw]=xlsread(filename, xlsSheet);
subject=numeric(:,1);       %subject ID
models=txt(:,2);            %name of method

ch_all_kappa=numeric(:,3);  %kappa for combine channels
ch_ecg_kappa=numeric(:,4);  %kappa EMG
ch_sc_kappa=numeric(:,5);   %kappa SC
ch_emg_kappa=numeric(:,6);  %kappa EMG

ch_all_Acc=numeric(:,7);    %Accuracy for combine channels
ch_ecg_Acc=numeric(:,8);    %Accuracy EMG
ch_sc_Acc=numeric(:,9);     %Accuracy SC
ch_emg_Acc=numeric(:,10);   %Accuracy EMG
baseline=numeric(:,11);     %baseline of accuracy

kappa_pos=0;
kappa_neg=0;
n=1;
acc_above_bl=0;
h1=0;
h2=0;
h3=0;
h4=0;

for m=1:length(subject)
    if ch_all_kappa(m)>0
        if ch_all_Acc(m) > baseline(m)
            if ch_all_Acc(m)>ch_ecg_Acc(m) & ch_all_Acc(m)>=ch_sc_Acc(m) & ch_all_Acc(m)>=ch_emg_Acc(m)
                %evaluate multimodality
                ch_single_kappa=[ch_ecg_kappa(m) ch_sc_kappa(m) ch_emg_kappa(m)];
                [effect, deg]=evalMultimodality(ch_all_kappa(m), ch_single_kappa);
                bl_above=ch_all_Acc(m) - baseline(m);
                d={subject(m), char(models(m+1)), bl_above, ch_all_Acc(m), effect, deg};
                SUCCESS=XLSWRITE(['eval_' filename], d, xlsSheet, ['A' num2str(n) ':F' num2str(n)]);
                n=n+1;
            elseif ch_all_Acc(m)>=ch_ecg_Acc(m) & ch_all_Acc(m)>ch_sc_Acc(m) & ch_all_Acc(m)>=ch_emg_Acc(m)
               %evaluate multimodality
                ch_single_kappa=[ch_ecg_kappa(m) ch_sc_kappa(m) ch_emg_kappa(m)];
                [effect, deg]=evalMultimodality(ch_all_kappa(m), ch_single_kappa);
                bl_above=ch_all_Acc(m) - baseline(m);
                d={subject(m), char(models(m+1)), bl_above, ch_all_Acc(m), effect, deg};
                SUCCESS=XLSWRITE(['eval_' filename], d, xlsSheet, ['A' num2str(n) ':F' num2str(n)]);
                n=n+1;
            elseif ch_all_Acc(m)>=ch_ecg_Acc(m) & ch_all_Acc(m)>=ch_sc_Acc(m) & ch_all_Acc(m)>ch_emg_Acc(m)
               %evaluate multimodality
                ch_single_kappa=[ch_ecg_kappa(m) ch_sc_kappa(m) ch_emg_kappa(m)];
                [effect, deg]=evalMultimodality(ch_all_kappa(m), ch_single_kappa);
                bl_above=ch_all_Acc(m) - baseline(m);
                d={subject(m), char(models(m+1)), bl_above, ch_all_Acc(m), effect, deg};
                SUCCESS=XLSWRITE(['eval_' filename], d, xlsSheet, ['A' num2str(n) ':F' num2str(n)]);
                n=n+1;
            end 
            acc_above_bl=acc_above_bl+1;%index of total acc above baseline  
        end
         kappa_pos=kappa_pos+1;     %total number of pos kappa 
    else
        kappa_neg=kappa_neg+1;      %total number of neg kappa        
    end
end

acc_higher_3single=n/acc_above_bl
% clear all;
