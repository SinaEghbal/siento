function store(rate,data)
config;

mergedfeatmat=zeros(1,126);
sammat=zeros(1,2);
load (fullfile(processingPath,'simu_data.mat'));
mergedfeatmat=[mergedfeatmat;data];

sammat=[sammat;rate];
save (fullfile(processingPath,'simu_data.mat'),'sammat', 'mergedfeatmat');
