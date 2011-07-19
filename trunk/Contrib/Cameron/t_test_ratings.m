%loads SAM self ratings, and corresponding scores provided by IAPS;
%runs t-test and saves p-values
n=10;  %number of subjects
load('C:\Experiment\General_Data\rate_stats');
rates(:,1)=rate(:,4);
rates(:,2)=rate(:,2);
%rates=rate;
for k=1:75
    %for each photo
    for i=1:n
        %by each subject
        config;
        load(fullfile(SAMPath,strcat('Image',int2str(k))));
        arousal(i)=sammat(1);
        valence(i)=sammat(2);
        %test(k,i)=sammat(2);
    end
    sample_diff_arousal(k)=mean(arousal)-rates(k,1);
    sample_diff_valence(k)=mean(valence)-rates(k,2);
    sample_arousal(k,:)=arousal;
    sample_std(k)=std(arousal);
    sample_std_v(k)=std(valence);
    sample_valence(k,:)=valence;
    %determine t-test statistics
    %t_ar=(mean(arousal)-rate(k,4))/(std(arousal)/sqrt(n));
    %t_va=(mean(valence)-rate(k,2))/(std(valence)/sqrt(n));
    [ha,pa]=ttest(arousal,rates(k,1));
    [hv,pv]=ttest(valence,rates(k,2));
    success_ar(k,1:2)=[ha,pa];
    success_va(k,1:2)=[hv,pv];
end