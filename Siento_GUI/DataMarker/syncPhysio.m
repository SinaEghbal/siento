function varargout = syncPhysio(varargin)
% SYNCPHYSIO M-file for syncPhysio.fig
%      SYNCPHYSIO, by itself, creates a new SYNCPHYSIO or raises the existing
%      singleton*.
%
%      H = SYNCPHYSIO returns the handle to a new SYNCPHYSIO or the handle to
%      the existing singleton*.
%
%      SYNCPHYSIO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNCPHYSIO.M with the given input arguments.
%
%      SYNCPHYSIO('Property','Value',...) creates a new SYNCPHYSIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before syncPhysio_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to syncPhysio_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help syncPhysio

% Last Modified by GUIDE v2.5 08-Jan-2010 12:06:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @syncPhysio_OpeningFcn, ...
                   'gui_OutputFcn',  @syncPhysio_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before syncPhysio is made visible.
function syncPhysio_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to syncPhysio (see VARARGIN)

% Choose default command line output for syncPhysio
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes syncPhysio wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = syncPhysio_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_physio_Callback(hObject, eventdata, handles)
% hObject    handle to edit_physio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_physio as text
%        str2double(get(hObject,'String')) returns contents of edit_physio as a double


% --- Executes during object creation, after setting all properties.
function edit_physio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_physio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_physio.
function pushbutton_physio_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_physio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile('*.mat*','Please select a file')

if ~filename
    return
end;

file_p=[pathname filename];
[path,name,ext,ver] = fileparts(file_p);
loadphysio=which(fullfile([name ext]));

set(handles.edit_physio,'String',loadphysio);
%load physio .mat file
load (loadphysio);

%extract the channel data & store in handles
handles.ECG=data(:,1);%channel for ECG
handles.GSR=data(:,2);%channel for GSR
handles.EMG=data(:,3);%channel for EMG
guidata(hObject, handles);

