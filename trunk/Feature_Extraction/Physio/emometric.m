function [] = emometric(windowlength, numberofwindows, leadin,leadout, processingPath, physioPath)
% [] = emometric(windowlength, numberofwindows, leadin, leadout)
% Tentative default values are 15,30,0,0
% windowlength is in seconds, typically 15-30.
% windowspacing is the number of datapoints between successive windows.
% leadin is the number of seconds of data to ignore at the beginning.
% leadout is the number of seconds to ignore at the end.
mkdir(fullfile(processingPath,'ecg'))
mkdir(fullfile(processingPath,'emg'))
mkdir(fullfile(processingPath,'sc'))
allfiles = {3,numberofwindows};

%%  This portion of code steps through each of the emotions in turn. First
%%  anger, then grief etc..
for emotion = 1:1:8

    switch (emotion)
        case 1
            emotionname = 'anger';
        case 2
            emotionname = 'grief';
        case 3
            emotionname = 'hate';
        case 4
            emotionname = 'joy';
        case 5
            emotionname = 'noem';
        case 6
            emotionname = 'plat';
        case 7
            emotionname = 'rev';
        case 8
            emotionname = 'roma';
        otherwise
            disp('Not a valid emotional input.')
            nosamples = 0;
    end

    disp(fullfile(physioPath,emotionname))
    load(fullfile(physioPath,emotionname));
    % the emotions shoould be saved as appropriately named .mat files from the BIOPAK software.
    % the .mat file should contain several variables including 'data' and
    % 'isi' which are needed for frequency and data values. Typically ECG
    % will be the first row in 'data', EMG the second and SC the third.
    hz = 1000/isi;


    %------------------------------------%
    %Test for ECG inversion%
    if abs(min(data(:,1))) > abs(max(data(:,1)))
        data(:,1) = -1 * data(:,1);
    end
    %------------------------------------%

    %------------------------------------%
    %Window initialisation%
    windowsize = hz * windowlength; %Windowsize is in seconds
    %------------------------------------%

    %------------------------------------%
    %Set window spacing
    windowspacing = floor(((length(data) - (leadin + leadout)*hz) - windowsize + 1)/numberofwindows); % calculates the appropriate spacing for n windows, end of data may not be used.
    %------------------------------------%

    start = leadin + 1; %Intialises the original window to start at first data point.
    numb = emotion;     %% Sets the emotion number, allowing stepping through the appropriate numbers when creating the signal files, eg anger will be given ecg1, then ecg9 etc...
    count = 0;



    for h = 1 : 1 : numberofwindows,
        stnum = num2str(numb);

        for sig = 1:1:3 % for each window, runs through once for each signal
            if sig == 1
                sigtype = 'ecg';
            elseif sig == 2
                sigtype = 'emg';
            elseif sig == 3
                sigtype = 'sc';
            end
            file = strcat(sigtype,stnum,'.mat'); %creates the file save name.
            ffile = fullfile(processingPath, sigtype,file);
          %  disp ffile
            allfiles{sig,numb} = ffile; % 3*n array each row represents one signal type, eg emg.
            signal = data(start:1:(start+(windowsize-1)),sig); % applies the window over the original data and copies to 'signal'
            save(ffile, 'signal', 'hz') % Saves the selection and its sample rate.
        end
        % Counters
        start = start + windowspacing; % Moving window start counter
        numb = numb + 8; % Signal number counter (emotion specific)
        count = count + 1; % Counter for labels.mat, probably unnecessary, likely related to 'numberofwindows'
    end

end

%-------------------------------------%
%Creates the 'labels.mat' variable file
%mklabels(count); %% This function creates the file labels.mat
%% This function creates the .mat file labels, which is used to denote
%% which data stub belongs to which emotion group.

labelnames = {'anger';'grief';'hate';'joy';'noemotion';'platonic';'reverence';'romantic'};
labels = [];
for n = 1:1:(count)
    labels = [labels;((1:8)')];
end
save(fullfile(processingPath, 'labels'),'labels','labelnames')
%-------------------------------------%

%-------------------------------------%
%Collects all the signal file numbers and saves 'signal-files.mat'
%mkfiles(allfiles,hz);%% This function makes the list files, ecg-files.mat, etc..
for n = 1:1:3
    if n == 1
        name = 'ecg';
        files = {allfiles{1,:}};
        save(fullfile(processingPath,'ecg-files'),'files','hz','name')
    elseif n == 2
        name = 'emg';
        files = {allfiles{2,:}};
        save(fullfile(processingPath,'emg-files'),'files','hz','name')
    elseif n == 3
        name = 'sc';
        files = {allfiles{3,:}};
        save(fullfile(processingPath, 'sc-files'),'files','hz','name')
    end
end
%--------------------------------------%