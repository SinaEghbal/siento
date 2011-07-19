function varargout = doubleVid(varargin)
% DOUBLEVID M-file for doubleVid.fig
%      DOUBLEVID, by itself, creates a new DOUBLEVID or raises the existing
%      singleton*.
%
%      H = DOUBLEVID returns the handle to a new DOUBLEVID or the handle to
%      the existing singleton*.
%
%      DOUBLEVID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOUBLEVID.M with the given input arguments.
%
%      DOUBLEVID('Property','Value',...) creates a new DOUBLEVID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before doubleVid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to doubleVid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help doubleVid

% Last Modified by GUIDE v2.5 03-Nov-2009 12:33:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @doubleVid_OpeningFcn, ...
                   'gui_OutputFcn',  @doubleVid_OutputFcn, ...
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


% --- Executes just before doubleVid is made visible.
function doubleVid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to doubleVid (see VARARGIN)
global ghandles;
global subtitle_cnt;

subtitle_cnt=1;

addpath('utils');
% Choose default command line output for doubleVid
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
if (stopAuto)
    set(MovieControl,'uiMode','mini');
else
    set(MovieControl,'uiMode','full');
end

MovieControl.URL=['F:\Auto Tutor Experiment\02Nov09\siento_sub1_2009-11-02' 'Video_021109_122850_0.wmv'];

handles.MovieControl = MovieControl;


MovieControl.registerevent({'PlayStateChange', 'handle_event_PlayState'}); 
MovieControl.registerevent({'PositionChange', 'handle_event_Position'}); 

pos2=[470 140 750 560];
MovieControl2 = actxcontrol('WMPlayer.OCX',pos2)
set(MovieControl2,'uiMode','none');
assignin('base','MovieControl2',MovieControl2);
set(MovieControl2.settings,'autoStart',0);
set(MovieControl2.controls,'CurrentPosition',startVid2);
set(MovieControl2,'enableContextMenu',0);
%set(MovieControl2,'uiMode','full');
handles.MovieControl2 = MovieControl2;

MovieControl2.URL=['F:\Auto Tutor Experiment\02Nov09\siento_sub1_2009-11-02' 'Video_021109_122850_0.wmv'];


%MovieControl2.registerevent({'PlayStateChange', 'handle_event_player1'}); 

workdir=pwd;
handles.workdir=workdir;


[a,map]=imread('open_files.jpg');
[r,c,d]=size(a); 
x=ceil(r/30); 
y=ceil(c/30); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.openMedia1,'CData',g);

[a,map]=imread('open_files.jpg');
[r,c,d]=size(a); 
x=ceil(r/30); 
y=ceil(c/30); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.openMedia2,'CData',g);

[a,map]=imread('nextButton.jpg');
[r,c,d]=size(a); 
x=ceil(r/30); 
y=ceil(c/30); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.nextButton,'CData',g);

[a,map]=imread('prevButton.jpg');
[r,c,d]=size(a); 
x=ceil(r/30); 
y=ceil(c/30); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.prevButton,'CData',g);

%clc
% Update handles structure
guidata(hObject, handles);


%load labels from config
config_labels;
labelLen=length(mylabels)
%create user defined labels set from the list config_labels
    for i=1:12
        xx=['handles.checkbox' int2str(i)];
        set(eval(xx), 'Enable', 'off');
        if (i <= labelLen)
            set(eval(xx), 'String', mylabels(i));
            set(eval(xx), 'TooltipString', char(mylabelsTooltip(i)));
        else
            set(eval(xx), 'String', '-');
        end
    end

if (stopAuto)
    set(handles.startLabel, 'Enable', 'off');
    set(handles.nextButton, 'Enable', 'off');
    set(handles.prevButton, 'Enable', 'off');
else
    set(handles.nextButton, 'visible', 'off');
    set(handles.prevButton, 'visible', 'off');
    set(handles.startLabel, 'Enable', 'on');
end
set(handles.endLabel, 'Enable', 'off');

global fid;
fid=fopen(strcat('video', '.txt'),'w');%open file
set(handles.figure1,'CloseRequestFcn',@closeGUI);%for closing function
% UIWAIT makes act_ive_gui_new wait for user response (see UIRESUME)
% uiwait(handles.figure1);
ghandles = handles;

