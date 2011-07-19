%% convertor, converts ascii files genretaed by bci2000's bci2000Export for
% the 8 emotions protocol
% set raw file path and filename in config file
% Example fileName_convertor='subject1S001R01';
lenFile=length(fileName_convertor); %length of raw filename
trimFile=sscanf(fileName_convertor,'%c',lenFile-1); %extract 1st n-1 char of filename

%% read emotion files (.ascii)
%the program read as followed:
% noem  - 1st raw file
% anger - 2nd raw file
% hate  - 3rd raw file
% grief - 4th raw file
% plat  - 5th raw file
% roma  - 6th raw file
% joy   - 7th raw file
% rev   - 8th raw file
for i=1:8
    clear data data1
    data=dlmread([physioPath '\' trimFile num2str(i) '.ascii'],' ', ' '); %path for rawfile
    data1(:,1)=data(:,5); %extract ecg data
    data1(:,1)=bio_cleaner_2ways (1024,50,data1(:,1)); %filter channel
    data1(:,2)=data(:,8); %extract emg data
    data1(:,2)=bio_cleaner_2ways (1024,50,data1(:,2)); %filter channel
    data1(:,3)=data(:,9); %inactive channel(used just to fulfill auBT format of SC)
    data1(:,3)=bio_cleaner_2ways (1024,50,data1(:,3)); %filter channel
    data=data1;
    isi=1;

    %tag and save data into .mat files
    switch(i)
        case 1
        save (fullfile(physioPath, 'noem.mat'), 'data', 'isi');
        case 2
        save (fullfile(physioPath, 'anger.mat'), 'data', 'isi');
        case 3
        save (fullfile(physioPath,'hate.mat'), 'data', 'isi');
        case 4
        save (fullfile(physioPath,'grief.mat'), 'data', 'isi');
        case 5
        save (fullfile(physioPath,'plat.mat'), 'data', 'isi');
        case 6
        save (fullfile(physioPath,'roma.mat'), 'data', 'isi');
        case 7
        save (fullfile(physioPath,'joy.mat'), 'data', 'isi');
        case 8
        save (fullfile(physioPath,'rev.mat'), 'data', 'isi');
    end
end