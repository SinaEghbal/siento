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

% Last Modified by GUIDE v2.5 08-Sep-2009 14:46:22

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

% Update handles structure
guidata(hObject, handles);

set(handles.pushbutton1, 'Enable', 'on');
set(handles.pushbutton2, 'Enable', 'off');
set(handles.pushbutton3, 'Enable', 'off');
set(handles.pushbutton4, 'Enable', 'off');
set(handles.pushbutton5, 'Enable', 'off');
set(handles.pushbutton6, 'Enable', 'on');

global fid;
fid=fopen(strcat('subjectName', '.txt'),'a');%open file

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
set(handles.pushbutton1, 'Enable', 'off');
set(handles.pushbutton2, 'Enable', 'on');
set(handles.pushbutton3, 'Enable', 'on');
set(handles.pushbutton4, 'Enable', 'on');
set(handles.pushbutton5, 'Enable', 'on');

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

fprintf(fid, '%s\t', 'Confused:');%write emotion
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

fprintf(fid, '%s\t', 'Frustrated:');%write emotion
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

fprintf(fid, '%s\t', 'Curious:');%write emotion
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

fprintf(fid, '%s\t', 'Bored:');%write emotion
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
