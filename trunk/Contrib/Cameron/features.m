%loads physio data from file, extracts and saves features
hz=1000;
allfeatmat=[];
allsammat=[];
for i=1:11
    %for each user
    config;
    mergedfeatmat=[];
    mergedsammat=[];
    for j=1:75
        %for each image
        load(fullfile(physioPath,strcat('Image',int2str(j))));
        load(fullfile(SAMPath,strcat('Image',int2str(j))));
        %standardise length of feature recording
        ch1=ch1(1:6000);
        ch2=ch2(1:6000);
        ch3=ch3(1:6000);
        ch4=ch4(1:6000);
        ecgfeat=feval('aubt_extractFeatECG',ch1',hz);
        emgfeat=feval('aubt_extractFeatEMG',ch2',hz);
        scfeat=feval('aubt_extractFeatSC',ch3',hz);
        eegfeat=extractEEGFeatures2(ch4,hz);
        
        mergedfeatvec=[ecgfeat emgfeat scfeat eegfeat];
        save(fullfile(processingPath,strcat('Image',int2str(j))),'ecgfeat','emgfeat','scfeat','eegfeat','mergedfeatvec');
        mergedfeatmat=[mergedfeatmat;mergedfeatvec];
        mergedsammat=[mergedsammat;sammat];
    end
    save(fullfile(processingPath,'features.mat'),'mergedsammat', 'mergedfeatmat');
    allfeatmat=[allfeatmat;mergedfeatmat];
    allsammat=[allsammat;mergedsammat];
end
i=0;
config;
save(fullfile(processingPath,'features.mat'),'allfeatmat', 'allsammat');