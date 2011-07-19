function varargout = dataInspector(varargin)
% DATAINSPECTOR M-file for dataInspector.fig
%      DATAINSPECTOR, by itself, creates a new DATAINSPECTOR or raises the existing
%      singleton*.
%
%      H = DATAINSPECTOR returns the handle to a new DATAINSPECTOR or the handle to
%      the existing singleton*.
%
%      DATAINSPECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAINSPECTOR.M with the given input arguments.
%
%      DATAINSPECTOR('Property','Value',...) creates a new DATAINSPECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dataInspector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dataInspector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dataInspector

% Last Modified by GUIDE v2.5 18-Feb-2010 12:21:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dataInspector_OpeningFcn, ...
                   'gui_OutputFcn',  @dataInspector_OutputFcn, ...
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


% --- Executes just before dataInspector is made visible.
function dataInspector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dataInspector (see VARARGIN)
global ghandles;


addpath('utils');
% Choose default command line output for dataInspector
handles.output = hObject;
% set(gcf,'Color',[0 0 0]);
pos=[0 140 460 450];

config_clip;



MovieControl = actxcontrol('WMPlayer.OCX',pos)
set(MovieControl,'uiMode','none');
MovieControl.controls.events
%return
assignin('base','MovieControl',MovieControl);
set(MovieControl.settings,'autoStart',0);
set(MovieControl.controls,'CurrentPosition',startVid1);
set(MovieControl,'enableContextMenu',0);
set(MovieControl,'enabled',0);
set(MovieControl,'uiMode','full');

handles.MovieControl = MovieControl;


MovieControl.registerevent({'PlayStateChange', 'handle_event_PlayState'}); 
MovieControl.registerevent({'PositionChange', 'handle_event_Position'}); 

workdir=pwd;
handles.workdir=workdir;


set(handles.figure1,'CloseRequestFcn',@closeGUI);%for closing function
% UIWAIT makes act_ive_gui_new wait for user response (see UIRESUME)
% uiwait(handles.figure1);


handles.dataLinkdata = importdata(autoTutorData);



global tim;
tim = timer('Period', .5,...
    'ExecutionMode','fixedRate');
handles.timer = tim;

handles.startPhysio = 0;

guidata(hObject, handles);
    
ghandles = handles;

%axes(handles.axes1);
%set(gca,'xlim',100+[0 physioInterval]);
%guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = dataInspector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function closeGUI(src,evnt)
%src is the handle of the object generating the callback (the source of the event)
%evnt is the The event data structure (can be empty for some callbacks)
selection = questdlg('Do you want to close the VidLabel?',...
                     'Close Request Function',...
                     'Yes','No','Yes');
global tim;
switch selection,
   case 'Yes',
    delete(gcf);

    
    delete(tim);
    
   case 'No'
     return
end


function Timer_Callback(obj, event, handles)
config_clip;

annData = handles.annData;
mp = handles.MovieControl;
absCurrentP=mp.controls.currentPosition;
currentP = absCurrentP - startVid1 + handles.startPhysio;

    

%axes(handles.axes1);
set(handles.axes1,'xlim',currentP+[0 physioInterval]);
set(handles.axes2,'xlim',currentP+[0 physioInterval]);
set(handles.axes3,'xlim',currentP+[0 physioInterval]);
%guidata(hObject, handles);

indexOfAnn  = floor(absCurrentP/20)
if (indexOfAnn == 0)
    indexOfAnn = 1;
end
splitAnnRow=regexp(annData(indexOfAnn),',','split');
splitAnnRow=splitAnnRow{:};
startAnnT = str2num(char(splitAnnRow(2)));
endAnnT = str2num(char(splitAnnRow(3)));
         
if (absCurrentP < startAnnT)
      indexOfAnn = indexOfAnn - 1;
elseif (absCurrentP > startAnnT && absCurrentP < endAnnT)
      indexOfAnn = indexOfAnn;
elseif (absCurrentP > startAnnT)
      indexOfAnn = indexOfAnn + 1;    
end

affect = 'Not Labeled';

if (indexOfAnn == 0)
    indexOfAnn = 1;
else
    splitAnnRow=regexp(annData(indexOfAnn),',','split');
    splitAnnRow=splitAnnRow{:};
    affect = char(splitAnnRow(4));

end

    set(handles.emotionTag,'String',affect);

disp 'Timers running';


% --- Executes on selection change in vidList.
function vidList_Callback(hObject, eventdata, handles)
% hObject    handle to vidList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns vidList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from vidList

selectedIndex = get(handles.vidList,'Value')
if (selectedIndex == 1) 
   return;
end

selected = get(handles.vidList,'String')
loadData(hObject,handles,selected(selectedIndex));


