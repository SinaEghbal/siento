function [mergedfeatmat,mergedemomat]=extract_chunks(user,window,offset)
%extract features
%window=10; %window=window length length in seconds
hz=1000;
mergedfeatmat=[];
mergedemomat=[];
for i=1:8
    load(fullfile('C:\Experiment',int2str(user),strcat('Physio\Image',int2str(i))));
    len=length(ch1);
    for k=1:(((len/hz)-window)/offset)+1
        seg1=ch1(((k-1)*offset*hz)+1:((k-1)*offset*hz)+(window*hz));
        seg2=ch2(((k-1)*offset*hz)+1:((k-1)*offset*hz)+(window*hz));
        seg3=ch3(((k-1)*offset*hz)+1:((k-1)*offset*hz)+(window*hz));
        seg4=ch4(((k-1)*offset*hz)+1:((k-1)*offset*hz)+(window*hz));
        ecgfeat=feval('aubt_extractFeatECG',seg1',hz);
        emgfeat=feval('aubt_extractFeatEMG',seg2',hz);
        scfeat=feval('aubt_extractFeatSC',seg3',hz);
        eegfeat=extractEEGFeatures2(seg4,hz);
        mergedfeatvec=[ecgfeat emgfeat scfeat eegfeat];
        %mergedfeatvec=[eegfeat];
        save(strcat('C:\Experiment\',int2str(user),'\Processing\emotion',int2str(i),strcat('Segment',int2str(k),'.mat')),'ecgfeat','emgfeat','scfeat','eegfeat','mergedfeatvec');
        mergedfeatmat=[mergedfeatmat;mergedfeatvec];
        mergedemomat=[mergedemomat;i];
    end
end
%normalize feature matrix:
% dim=size(mergedfeatmat);
% for m=1:dim(2)
%     ref=max(abs(mergedfeatmat(:,m)));
%     if ref==0
%         ref=0.01;
%     end
%     for n=1:dim(1)
%         mergedfeatmat(n,m)=mergedfeatmat(n,m)/ref;
%     end
% end
        
save(strcat('C:\Experiment\',int2str(user),'\Processing\features.mat'),'mergedemomat', 'mergedfeatmat');
end