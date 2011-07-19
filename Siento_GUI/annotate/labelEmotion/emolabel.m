function varargout = emolabel(varargin)
% EMOLABEL M-file for emolabel.fig
%      EMOLABEL, by itself, creates a new EMOLABEL or raises the existing
%      singleton*.
%
%      H = EMOLABEL returns the handle to a new EMOLABEL or the handle to
%      the existing singleton*.
%
%      EMOLABEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMOLABEL.M with the given input arguments.
%
%      EMOLABEL('Property','Value',...) creates a new EMOLABEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before emolabel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to emolabel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help emolabel

% Last Modified by GUIDE v2.5 16-Oct-2009 10:22:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @emolabel_OpeningFcn, ...
                   'gui_OutputFcn',  @emolabel_OutputFcn, ...
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


% --- Executes just before emolabel is made visible.
function emolabel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to emolabel (see VARARGIN)

global sFrame;%start frame
global eFrame;%end frame

sFrame=0;
eFrame=0;

% Choose default command line output for emolabel
handles.output = hObject;
clc
% Update handles structure
guidata(hObject, handles);

%load labels from config
config_labels;
labelLen=length(mylabels)
%create user defined labels


    for i=1:labelLen
        xx=['pushbutton' int2str(i+1)]

        switch xx
            case 'pushbutton2'
                set(handles.pushbutton2, 'String', mylabels(i));
            case 'pushbutton3'
                set(handles.pushbutton3, 'String', mylabels(i));
            case 'pushbutton4'
                set(handles.pushbutton4, 'String', mylabels(i));
            case 'pushbutton5'
                set(handles.pushbutton5, 'String', mylabels(i));
            case 'pushbutton6'
                set(handles.pushbutton6, 'String', mylabels(i));
            case 'pushbutton7'
                set(handles.pushbutton7, 'String', mylabels(i));
            case 'pushbutton8'
                set(handles.pushbutton8, 'String', mylabels(i));
            case 'pushbutton9'
                set(handles.pushbutton9, 'String', mylabels(i));
            case 'pushbutton10'
                set(handles.pushbutton10, 'String', mylabels(i));
            case 'pushbutton11'
                set(handles.pushbutton11, 'String', mylabels(i));
            case 'pushbutton12'
                set(handles.pushbutton12, 'String', mylabels(i));
            case 'pushbutton13'
                set(handles.pushbutton13, 'String', mylabels(i));
        end
    end

set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global fid;
fid=fopen(strcat('video', '.txt'),'a');%open file

set(handles.figure1,'CloseRequestFcn',@closeGUI);%for closing function

% UIWAIT makes emolabel wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = emolabel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global frameNum;
config_labels;
labelLen=length(mylabels)
%create user defined labels

    for i=1:labelLen
        xx=['pushbutton' int2str(i+1)]

        switch xx
            case 'pushbutton2'
                set(handles.pushbutton2, 'Enable', 'on');
            case 'pushbutton3'
                set(handles.pushbutton3, 'Enable', 'on');
            case 'pushbutton4'
                set(handles.pushbutton4, 'Enable', 'on');
            case 'pushbutton5'
                set(handles.pushbutton5, 'Enable', 'on');
            case 'pushbutton6'
                set(handles.pushbutton6, 'Enable', 'on');
            case 'pushbutton7'
                set(handles.pushbutton7, 'Enable', 'on');
            case 'pushbutton8'
                set(handles.pushbutton8, 'Enable', 'on');
            case 'pushbutton9'
                set(handles.pushbutton9, 'Enable', 'on');
            case 'pushbutton10'
                set(handles.pushbutton10, 'Enable', 'on');
            case 'pushbutton11'
                set(handles.pushbutton11, 'Enable', 'on');
            case 'pushbutton12'
                set(handles.pushbutton12, 'Enable', 'on');
            case 'pushbutton13'
                set(handles.pushbutton13, 'Enable', 'on');
        end
    end