function loadData(hObject,handles,subjectID)
global ghandles;
global tim;
stop(tim);
config_clip;

imLink=handles.dataLinkdata;

j=1;
while j<=length(imLink)
    %import links and ATS from file
    splitLink=regexp(imLink(j),',','split');
    splitLink=splitLink{:};
 
    
    subID=char(splitLink(1));
    
    if (~strcmp(subID, subjectID))
        j=j+1;
        continue;
    end


    
    videoPath = [videoRootFolder,'/',subID,'/',char(splitLink(2))];
    physioPath=[physioRootFolder,'/',subID,char(splitLink(3))];%path for physio
    physioTS=splitLink(5);%physio time stamp
    labelPath=[physioRootFolder,'/',subID,char(splitLink(4))];%label path
    labelTS=splitLink(6);%label time stamp
    
    splitTimeP=regexp(physioTS,':','split');
    splitTimeP=splitTimeP{:};

    %physio time units
    hh_p=str2double(char(splitTimeP(1)));
    mm_p=str2double(char(splitTimeP(2)));
    ss_p=str2double(char(splitTimeP(3)));
         
    splitTimeL=regexp(labelTS,':','split');
    splitTimeL=splitTimeL{:};
    
    %label time units
    hh_l=str2double(char(splitTimeL(1)));
    mm_l=str2double(char(splitTimeL(2)));
    ss_l=str2double(char(splitTimeL(3)));
    
    %convert time stamps to seconds
    timePhysioAbs=hms2sec(hh_p,mm_p,ss_p);
    timeVidAbs=hms2sec(hh_l,mm_l,ss_l);

    startPhysio = abs((timePhysioAbs-timeVidAbs));
    
    handles.startPhysio = startPhysio;
    
    mp = handles.MovieControl;
    mp.URL=videoPath;

    config_clip;
    set(mp.controls,'CurrentPosition',startVid1);
    set(mp,'enabled',1);

    
    annData = importdata(labelPath);
    
    handles.annData = annData;
    
    %vidStart = regexp(annData(1),',','split');
    %vidStartT=vidStart{:};

    load(physioPath);
    
    ecgFiltered = bio_cleaner2 (1000,80,1,data(: , 1));
    scFiltered = bio_cleaner2 (1000,10,0.05,data(: , 2));
    emgFiltered = bio_cleaner2 (1000,200,20,data(: , 3));
    E1 = ones(2500);
    %ecg= data(: , 1);
    %sc= data(: , 2);
    %emg= data(: , 3);
    
    ecgfs = 1000/ecgDownsampleFactor;
    emgfs = 1000/emgDownsampleFactor;
    scfs = 1000/scDownsampleFactor;
    axes(handles.axes1);
    ecg = downsample(ecgFiltered,ecgDownsampleFactor);
    ecgTime = 1/ecgfs : 1/ecgfs : (length(ecg)/ecgfs);
    ecgPlot = plot(ecgTime,ecg);
    set(ecgPlot,'Color','blue')
    title('ECG');
    set(gca,'xtick',[]); 
    %set(gcf,'doublebuffer','on');
    set(gca,'xlim',[0 physioInterval]);
    set(gca,'ylim',[min(ecg) max(ecg)]);
    ecgTimeMin=startPhysio;
    set(gca,'xlim',[ecgTimeMin ecgTimeMin+physioInterval]);
    

    axes(handles.axes2);
    sc = downsample(scFiltered,scDownsampleFactor);
    scTime = 1/scfs : 1/scfs : (length(sc)/scfs);
    scPlot = plot(scTime,sc);
    set(scPlot,'Color','red')
    title('SC');
    set(gca,'xtick',[]); 
    %set(gcf,'doublebuffer','on');
    set(gca,'xlim',[0 physioInterval]);
    set(gca,'ylim',[min(sc) max(sc)]);
    scTimeMin=startPhysio;
    set(gca,'xlim',[scTimeMin scTimeMin+physioInterval]);

    axes(handles.axes3);
    emg = downsample(emgFiltered,emgDownsampleFactor);
    emgTime = 1/emgfs : 1/emgfs : (length(emg)/emgfs);
    emgPlot = plot(emgTime,emg);
    set(emgPlot,'Color',[0.3,0.4,0.6])
    title('EMG');
    %set(gcf,'doublebuffer','on');
    set(gca,'xlim',[0 physioInterval]);
    set(gca,'ylim',[min(emg) max(emg)]);
    emgTimeMin=startPhysio;
    set(gca,'xlim',[emgTimeMin emgTimeMin+physioInterval]);

    guidata(hObject, handles);

    
    ghandles = handles;
    
    tim.TimerFcn = {@Timer_Callback, handles};
    break;    
end

% --- Executes during object creation, after setting all properties.
function vidList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vidList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
