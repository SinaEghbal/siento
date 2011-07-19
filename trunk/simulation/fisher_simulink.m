function fisher_simulink(data,rate)
config;
load (fullfile(processingPath,'simu_data.mat'));
mergedfeatmat=[mergedfeatmat;data];
if nargin<2
    labels=sammat(:,1);%categorised by arousal scores
    labels=[labels;1]; %if no sam input for current signal, set to 1
else
    sammat=[sammat;rate];
    labels=sammat(:,1);
end
colors=findcolor(sammat(:,1));

%eliminate columns of zeros to enable fisherplot
[m,n]=size(mergedfeatmat);
epsilon=0.005;
transfer=zeros(n);
cols_eliminated=0;
bool=abs(mergedfeatmat)<epsilon;
for i=1:n
    if sum(bool(:,i))==m
        cols_eliminated=cols_eliminated+1;
    else
        transfer(i,i-cols_eliminated)=1;
    end
end
mergedfeatmat=mergedfeatmat*transfer;
fisherdata=mergedfeatmat(:,1:n-cols_eliminated);

        
aubt_fisherPlot(fisherdata,labels,colors);