global frameNum;
global sFrame;%start frame
sFrame=frameNum;%start frame

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton2,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotionn
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton3,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton4,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton7.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton5,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');


function closeGUI(src,evnt)
%src is the handle of the object generating the callback (the source of the event)
%evnt is the The event data structure (can be empty for some callbacks)
selection = questdlg('Do you want to close the EmoLabel?',...
                     'Close Request Function',...
                     'Yes','No','Yes');
switch selection,
   case 'Yes',
    delete(gcf)
    global fid;
    fclose(fid);%close file
   case 'No'
     return
end


% % --- Executes on button press in video_button.
% function video_button_Callback(hObject, eventdata, handles)
% % hObject    handle to video_button (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global mode;
% mode=1;
% 
% set(handles.stimulus_button,'Enable','off');
% vidObj=mmreader('DELTA.MPG');
% vidFrames=read(vidObj);
% m=myplay(vidFrames);
% 
% global fid;
% fid=fopen(strcat('video', '.txt'),'a');%open file

% --- Executes on button press in stimulus_button.
function stimulus_button_Callback(hObject, eventdata, handles)
% hObject    handle to stimulus_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mode;
mode=2;

set(handles.video_button,'Enable','off');
imageviewer;

global fid;
fid=fopen(strcat('stimulus', '.txt'),'a');%open file


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton9,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton6,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton7,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton5,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton13,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton10,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton11,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'off');
set(handles.pushbutton7, 'Enable', 'off');
set(handles.pushbutton8, 'Enable', 'off');
set(handles.pushbutton9, 'Enable', 'off');
set(handles.pushbutton10, 'Enable', 'off');
set(handles.pushbutton11, 'Enable', 'off');
set(handles.pushbutton12, 'Enable', 'off');
set(handles.pushbutton13, 'Enable', 'off');

global frameNum;
global sFrame
global eFrame;%end frame
global fid;
eFrame=frameNum;%end frame with emotion

%display the captured frames for this emotion
set(handles.text2, 'Visible', 'on');
set(handles.text2, 'String', ['Captured Frames:', int2str(sFrame),'-',int2str(eFrame)]);
pause(1.5);
set(handles.text2, 'Visible', 'off');
set(handles.text2, 'String', '');

label=get(handles.pushbutton12,'String');
label=char(label)
fprintf(fid, '%s\t', label);%write emotion
fprintf(fid, '%s\t', int2str(sFrame));%write start frame
fprintf(fid, '%s', int2str(eFrame));%write end frame
fprintf(fid, '\n');


% --- Executes on button press in pushbutton_rst.
function pushbutton_rst_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
config_labels;
labelLen=length(mylabels)
%create user defined labels

    for i=1:labelLen
        xx=['pushbutton' int2str(i+1)]

        switch xx
            case 'pushbutton2'
                set(handles.pushbutton2, 'Enable', 'off');
            case 'pushbutton3'
                set(handles.pushbutton3, 'Enable', 'off');
            case 'pushbutton4'
                set(handles.pushbutton4, 'Enable', 'off');
            case 'pushbutton5'
                set(handles.pushbutton5, 'Enable', 'off');
            case 'pushbutton6'
                set(handles.pushbutton6, 'Enable', 'off');
            case 'pushbutton7'
                set(handles.pushbutton7, 'Enable', 'off');
            case 'pushbutton8'
                set(handles.pushbutton8, 'Enable', 'off');
            case 'pushbutton9'
                set(handles.pushbutton9, 'Enable', 'off');
            case 'pushbutton10'
                set(handles.pushbutton10, 'Enable', 'off');
            case 'pushbutton11'
                set(handles.pushbutton11, 'Enable', 'off');
            case 'pushbutton12'
                set(handles.pushbutton12, 'Enable', 'off');
            case 'pushbutton13'
                set(handles.pushbutton13, 'Enable', 'off');
        end
    end
    
    set(handles.pushbutton1, 'Enable', 'on');
