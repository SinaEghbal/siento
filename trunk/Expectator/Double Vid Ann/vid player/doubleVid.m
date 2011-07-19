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

% Last Modified by GUIDE v2.5 19-Oct-2009 16:39:09

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

% Choose default command line output for doubleVid
handles.output = hObject;
% set(gcf,'Color',[0 0 0]);
pos=[20 110 460 450];

MovieControl = actxcontrol('WMPlayer.OCX',pos)
set(MovieControl,'uiMode','none');
assignin('base','MovieControl',MovieControl);
set(MovieControl.settings,'autoStart',0);
handles.MovieControl = MovieControl;

pos2=[500 110 640 480];
MovieControl2 = actxcontrol('WMPlayer.OCX',pos2)
set(MovieControl2,'uiMode','none');
assignin('base','MovieControl2',MovieControl2);
set(MovieControl2.settings,'autoStart',0);
handles.MovieControl2 = MovieControl2;

set(handles.edit2,'ForegroundColor',[0 1 0]);
set(handles.edit2,'BackgroundColor',[0 0 0]);
set(handles.edit1,'ForegroundColor',[0 1 0]);
set(handles.edit1,'BackgroundColor',[0 0 0]);
set(handles.edit1,'String','0');
workdir=pwd;
handles.workdir=workdir;

[a,map]=imread('play.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton2,'CData',g);

[a,map]=imread('stop.jpg');
[r,c,d]=size(a); 
x=ceil(r/20); 
y=ceil(c/20); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton3,'CData',g);

[a,map]=imread('open_files.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton1,'CData',g);

[a,map]=imread('open_files.jpg');
[r,c,d]=size(a); 
x=ceil(r/18); 
y=ceil(c/18); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton11,'CData',g);

[a,map]=imread('pause.jpg');
[r,c,d]=size(a); 
x=ceil(r/20); 
y=ceil(c/20); 
g=a(1:x:end,1:y:end,:);
g(g==255)=0.8*255;
set(handles.pushbutton4,'CData',g);

%load labels from config
config_labels;
labelLen=length(mylabels)
%create user defined labels
    for i=1:labelLen
        xx=['pushbutton' int2str(i+31)]
        switch xx
            case 'pushbutton32'
                set(handles.pushbutton32, 'String', mylabels(i));
            case 'pushbutton33'
                set(handles.pushbutton33, 'String', mylabels(i));
            case 'pushbutton34'
                set(handles.pushbutton34, 'String', mylabels(i));
            case 'pushbutton35'
                set(handles.pushbutton35, 'String', mylabels(i));
            case 'pushbutton36'
                set(handles.pushbutton36, 'String', mylabels(i));
            case 'pushbutton37'
                set(handles.pushbutton37, 'String', mylabels(i));
            case 'pushbutton38'
                set(handles.pushbutton38, 'String', mylabels(i));
            case 'pushbutton39'
                set(handles.pushbutton39, 'String', mylabels(i));
            case 'pushbutton40'
                set(handles.pushbutton40, 'String', mylabels(i));
            case 'pushbutton41'
                set(handles.pushbutton41, 'String', mylabels(i));
            case 'pushbutton42'
                set(handles.pushbutton42, 'String', mylabels(i));
            case 'pushbutton43'
                set(handles.pushbutton43, 'String', mylabels(i));
        end
    end

set(handles.pushbutton31, 'Enable', 'on');
set(handles.pushbutton32, 'Enable', 'off');
set(handles.pushbutton33, 'Enable', 'off');
set(handles.pushbutton34, 'Enable', 'off');
set(handles.pushbutton35, 'Enable', 'off');
set(handles.pushbutton36, 'Enable', 'off');
set(handles.pushbutton37, 'Enable', 'off');
set(handles.pushbutton38, 'Enable', 'off');
set(handles.pushbutton39, 'Enable', 'off');
set(handles.pushbutton40, 'Enable', 'off');
set(handles.pushbutton41, 'Enable', 'off');
set(handles.pushbutton42, 'Enable', 'off');
set(handles.pushbutton43, 'Enable', 'off');

% global fid;
% fid=fopen(strcat('video', '.txt'),'a');%open file
% set(handles.figure1,'CloseRequestFcn',@closeGUI);%for closing function
clc
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes act_ive_gui_new wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = doubleVid_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mp = handles.MovieControl;
mp.controls.play

mp2 = handles.MovieControl2;
mp2.controls.play

pause(1);
r=get(mp.currentMedia,'duration')
set(handles.slider3,'max',r)

j=get(handles.edit2,'String'); 
%     set(mp.settings,'playCount',str2double(j));

currpos=mp.controls.currentPosition;        
    pause(1);
    r=get(mp.currentMedia,'duration');
    set(handles.slider3,'max',r)     
    for i=currpos:r        
        j=get(handles.edit2,'String'); 
%         set(mp.settings,'playCount',str2double(j));
        currpos1=mp.controls.currentPosition; 
        getCurrFrame(currpos1)
%         index_selected1 = get(handles.listbox1,'Value');
        pause(1);
        r=get(mp.currentMedia,'duration');
        remaint=r-currpos1;    
        set(handles.edit2,'String',currpos1);           
        j=0;
        if remaint <=0 || j==r
            break;
        end        
    end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton33.
function pushbutton11_Callback(hObject, eventdata, handles)
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
% set(handles.listbox1,'UserData',dir_path);


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
mp = handles.MovieControl;
mp2 = handles.MovieControl2;
%o=get(mp.currentMedia,'duration');
%set(hObject,'Max',o)
j=get(hObject,'Value');
set(mp.controls,'CurrentPosition',j);
set(mp2.controls,'CurrentPosition',j);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mp = handles.MovieControl;
mp2 = handles.MovieControl2;
stopval=get(handles.pushbutton3,'Value')
if stopval==1
    mp.controls.stop
    mp2.controls.stop
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mp = handles.MovieControl;
mp2 = handles.MovieControl2;
mp.controls.pause
mp2.controls.pause


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