global tim;
if (stopAuto)
    startLabel(handles);
tim = timer('Period', 1,...
          'ExecutionMode','fixedRate');
tim.TimerFcn = {@Timer_Callback, handles};
start(tim)

end


% --- Outputs from this function are returned to the command line.
function varargout = doubleVid_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openMedia1.
function openMedia1_Callback(hObject, eventdata, handles)
% hObject    handle to openMedia1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile('*.*','Please select a file')

if ~filename
    return
end;

file1=[pathname filename]
[path,name,ext,ver] = fileparts(file1);
% set(handles.listbox1,'String',[name,ext],'Value',1);

mp = handles.MovieControl;
mp.URL=[pathname filename];
dir_path=pathname;

handles.dir_path=dir_path;
handles.pan=file1;
handles.numind=1;
numind=handles.numind
guidata(hObject,handles)
% set(handles.listbox1,'UserData',dir_path);
config_clip;
set(mp.controls,'CurrentPosition',startVid1);
global lastAutoStoppedFrame;
lastAutoStoppedFrame=mp.controls.currentPosition;
set(mp,'enabled',1);

% --- Executes on button press in pushbutton33.
function openMedia2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile('*.*','Please select a file')

if ~filename
    return
end;

file2=[pathname filename]
[path,name,ext,ver] = fileparts(file2);
% set(handles.listbox1,'String',[name,ext],'Value',1);

mp = handles.MovieControl2;
mp.URL=[pathname filename];
dir_path=pathname;

handles.dir_path=dir_path;
handles.pan=file2;
handles.numind=1;
numind=handles.numind
guidata(hObject,handles)
config_clip;
set(mp.controls,'CurrentPosition',startVid2);




% --- Executes on button press in startLabel.
function startLabel_Callback(hObject, eventdata, handles)
% hObject    handle to startLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
startLabel(handles);

function startLabel(handles)
set(handles.startLabel, 'Enable', 'off');
config_clip;
config_labels;
labelLen=length(mylabels);
%create user defined labels
if (stopAuto)
    set(handles.endLabel, 'Enable', 'off');
else
    set(handles.endLabel, 'Enable', 'on');
    for i=1:labelLen
        xx=['handles.checkbox' int2str(i)];
        set(eval(xx), 'Enable', 'on');
    end
end
mp = handles.MovieControl;    
currpos1=mp.controls.currentPosition;

global sFrame;%start frame
sFrame=currpos1;%start frame



function closeGUI(src,evnt)
%src is the handle of the object generating the callback (the source of the event)
%evnt is the The event data structure (can be empty for some callbacks)
selection = questdlg('Do you want to close the VidLabel?',...
                     'Close Request Function',...
                     'Yes','No','Yes');
switch selection,
   case 'Yes',
    delete(gcf);

    global fid;
    fclose(fid);%close file
    
    global tim;
    delete(tim);
    
   case 'No'
     return
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
handle_checkbox_callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12
handle_checkbox_callback(hObject, eventdata, handles)

function handle_checkbox_callback(hObject, eventdata, handles)
if (strcmp ('Other',get(hObject,'String')))
    if (get(hObject,'Value'))
        set(handles.Others_edit,'Visible','on');
    else
        set(handles.Others_edit,'Visible','off');
    end
end

% --- Executes on button press in endLabel.
function endLabel_Callback(hObject, eventdata, handles)
% hObject    handle to endLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
endLabel(handles,true);

function endLabel(handles,store)
mp = handles.MovieControl;
currpos1=mp.controls.currentPosition;
global sFrame
global eFrame;%end frame
global lastAutoStoppedFrame;
global fid;

if (store)
    eFrame=currpos1;%end frame with emotion  
    if (sFrame >= eFrame)
        errordlg('wrong selection');
        return;
    end
