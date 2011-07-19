%sets up files before running simulink
config;
experiment_protocol;

%initiate Path for storage of raw signal
mkdir(physioPath);
mkdir(processingPath);
mkdir(SAMPath);

%UNCOMMENT TO USE FISHER PLOT WITHOUT EXISTING FEATURE DATABASE
%initiates random features as input into fisher projection plot
%(fisher projection doesn't work with only few initial data points)
% mergedfeatmat=randn(10,126);
% sammat=[2 4;5 2;3 1;4 2;4 3;2 4;5 1;1 1;2 1;4 2];
% save(fullfile(processingPath,'simu_data.mat'),'sammat','mergedfeatmat');

%initiates empty database
mergedfeatmat=[];
sammat=[];
save(fullfile(processingPath,'simu_data.mat'),'sammat','mergedfeatmat');

%initialises photo index at one (ie first image)
k=1;
j=0;
save(fullfile(processingPath,'simu_data_index.mat'),'k','j');