function edit_ann_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ann (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ann as text
%        str2double(get(hObject,'String')) returns contents of edit_ann as a double


% --- Executes during object creation, after setting all properties.
function edit_ann_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ann (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ann.
function pushbutton_ann_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ann (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile('*.txt*','Please select a file')

if ~filename
    return
end;

file_p=[pathname filename];
set(handles.edit_ann,'String',file_p);
[path,name,ext,ver] = fileparts(file_p);
annFile=which(fullfile([name ext]));
handles.annData = importdata(annFile);
guidata(hObject, handles);

function hh_p_Callback(hObject, eventdata, handles)
% hObject    handle to hh_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hh_p as text
%        str2double(get(hObject,'String')) returns contents of hh_p as a double


% --- Executes during object creation, after setting all properties.
function hh_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hh_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mm_p_Callback(hObject, eventdata, handles)
% hObject    handle to mm_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mm_p as text
%        str2double(get(hObject,'String')) returns contents of mm_p as a double


% --- Executes during object creation, after setting all properties.
function mm_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mm_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ss_p_Callback(hObject, eventdata, handles)
% hObject    handle to ss_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ss_p as text
%        str2double(get(hObject,'String')) returns contents of ss_p as a double


% --- Executes during object creation, after setting all properties.
function ss_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ss_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hh_a_Callback(hObject, eventdata, handles)
% hObject    handle to hh_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hh_a as text
%        str2double(get(hObject,'String')) returns contents of hh_a as a double


% --- Executes during object creation, after setting all properties.
function hh_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hh_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mm_a_Callback(hObject, eventdata, handles)
% hObject    handle to mm_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mm_a as text
%        str2double(get(hObject,'String')) returns contents of mm_a as a double


% --- Executes during object creation, after setting all properties.
function mm_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mm_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ss_a_Callback(hObject, eventdata, handles)
% hObject    handle to ss_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ss_a as text
%        str2double(get(hObject,'String')) returns contents of ss_a as a double


% --- Executes during object creation, after setting all properties.
function ss_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ss_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_sync.
function pushbutton_sync_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sync (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the handles for data
ECG=handles.ECG;
GSR=handles.GSR;
EMG=handles.EMG;
Ann=handles.annData;

%get abs time for physio
hh_p=get(handles.hh_p,'String')
hh_p=str2num(hh_p);
mm_p=get(handles.mm_p,'String')
mm_p=str2num(mm_p);
ss_p=get(handles.ss_p,'String')
ss_p=str2num(ss_p);
%get abs time for annotation
hh_a=get(handles.hh_a,'String')
hh_a=str2num(hh_a);
mm_a=get(handles.mm_a,'String')
mm_a=str2num(mm_a);
ss_a=get(handles.ss_a,'String')
ss_a=str2num(ss_a);
%convert abs time to second format
timePhysioAbs=hms2sec(hh_p,mm_p,ss_p);
timeVidAbs=hms2sec(hh_a,mm_a,ss_a);
%create dir to store the physio chunks
mkdir('ecg/ecg');
mkdir('gsr/gsr');
mkdir('emg/emg');

vidStart = regexp(Ann(1),',','split');
vidStartT=vidStart{:};

physioStartT = abs((timePhysioAbs-timeVidAbs)) + str2num(char(vidStartT(2)));

j=1;
while j<=length(Ann)
    splitAnn=regexp(Ann(j),',','split');
    splitAnn=splitAnn{:};
    labelStartT=str2num(char(splitAnn(2)));
    labelEndT=str2num(char(splitAnn(3)));
    affect = char(splitAnn(4));
 
    physioEndT=physioStartT + (labelEndT - labelStartT);
    
    ecgAffect=ECG(physioStartT*1000:physioEndT*1000);
    save(['ecg/ecg' int2str(j)] ,'ecgAffect', 'affect');
    
    gsrAffect=EMG(physioStartT*1000:physioEndT*1000);
    save(['gsr/emg' int2str(j)] ,'gsrAffect', 'affect');
    
    emgAffect=ECG(physioStartT*1000:physioEndT*1000);
    save(['emg/emg' int2str(j)] ,'emgAffect', 'affect');

    physioStartT=labelEndT;
    j=j+1;
end


% --- Executes on button press in pushbutton_group.
function pushbutton_group_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get the handles for data
ECG=handles.ECG;
GSR=handles.GSR;
EMG=handles.EMG;
Ann=handles.annData;

%get abs time for physio
hh_p=get(handles.hh_p,'String');
hh_p=str2num(hh_p);
mm_p=get(handles.mm_p,'String');
mm_p=str2num(mm_p);
ss_p=get(handles.ss_p,'String');
ss_p=str2num(ss_p);
%get abs time for annotation
hh_a=get(handles.hh_a,'String');
hh_a=str2num(hh_a);
mm_a=get(handles.mm_a,'String');
mm_a=str2num(mm_a);
ss_a=get(handles.ss_a,'String');
ss_a=str2num(ss_a);
%convert abs time to second format
timePhysioAbs=hms2sec(hh_p,mm_p,ss_p);
timeVidAbs=hms2sec(hh_a,mm_a,ss_a);
%create dir to store the physio chunks
mkdir('confusion');
mkdir('frustration');
mkdir('boredom');
mkdir('flow');
mkdir('curiosity');
mkdir('delight');
mkdir('surprise');
mkdir('neutral');
mkdir('other');

vidStart = regexp(Ann(1),',','split');
vidStartT=vidStart{:};

physioStartT = abs((timePhysioAbs-timeVidAbs)) + str2num(char(vidStartT(2)));

j=1;
a=0;
b=0;
c=0;
d=0;
e=0;
f=0;
g=0;
h=0;
while j<=length(Ann)
    splitAnn=regexp(Ann(j),',','split');
    splitAnn=splitAnn{:};
    labelStartT=str2num(char(splitAnn(2)));
    labelEndT=str2num(char(splitAnn(3)));
    affect = char(splitAnn(4));
 
    physioEndT=physioStartT + (labelEndT - labelStartT);

    if strcmp(affect,'''Confusion''')
        a=a+1;        
    gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
    save(['confusion/gsr' int2str(j)] ,'gsrAffect');
    
    elseif strcmp(affect,'''Frustration''')
        b=b+1;
    gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
    save(['frustration/gsr' int2str(j)] ,'gsrAffect');

    elseif strcmp(affect,'''Flow/Engagement''')
        c=c+1;
    gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
    save(['flow/gsr' int2str(j)] ,'gsrAffect');

    elseif strcmp(affect,'''Boredom''')
        c=c+1;
    gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
    save(['Boredom/gsr' int2str(j)] ,'gsrAffect');

    elseif strcmp(affect,'''Curiosity''')
        d=d+1;
    gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
    save(['curiosity/gsr' int2str(j)] ,'gsrAffect');

    elseif strcmp(affect,'''Delight''')
        e=e+1;
    gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
    save(['delight/gsr' int2str(j)] ,'gsrAffect');

    elseif strcmp(affect,'''Surprise''')
        f=f+1;
    gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
    save(['surprise/gsr' int2str(j)] ,'gsrAffect');

    elseif strcmp(affect,'''Neutral''')
        g=g+1;
    gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
    save(['neutral/gsr' int2str(j)] ,'gsrAffect');
    
    else
        h=h+1;
    gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
    save(['other/gsr' int2str(j)] ,'gsrAffect');
    end        

%     ecgAffect=ECG(physioStartT*1000:physioEndT*1000);
%     save(['ecg/ecg' int2str(j)] ,'ecgAffect', 'affect');
%     
%     gsrAffect=EMG(physioStartT*1000:physioEndT*1000);
%     save(['gsr/emg' int2str(j)] ,'gsrAffect', 'affect');
%     
%     emgAffect=ECG(physioStartT*1000:physioEndT*1000);
%     save(['emg/emg' int2str(j)] ,'emgAffect', 'affect');

    physioStartT=labelEndT;
    j=j+1;
end


function edit_dataLink_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dataLink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dataLink as text
%        str2double(get(hObject,'String')) returns contents of edit_dataLink as a double


% --- Executes during object creation, after setting all properties.
function edit_dataLink_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dataLink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_dataLink.
function pushbutton_dataLink_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_dataLink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename pathname] = uigetfile('*.txt*','Please select the file')

if ~filename
    return
end;

file_p=[pathname filename];
[path,name,ext,ver] = fileparts(file_p);
loadphysio=[name ext];

set(handles.edit_dataLink,'String',loadphysio);

handles.dataLinkdata = importdata(loadphysio);
guidata(hObject, handles);


% --- Executes on button press in pushbutton_import.
function pushbutton_import_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imLink=handles.dataLinkdata;

%---------->
fid=fopen(strcat('Mean_GSR', '.txt'),'w');%open file

j=1;
while j<=length(imLink)
    %import links and ATS from file
    splitLink=regexp(imLink(j),',','split');
    splitLink=splitLink{:};
   
    physioP=char(splitLink(1));
    physioATS=char(splitLink(2));
    pretestS=char(splitLink(3));
    pretestE=char(splitLink(4));
    moodTestS=char(splitLink(5));
    moodTestE=char(splitLink(6));
    
    splitTimeP=regexp(splitLink(2),':','split');
    splitTimeP=splitTimeP{:};
    
    hh_p=str2num(char(splitTimeP(1)));
    mm_p=str2num(char(splitTimeP(2)));
    ss_p=str2num(char(splitTimeP(3)));
    
    timePhysio=hms2sec(hh_p,mm_p,ss_p);
         
    splitTimePreS=regexp(splitLink(3),':','split');
    splitTimePreS=splitTimePreS{:};
    
    hh_preS=str2num(char(splitTimePreS(1)));
    mm_preS=str2num(char(splitTimePreS(2)));
    ss_preS=str2num(char(splitTimePreS(3)));
        
    timePreS=hms2sec(hh_preS,mm_preS,ss_preS);
    
    splitTimePreE=regexp(splitLink(4),':','split');
    splitTimePreE=splitTimePreE{:};
    
    hh_preE=str2num(char(splitTimePreE(1)));
    mm_preE=str2num(char(splitTimePreE(2)));
    ss_preE=str2num(char(splitTimePreE(3)));
        
    timePreE=hms2sec(hh_preE,mm_preE,ss_preE);
    
    splitTimeMoodS=regexp(splitLink(5),':','split');
    splitTimeMoodS=splitTimeMoodS{:};
    
    hh_MoodS=str2num(char(splitTimeMoodS(1)));
    mm_MoodS=str2num(char(splitTimeMoodS(2)));
    ss_MoodS=str2num(char(splitTimeMoodS(3)));
        
    timeMoodS=hms2sec(hh_MoodS,mm_MoodS,ss_MoodS);
    
    splitTimeMoodE=regexp(splitLink(6),':','split');
    splitTimeMoodE=splitTimeMoodE{:};
    
    hh_MoodE=str2num(char(splitTimeMoodE(1)));
    mm_MoodE=str2num(char(splitTimeMoodE(2)));
    ss_MoodE=str2num(char(splitTimeMoodE(3)));
        
    timeMoodE=hms2sec(hh_MoodE,mm_MoodE,ss_MoodE) ;
           
    %sync physio 
    %import physio data
    load(['siento_mood_test/', physioP]);
    GSR=data(:,2);
     
    physioPreS = abs((timePhysio-timePreS))+ 20 %start time pre-test
    physioPreE = abs((timePhysio-timePreE)) - 10 %end time pre-test
    physioMoodS = abs((timePhysio-timeMoodS)) + 20 %start time mood-test
    physioMoodE = abs((timePhysio-timeMoodE)) - 10 %end time mood-test
    
    preTest=GSR(physioPreS*1000:physioPreE*1000);
    moodTest=GSR(physioMoodS*1000:physioMoodE*1000);

    %preprocessing
    preTest = aubt_lowpassFilter (preTest, 1000, 0.3);
    preTest = aubt_scBaseline (preTest);
%     preTest = aubt_diffFilter (preTest);

    moodTest = aubt_lowpassFilter (moodTest, 1000, 0.3);
    moodTest = aubt_scBaseline (moodTest);
%     moodTest = aubt_diffFilter (moodTest);

    %mean GSR        
    mGSR_Pre=mean(preTest);   
    stdGSR_Pre=std(preTest);
    MaxGSR_Pre=max(preTest);
    MinGSR_Pre=min(preTest);
        
    
    mGSR_Mood=mean(moodTest); 
    stdGSR_Mood=std(moodTest);
    MaxGSR_Mood=max(moodTest);
    MinGSR_Mood=min(moodTest);
%         %mean HRV
%         rind = aubt_detecR (gsrAffect, 1000);
%         rr = diff (rind);
%         if rr>0
%         mGSR = mean (rr);
%         else
%         mGSR = 0;
%         end
               
%     
    fprintf(fid, '%10.6f,', mGSR_Pre,stdGSR_Pre,MaxGSR_Pre,MinGSR_Pre );%write start frame
    fprintf(fid, '%s', 'Pre_test');
    fprintf(fid, '\r');
    
    fprintf(fid, '%10.6f,', mGSR_Mood,stdGSR_Mood,MaxGSR_Mood,MinGSR_Mood);%write start frame
    fprintf(fid, '%s', 'Mood-Test');
    fprintf(fid, '\r');
% 
%         physioStartT=labelEndT;
%         k=k+1;
%     end
    j=j+1;

    fprintf(fid,'%c,','s');
    fprintf(fid, '\r');
end
% close file
fclose(fid);

%---------------------->>

% fid=fopen(strcat('Mean_GSR', '.txt'),'w');%open file
% 
% j=1;
% while j<=length(imLink)
%     totalMean=0;
%     %import links and ATS from file
%     splitLink=regexp(imLink(j),',','split');
%     splitLink=splitLink{:};
%    
%     physioP=char(splitLink(1));
%     physioATS=char(splitLink(3));
%     labelP=char(splitLink(2));
%     labelATS=char(splitLink(4));
%     
%     splitTimeP=regexp(splitLink(3),':','split');
%     splitTimeP=splitTimeP{:};
%     
%     hh_p=str2num(char(splitTimeP(1)));
%     mm_p=str2num(char(splitTimeP(2)));
%     ss_p=str2num(char(splitTimeP(3)));
%          
%     splitTimeL=regexp(splitLink(4),':','split');
%     splitTimeL=splitTimeL{:};
%     
%     hh_l=str2num(char(splitTimeL(1)));
%     mm_l=str2num(char(splitTimeL(2)));
%     ss_l=str2num(char(splitTimeL(3)));
%         
%     timePhysioAbs=hms2sec(hh_p,mm_p,ss_p);
%     timeVidAbs=hms2sec(hh_l,mm_l,ss_l);
%     
%     %sync physio with annotations
%     %import physio data
%     load(['siento_autotutor/', physioP]);
%     GSR=data(:,1);
%  
%     %import annotations file 
%     annData = importdata(['siento_autotutor/' labelP]);
%     vidStart = regexp(annData(1),',','split');
%     vidStartT=vidStart{:};
%     
%     physioStartT = abs((timePhysioAbs-timeVidAbs)) + str2num(char(vidStartT(2)))
%     
%     k=1;
%     while k<=length(annData)
%         splitAnn=regexp(annData(k),',','split');
%         splitAnn=splitAnn{:};
%         labelStartT=str2num(char(splitAnn(2)));
%         labelEndT=str2num(char(splitAnn(3)));
%         affect = char(splitAnn(4));
%      
%         physioEndT=physioStartT + (labelEndT - labelStartT);
%         gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
%         
%         %preprocessing
%         gsrAffect = aubt_lowpassFilter (gsrAffect, 1000, 0.3);
%         gsrAffect = aubt_scBaseline (gsrAffect);
% %         gsrAffect = aubt_diffFilter (gsrAffect);
%         %mean GSR        
% %         mGSR=mean(gsrAffect);   
%         
%         %mean HRV
%         rind = aubt_detecR (gsrAffect, 1000);
%         rr = diff (rind);
%         if rr>0
%         mGSR = mean (rr);
%         else
%         mGSR = 0;
%         end
%                 
%         totalMean=mGSR+totalMean;
%     
%         fprintf(fid, '%10.6f,', mGSR);%write start frame
%         fprintf(fid, '%s', affect);
%         fprintf(fid, '\r');
% 
%         physioStartT=labelEndT;
%         k=k+1;
%     end
%     j=j+1;
%     fprintf(fid, '%10.6f,', totalMean);%write start frame
%     fprintf(fid, '%s', 'total');
%     fprintf(fid, '\r');
%     fprintf(fid,'%c,','s');
%     fprintf(fid, '\r');
% end
% % close file
% fclose(fid);


% --- Executes on button press in pushbutton_mGSR.
function pushbutton_mGSR_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_mGSR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mGSR = importdata('Mean_GSR.txt');

mConfusion=0;
mFrustration=0;
mFlow_Engagement=0;
mCuriosity=0;
mBoredom=0;
mSurprise=0;
mDelight=0;
mNeutral=0;
total=0;
n1=0;
n2=0;
n3=0;
n4=0;
n5=0;
n6=0;
n7=0;
n8=0; 
n9=0;

fid=fopen(strcat('Avg_GSR', '.txt'),'w');%open file
fprintf(fid, '%s,', 'avgConfusion');
fprintf(fid, '%s,', 'avgFrustration');  
fprintf(fid, '%s,', 'avgFlow_Engagement');
fprintf(fid, '%s,', 'avgCuriosity');
fprintf(fid, '%s,', 'mBoredom');
fprintf(fid, '%s,', 'mSurprise');  
fprintf(fid, '%s,', 'mDelight');
fprintf(fid, '%s,', 'mNeutral');
fprintf(fid, '%s,', 'mTotal');

fprintf(fid, '\r');

j=1;
while j<=length(mGSR)
    
    splitGSR=regexp(mGSR(j),',','split');
    splitGSR=splitGSR{:};

    meanG=char(splitGSR(1));
    affect=char(splitGSR(2));
    
    if strcmp(meanG,'s')
        
        if n1>0
            avgConfusion = mConfusion/n1;
            fprintf(fid, '%10.6f,', avgConfusion);%write start frame
        else
            fprintf(fid, '%10.1f,', 10000);%write start frame
        end
        
        if n2>0
            avgFrustration = mFrustration/n2;  
            fprintf(fid, '%10.6f,', avgFrustration);%write start frame
                else
            fprintf(fid, '%10.1f,', 10000);%write start frame
        end
        
        if n3>0
            avgFlow_Engagement = mFlow_Engagement/n3; 
            fprintf(fid, '%10.6f,', avgFlow_Engagement);%write start frame
                else
            fprintf(fid, '%10.1f,', 10000);%write start frame
        end

        if n4>0
            avgCuriosity = mCuriosity/n4;        
            fprintf(fid, '%10.6f,', avgCuriosity);%write start frame
                else
            fprintf(fid, '%10.1f,', 10000);%write start frame
        end  
        
        if n5>0
            avgBoredom = mBoredom/n5;
            fprintf(fid, '%10.6f,', avgBoredom);%write start frame
                else
            fprintf(fid, '%10.1f,', 10000);%write start frame
        end
        
        if n6>0
            avgSurprise = mSurprise/n6;  
            fprintf(fid, '%10.6f,', avgSurprise);%write start frame
                else
            fprintf(fid, '%10.1f,', 10000);%write start frame
        end
        
        if n7>0
            avgDelight = mDelight/n7; 
            fprintf(fid, '%10.6f,', avgDelight);%write start frame
                else
            fprintf(fid, '%10.1f,', 10000);%write start frame
        end

        if n8>0
            avgNeutral = mNeutral/n8;        
            fprintf(fid, '%10.6f,', avgNeutral);%write start frame
                else
            fprintf(fid, '%10.1f,', 10000);%write start frame
        end 
        
        if n9>0 
            avgTotal =  total /(n1+n2+n3+n4+n5+n6+n7+n8);
            fprintf(fid, '%10.6f,', avgTotal);%write start frame
        else
            fprintf(fid, '%10.1f,', 10000);%write start frame
        end 
       
        fprintf(fid, '\r');
        mConfusion=0;
        mFrustration=0;
        mFlow_Engagement=0;
        mCuriosity=0;
        mBoredom=0;
        mSurprise=0;
        mDelight=0;
        mNeutral=0;
        total=0;
        n1=0;
        n2=0;
        n3=0;
        n4=0;
        n5=0;
        n6=0;
        n7=0;
        n8=0;    
        n9=0;
    else
        if strcmp(affect,'''Confusion''') %&& (str2double(meanG)>=0)
            mConfusion=mConfusion + str2double(meanG);
            n1=n1+1;
        elseif strcmp(affect,'''Frustration''') %&& (str2double(meanG)>=0)
            mFrustration=mFrustration + str2double(meanG); 
            n2=n2+1;
        elseif strcmp(affect,'''Flow/Engagement''') %&& (str2double(meanG)>=0)
            mFlow_Engagement=mFlow_Engagement +str2double(meanG); 
            n3=n3+1;
        elseif strcmp(affect,'''Curiosity''') %&& (str2double(meanG)>=0)
            mCuriosity=mCuriosity + str2double(meanG); 
            n4=n4+1;
        elseif strcmp(affect,'''Boredom''') %&& (str2double(meanG)>=0)
            mBoredom=mBoredom + str2double(meanG); 
            n5=n5+1;
        elseif strcmp(affect,'''Surprise''') %&& (str2double(meanG)>=0)
            mSurprise=mSurprise + str2double(meanG); 
            n6=n6+1;
        elseif strcmp(affect,'''Delight''') %&& (str2double(meanG)>=0)
            mDelight=mDelight + str2double(meanG); 
            n7=n7+1;
        elseif strcmp(affect,'''Neutral''') %&& (str2double(meanG)>=0)
            mNeutral=mNeutral + str2double(meanG); 
            n8=n8+1;
        elseif strcmp(affect,'total') %&& (str2double(meanG)>=0)
            total=str2double(meanG);
            n9=n9+1;
        end        
    end       
    j=j+1;
end
% close file
fclose(fid);
    
    % --- Executes on button press in pushbutton_feat.
function pushbutton_feat_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_feat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get the handles for data
imLink=handles.dataLinkdata

j=1;
while j<=length(imLink)
    %import links and ATS from file
    splitLink=regexp(imLink(j),',','split');
    splitLink=splitLink{:};
   
    physioP=char(splitLink(1));%path for physio
    physioATS=char(splitLink(3));%physio time stamp
    labelP=char(splitLink(2));%label path
    labelATS=char(splitLink(4));%label time stamp
    
    if (strncmp(physioP, '%%', 2))
        j=j+1;
        continue;
    end
    
    splitTimeP=regexp(splitLink(3),':','split');
    splitTimeP=splitTimeP{:};
    
    %sub ID and dir for features
    subID=j
    mkdir('feat_new');%changed here
        
    %physio time units
    hh_p=str2num(char(splitTimeP(1)));
    mm_p=str2num(char(splitTimeP(2)));
    ss_p=str2num(char(splitTimeP(3)));
         
    splitTimeL=regexp(splitLink(4),':','split');
    splitTimeL=splitTimeL{:};
    
    %label time units
    hh_l=str2num(char(splitTimeL(1)));
    mm_l=str2num(char(splitTimeL(2)));
    ss_l=str2num(char(splitTimeL(3)));
    
    %convert time stamps to seconds
    timePhysioAbs=hms2sec(hh_p,mm_p,ss_p);
    timeVidAbs=hms2sec(hh_l,mm_l,ss_l);
    
    %import physio data
    load(['siento_autotutor1/', physioP]);%changed here
    ECG=data(:,1);%ecg channel
    GSR=data(:,2);%gsr channel
    % preprocessing

GSR = aubt_lowpassFilter (GSR, 1000, 0.3);
GSR = aubt_scBaseline (GSR);

    EMG=data(:,2);%emg channel %changed here
    
    %import annotations file 
    annData = importdata(['siento_autotutor1/' labelP]);%changed here
    vidStart = regexp(annData(1),',','split');
    vidStartT=vidStart{:};
    
    physioStartT = abs((timePhysioAbs-timeVidAbs)) + str2num(char(vidStartT(2)))
    
    physioP_f = regexprep(physioP, '.mat', '.txt')
    physioP_f = regexprep(physioP_f, '_2.txt', '.txt')

    
    fid=fopen(strcat('feat_new/',physioP_f),'w');%changed here
    k=1;
    first = 1;
    while k<=length(annData)
        splitAnn=regexp(annData(k),',','split');
        splitAnn=splitAnn{:};
        labelStartT=str2num(char(splitAnn(2)));
        labelEndT=str2num(char(splitAnn(3)));
        affect = char(splitAnn(4));
     
        physioEndT=physioStartT + (labelEndT - labelStartT);
 
        ecgAffect=ECG(physioStartT*1000:physioEndT*1000);
        gsrAffect=GSR(physioStartT*1000:physioEndT*1000);
        emgAffect=EMG(physioStartT*1000:physioEndT*1000);
        sRate=1000;
    
        
        for t=1:1
        
            lenECG_10=length(ecgAffect)/1;
            lenGSR_10=length(gsrAffect)/1;
            lenEMG_10=length(emgAffect)/1;


            if t==1
                ecgAffect10=ecgAffect(1:lenECG_10-0);
                gsrAffect10=gsrAffect(1:lenGSR_10-0);
                emgAffect10=emgAffect(1:lenEMG_10-0);            
            elseif t==2
                ecgAffect10=ecgAffect(lenECG_10:length(ecgAffect)-1);
                gsrAffect10=gsrAffect(lenECG_10:length(ecgAffect)-1);
                emgAffect10=emgAffect(lenECG_10:length(ecgAffect)-1);          
            end
            
            if (~first)
                k = k +1;
            end
            
            [featmat1  featnames1 featmat2  featnames2 featmat3  featnames3] = aubtProxy(ecgAffect10, gsrAffect10, emgAffect10,  sRate);

            if first
                for m=1:length(featnames1)
                fprintf(fid, '%s,', char(featnames1(m)));%write start frame
                end
                for m=1:length(featnames2)
                fprintf(fid, '%s,', char(featnames2(m)));%write start frame
                end
                %for m=1:length(featnames3)%changed here
                %fprintf(fid, '%s,', char(featnames3(m)));%write start frame
                %end
                fprintf(fid, '%s', 'Class');
                fprintf(fid, '\r\n');%write start frame
                first = 0;
            else
                for m=1:length(featmat1)
                fprintf(fid, '%10.6f,', featmat1(m));%write start frame
                end
                for m=1:length(featmat2)
                fprintf(fid, '%10.6f,', featmat2(m));%write start frame
                end
                %for m=1:length(featmat3)%changed here
                %fprintf(fid, '%10.6f,', featmat3(m));%write start frame
                %end
                fprintf(fid, '%s', affect);
                fprintf(fid, '\r\n');%write start frame
            end
        
        end %for t=
        
        physioStartT=labelEndT;
       
    end
    j=j+1;
end
%close file
fclose(fid);
 


% --- Executes on button press in pushbutton_feedback.
function pushbutton_feedback_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_feedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imLink=handles.dataLinkdata;

%import annotations file 
annData = importdata(['aro_siento_iaps_sub1_2010-04-23.txt']);
j=1;
while j<=length(imLink)
    %import links and ATS from file
    splitLink=regexp(imLink(j),',','split');
    splitLink=splitLink{:};
   
    physioP=char(splitLink(1));%path for physio
    physioATS=splitLink(3);%physio time stamp
    
    if (strncmp(physioP, '%%', 2))
        j=j+1;
        continue;
    end
    
    splitTimeP=regexp(physioATS,':','split');
    splitTimeP=splitTimeP{:};
    
    %sub ID and dir for features
    subID=j
    mkdir('feat_aips');
        
    %physio time units
    hh_p=str2num(char(splitTimeP(1)));
    mm_p=str2num(char(splitTimeP(2)));
    ss_p=str2num(char(splitTimeP(3)));
             
    %convert time stamps to seconds
    timePhysioAbs=hms2sec(hh_p,mm_p,ss_p);
    
    %import physio data
    load(['siento_iaps/', physioP]);
    ECG=data(:,1);%ecg channel
    GSR=data(:,2);%gsr channel
    EMG=data(:,5);%emg channel
    
    physioP_f = regexprep(physioP, '.mat', '.txt')
    physioP_f = regexprep(physioP_f, '_2.txt', '.txt')
    
    fid=fopen(strcat(['feat_aips/',physioP_f]),'w');%open file
    %fid=fopen(strcat('feat/',num2str(j),'.txt'),'w');%open file
    k=1;
    first = 1;
    while k<=length(annData)
        annData(k)
        splitAnn=regexp(annData(k),',','split');
        splitAnn=splitAnn{:};
        
        subjectID = char(splitAnn(1));
        absTime = splitAnn(2);
        feedbackType = char(splitAnn(3));
        if ( ~strncmp(physioP, subjectID, 22))
            k = k + 1;
            continue;
        end
        
        if (~first)
            k=k+1;
        end
        
        splitTimeF=regexp(absTime,':','split');
        splitTimeF=splitTimeF{:};
        hh_f=str2num(char(splitTimeF(1)));
        mm_f=str2num(char(splitTimeF(2)));
        ss_f=str2num(char(splitTimeF(3)));
        timeFeedbackAbs=hms2sec(hh_f,mm_f,ss_f);
        
        physioStartT = timeFeedbackAbs - timePhysioAbs 
        
        for slideWindow = 10:10
            physioEndT = physioStartT + slideWindow;
 
            ecgAffect=ECG(physioStartT*1000:physioEndT*1000);
            gsrAffect=EMG(physioStartT*1000:physioEndT*1000);
            emgAffect=ECG(physioStartT*1000:physioEndT*1000);
            sRate=1000;
    
            [featmat1  featnames1 featmat2  featnames2 featmat3  featnames3] = aubtProxy(ecgAffect, gsrAffect, emgAffect,  sRate);
            if first;
                for m=1:length(featnames1)
                    fprintf(fid, '%s,', char(featnames1(m)));%write start frame
                end
                for m=1:length(featnames2)
                    fprintf(fid, '%s,', char(featnames2(m)));%write start frame
                end
                for m=1:length(featnames3)
                    fprintf(fid, '%s,', char(featnames3(m)));%write start frame
                end
                fprintf(fid, '%s', 'Class');
                fprintf(fid, '\r\n');%write start frame
                first = 0;
                break;
            else
                for m=1:length(featmat1)
                    fprintf(fid, '%10.6f,', featmat1(m));%write start frame
                end
                for m=1:length(featmat2)
                    fprintf(fid, '%10.6f,', featmat2(m));%write start frame
                end
                for m=1:length(featmat3)
                    fprintf(fid, '%10.6f,', featmat3(m));%write start frame
                end
                fprintf(fid, '%s', feedbackType);
                fprintf(fid, '\r\n');%write start frame
            end
        end
    end
    j=j+1;
end
%close file
fclose(fid);


% --- Executes on button press in pushbutton_feedBackEmo.
function pushbutton_feedBackEmo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_feedBackEmo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imLink=handles.dataLinkdata;

%import annotations file 
feedBData = importdata(['feedback.txt']);
j=1;
% fid=fopen(strcat('feed_emo/all.txt'),'w');%open file
while j<=length(imLink)
    %import links and ATS from file
    splitLink=regexp(imLink(j),',','split');
    splitLink=splitLink{:};
   
    annoP=char(splitLink(2));%path for anno
    annData = importdata(['siento_autotutor1/' annoP]);
    annoATS=splitLink(4);%anno time stamp
    splitTimeAnn=regexp(annoATS,':','split');
    splitTimeAnn=splitTimeAnn{:};
    %Anno time units
    hh_a=str2num(char(splitTimeAnn(1)));
    mm_a=str2num(char(splitTimeAnn(2)));
    ss_a=str2num(char(splitTimeAnn(3)));
    %convert time stamps to seconds
    timeAnnoAbs=hms2sec(hh_a,mm_a,ss_a);
    
    splitAnnRow=regexp(annData(1),',','split');
    splitAnnRow=splitAnnRow{:};
    annStartTimeAbs =  timeAnnoAbs + str2num(char(splitAnnRow(2)));
    
    %sub ID and dir for features
    subID=j
    mkdir('feed_emo');
        
  
    fid=fopen(strcat(['feed_emo/',annoP]),'w');%open file
    k=1;
    while k<=length(feedBData)
        splitFeedB=regexp(feedBData(k),',','split');
        splitFeedB=splitFeedB{:};
        
        subjectID = char(splitFeedB(1))
        absTime = splitFeedB(2)
        feedbackType = char(splitFeedB(3));
        if ( ~strncmp(annoP, subjectID, 22))
            k = k + 1;
            continue;
        end
        
        splitTimeF=regexp(absTime,':','split');
        splitTimeF=splitTimeF{:};
        hh_f=str2num(char(splitTimeF(1)));
        mm_f=str2num(char(splitTimeF(2)));
        ss_f=str2num(char(splitTimeF(3)));
        timeFeedbackAbs=hms2sec(hh_f,mm_f,ss_f);
        
        diffTime = timeFeedbackAbs - annStartTimeAbs
        indexOfAnn  = floor(diffTime/20)
        
        splitAnnRow=regexp(annData(indexOfAnn),',','split');
        splitAnnRow=splitAnnRow{:};
        startAnnT = str2num(char(splitAnnRow(2)));
        endAnnT = str2num(char(splitAnnRow(3)));
        
        if (diffTime < startAnnT)
            indexOfAnn = indexOfAnn - 1;
        elseif (diffTime > startAnnT && diffTime < endAnnT)
            indexOfAnn = indexOfAnn;
        elseif (diffTime > startAnnT)
            indexOfAnn = indexOfAnn + 1;    
        end
        splitAnnRow=regexp(annData(indexOfAnn),',','split');
        splitAnnRow=splitAnnRow{:};
            
        
        fprintf(fid, '%s,', char(splitFeedB(1)));%write start frame
        fprintf(fid, '%s,', char(splitFeedB(2)));%write start frame
        fprintf(fid, '%s,', char(splitFeedB(3)));%write start frame
        fprintf(fid, '%s', char(splitAnnRow(4)));
        fprintf(fid, '\r\n');%write start frame
        k=k+1;
    end
    j=j+1;
%     close file
    fclose(fid);
end
%close file
%fclose(fid);