end

    config_clip;
    config_labels;
    labelLen=length(mylabels);
    %checkedEmo = ;
    j =1;
    for i=1:labelLen
        xx=['handles.checkbox', int2str(i)];
        if (get(eval(xx),'value'))
            if (strcmp ('Other',get(eval(xx),'String')))
                yy = cellstr(get(handles.Others_edit,'String'));
                yySt = strcat('Other-',yy)
                checkedEmo(j) =   yySt;
            else
               checkedEmo(j) =  mylabels(i); 
            end
            j = j +1;
        end
    end
    if (store)
        if (j == 1)
            errordlg('Please select emotion(s)');
        return
        end
    end
    
    set(handles.startLabel, 'Enable', 'on');
    set(handles.endLabel, 'Enable', 'off');
    for i=1:labelLen
        xx=['handles.checkbox' int2str(i)];
        set(eval(xx), 'Enable', 'off');
        set(eval(xx), 'value', 0);
    end
set(handles.Others_edit,'Visible','off');


if (store)
    %display the captured frames for this emotion
    global subtitle_cnt;
    set(handles.text_showTime, 'Visible', 'on');
    set(handles.text_showTime, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);

    fprintf(fid, '%s\r\n', int2str(subtitle_cnt));%write start frame
    
    [shour, sminute, ssecond] = sec2hms(sFrame);
    [ehour, eminute, esecond] = sec2hms(eFrame);
    
    fprintf(fid, '%d:%d:%d,000', shour, sminute, ssecond);%write start frame
    fprintf(fid, ' --> ');
    fprintf(fid, '%d:%d:%d,000', ehour, eminute, esecond);%write end frame
    fprintf(fid, '\r\n');
    for kk=1:length(checkedEmo)
        fprintf(fid, '''%s''\r\n', char(checkedEmo(kk)));%write emotionn
    end
    if (kk >= 2)
        ok = 0;
        Selection = 1;
        checkedEmo2 = ['.' checkedEmo];
        while (~ok || (Selection == 1))
        [Selection,ok] = listdlg('PromptString','Select the dominant emotion',...
                'SelectionMode','single',...
                'ListSize',[160 200],...
                'ListString',checkedEmo2);
         end
           
        fprintf(fid, '''%s''\r\n', char(strcat('Dominant-',checkedEmo2(Selection))));
    end
    
    fprintf(fid, '\r\n');

    subtitle_cnt = subtitle_cnt +1;
 
   
end

global tim;
if (stopAuto)
    lastAutoStoppedFrame = currpos1;
    startLabel(handles);
    playVideo(handles);
    start(tim);
end

if (stopAuto)
    set(handles.nextButton, 'Enable', 'off');
    set(handles.prevButton, 'Enable', 'off');
end

if (store)
    pause(10);
    set(handles.text_showTime, 'Visible', 'off');
    set(handles.text_showTime, 'String', '');
end

function Timer_Callback(obj, event, handles)
config_clip;
    mp = handles.MovieControl;
    mp2 = handles.MovieControl2;
    currpos1=mp.controls.currentPosition;
global lastAutoStoppedFrame;

disp 'Timers running';


if (currpos1 - lastAutoStoppedFrame >= stepDuration-0.5)
    stop(obj);
    pauseVideo(handles);
    config_labels;
    labelLen=length(mylabels);
    for i=1:labelLen
        xx=['handles.checkbox' int2str(i)];
        set(eval(xx), 'Enable', 'on');
    end
    set(handles.endLabel, 'Enable', 'on');
    set(handles.nextButton, 'Enable', 'on');
    set(handles.prevButton, 'Enable', 'on');
    stop(obj);
end
    

    %varargin


% --- Executes on button press in prevButton.
function prevButton_Callback(hObject, eventdata, handles)
% hObject    handle to prevButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mp = handles.MovieControl;
mp2 = handles.MovieControl2;

config_clip;
mp.controls.pause;
mp2.controls.pause;
currentP  = get(mp.controls,'CurrentPosition');
currentP = currentP - stepDuration;
set(mp.controls,'CurrentPosition',currentP);

currentP = currentP - startVid1 + startVid2;
set(mp2.controls,'CurrentPosition',currentP);

mp.controls.play;
mp2.controls.play;
endLabel(handles,false);

% --- Executes on button press in nextButton.
function nextButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function Others_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Others_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Others_edit as text
%        str2double(get(hObject,'String')) returns contents of Others_edit as a double


% --- Executes during object creation, after setting all properties.
function Others_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Others_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
