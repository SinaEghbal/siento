function varargout = sam(varargin)
% SAM M-file for sam.fig
%      SAM, by itself, creates a new SAM or raises the existing
%      singleton*.
%
%      H = SAM returns the handle to a new SAM or the handle to
%      the existing singleton*.
%
%      SAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAM.M with the given input arguments.
%
%      SAM('Property','Value',...) creates a new SAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sam

% Last Modified by GUIDE v2.5 04-May-2009 14:45:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sam_OpeningFcn, ...
                   'gui_OutputFcn',  @sam_OutputFcn, ...
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
% 
% --- Executes just before sam is made visible.
function sam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sam (see VARARGIN)

% Choose default command line output for sam
handles.output = hObject;
%set(handles.sam,'Valence',@valenceSelect_buttongroup);

set(handles.uipanel1,'SelectionChangeFcn',@valenceSelect_buttongroup);
set(handles.uipanel2,'SelectionChangeFcn',@arousalSelect_buttongroup);
% Update handles structure
guidata(hObject, handles);

axes(handles.v1);
imshow('sam_v1.jpg');
axes(handles.v2);
imshow('sam_v2.jpg');
axes(handles.v3);
imshow('sam_v3.jpg');
axes(handles.v4);
imshow('sam_v4.jpg');
axes(handles.v5);
imshow('sam_v5.jpg');
axes(handles.a1);
imshow('sam_a1.jpg');
axes(handles.a2);
imshow('sam_a2.jpg');
axes(handles.a3);
imshow('sam_a3.jpg');
axes(handles.a4);
imshow('sam_a4.jpg');
axes(handles.a5);
imshow('sam_a5.jpg');

% UIWAIT makes sam wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output %sazzad commented on 2pm 29April


% --- Executes on button press in save_sa.
function save_sa_Callback(hObject, eventdata, handles)
global fileNameRec;
% hObject    handle to save_sa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 config;%load the configurations
 
 mkdir(fullfile(experimentPath,'SAM'))%create the dir for SAM
 SAMPath = fullfile(experimentPath,'SAM');%SAM dir path
 config;
 global v;
 global a;
 t=clock;%get current time & date
 
 if length(int2str(t(5)))==1
    tStamp=strcat(int2str(t(4)), ':0', int2str(t(5)));%use only hh:mm 
 else
    tStamp=strcat(int2str(t(4)), ':', int2str(t(5)));%use only hh:mm 
 end

 v = get(handles.valence_text,'String');%get valence text value
 v=str2double(v);
 
 a = get(handles.arousal_text,'String');%get arousal text value
 a=str2double(a);

 f1=char(fileNameRec);%image filename

 f=sscanf(f1,'%c',11); %extract 1st 11 char of filename; for file alignment
 f=strtrim(f);
 
 fid=fopen(fullfile(SAMPath,'exp.txt'),'a');%open file
 fprintf(fid, '%s\t\t', f);%write image filename
 fprintf(fid, '%1d\t\t', v);%write valence rate
 fprintf(fid, '%1d\t\t', a);%write arousal rate
 fprintf(fid, '%s\n', tStamp);%write timestamp
 fclose(fid);%close file

 global v;
 global a;
 %edit by Cameron on 29/4/09
 %save(fullfile(SAMPath,'rate.mat'),'v','a')
 
 set(handles.save_sa, 'Visible', 'off');
 set(handles.valence_text, 'String', 'Thank');
 set(handles.valence_text, 'Visible', 'on');
 set(handles.arousal_text, 'String', 'You');
 set(handles.arousal_text, 'Visible', 'on');
 
 pause(1);
 delete(gcf);


function valenceSelect_buttongroup(hObject, eventdata)
 
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'valence1'
      %execute this code when valence1_radiobutton is selected
      set(handles.valence_text, 'Visible', 'off'); %store the value in text
      set(handles.valence_text,'String',1);%text invisible

    case 'valence2'
      %execute this code when valence2_radiobutton is selected
      set(handles.valence_text, 'Visible', 'off');%store the value in text
      set(handles.valence_text,'String',2);%text invisible

     case 'valence3'
      %execute this code when valence3_radiobutton is selected  
      set(handles.valence_text, 'Visible', 'off');%store the value in text
      set(handles.valence_text,'String',3);%text invisible
       
    case 'valence4'
      %execute this code when valence4_radiobutton is selected  
      set(handles.valence_text, 'Visible', 'off');%store the value in text
      set(handles.valence_text,'String',4);%text invisible
        
    case 'valence5'
      %execute this code when valence5_radiobutton is selected 
      set(handles.valence_text, 'Visible', 'off');%store the value in text
      set(handles.valence_text,'String',5);%text invisible
        
    otherwise
       % Code for when there is no match.
 
end
%updates the handles structure
guidata(hObject, handles);

function arousalSelect_buttongroup(hObject, eventdata)
 
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'arousal1'
      %execute this code when arousal1_radiobutton is selected
      set(handles.arousal_text, 'Visible', 'off'); %store the value in text
      set(handles.arousal_text,'String',1);%text invisible

    case 'arousal2'
      %execute this code when arousal2_radiobutton is selected
      set(handles.valence_text, 'Visible', 'off');%store the value in text
      set(handles.arousal_text,'String',2);%text invisible

     case 'arousal3'
      %execute this code when arousal3_radiobutton is selected  
      set(handles.arousal_text, 'Visible', 'off');%store the value in text
      set(handles.arousal_text,'String',3);%text invisible
       
    case 'arousal4'
      %execute this code when arousal4_radiobutton is selected  
      set(handles.arousal_text, 'Visible', 'off');%store the value in text
      set(handles.arousal_text,'String',4);%text invisible
        
    case 'arousal5'
      %execute this code when arousal5_radiobutton is selected 
      set(handles.arousal_text, 'Visible', 'off');%store the value in text
      set(handles.arousal_text,'String',5);%text invisible
        
    otherwise
       % Code for when there is no match.
 
end
%updates the handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function valence_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valence_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function arousal_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arousal_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


