function varargout = FeatEx(varargin)
% FEATEX M-file for FeatEx.fig
%      FEATEX, by itself, creates a new FEATEX or raises the existing
%      singleton*.
%
%      H = FEATEX returns the handle to a new FEATEX or the handle to
%      the existing singleton*.
%
%      FEATEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEATEX.M with the given input arguments.
%
%      FEATEX('Property','Value',...) creates a new FEATEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FeatEx_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FeatEx_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FeatEx

% Last Modified by GUIDE v2.5 05-Nov-2009 12:00:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FeatEx_OpeningFcn, ...
                   'gui_OutputFcn',  @FeatEx_OutputFcn, ...
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


% --- Executes just before FeatEx is made visible.
function FeatEx_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FeatEx (see VARARGIN)


% Choose default command line output for FeatEx
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FeatEx wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FeatEx_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Physio.
function Physio_Callback(hObject, eventdata, handles)
% hObject    handle to Physio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Physio


% --- Executes on button press in Vedio.
function Vedio_Callback(hObject, eventdata, handles)
% hObject    handle to Vedio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Vedio


% --- Executes on button press in Audio.
function Audio_Callback(hObject, eventdata, handles)
% hObject    handle to Audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Audio


% --- Executes on button press in Extract_Features.
function Extract_Features_Callback(hObject, eventdata, handles)
% hObject    handle to Extract_Features (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if (get(handles.Physio,'Value') == get(handles.Physio,'Max'))
	% Checkbox is checked-take approriate action
    [mergedfeatmat mergedfeatnames, labels] = physio();
    assignin('base','dataset',mergedfeatmat);
    assignin('base','headerow',mergedfeatnames);
    assignin('base','labels',labels);
           
else
	% Checkbox is not checked-take approriate action
    display ('physio not selected')
end


% --- Executes on button press in physiofus.
function physiofus_Callback(hObject, eventdata, handles)
% hObject    handle to physiofus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of physiofus


% --- Executes on button press in Vediofus.
function Vediofus_Callback(hObject, eventdata, handles)
% hObject    handle to Vediofus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Vediofus


% --- Executes on button press in Audiofus.
function Audiofus_Callback(hObject, eventdata, handles)
% hObject    handle to Audiofus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Audiofus


% --- Executes on button press in Fuse_Features.
function Fuse_Features_Callback(hObject, eventdata, handles)
% hObject    handle to Fuse_Features (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in FeatExFinish.
function FeatExFinish_Callback(hObject, eventdata, handles)
% hObject    handle to FeatExFinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FeatClassification;
% close();
