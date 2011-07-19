function varargout = siento_main(varargin)
% SIENTO_MAIN M-file for siento_main.fig
%      SIENTO_MAIN, by itself, creates a new SIENTO_MAIN or raises the existing
%      singleton*.
%
%      H = SIENTO_MAIN returns the handle to a new SIENTO_MAIN or the handle to
%      the existing singleton*.
%
%      SIENTO_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIENTO_MAIN.M with the given input arguments.
%
%      SIENTO_MAIN('Property','Value',...) creates a new SIENTO_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before siento_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to siento_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help siento_main

% Last Modified by GUIDE v2.5 11-Sep-2009 14:17:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @siento_main_OpeningFcn, ...
                   'gui_OutputFcn',  @siento_main_OutputFcn, ...
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


% --- Executes just before siento_main is made visible.
function siento_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to siento_main (see VARARGIN)

% Choose default command line output for siento_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes siento_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = siento_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function fileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to fileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileEdit as text
%        str2double(get(hObject,'String')) returns contents of fileEdit as a double


% --- Executes during object creation, after setting all properties.
function fileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in file_button.
function file_button_Callback(hObject, eventdata, handles)
% hObject    handle to file_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,pname, fileindex]= UIGETFILE('*.xml*');

if fileindex > 0 
    set(handles.fileEdit, 'String', pname);
    set(handles.filenameEdit, 'String', fname);
elseif fileindex == 0
    set(handles.fileEdit, 'String', 'File Path');
    set(handles.filenameEdit, 'String', 'File Name');
end
    



function filenameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to filenameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filenameEdit as text
%        str2double(get(hObject,'String')) returns contents of filenameEdit as a double


% --- Executes during object creation, after setting all properties.
function filenameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in annotation_button.
function annotation_button_Callback(hObject, eventdata, handles)
% hObject    handle to annotation_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
config_play;

% --- Executes on button press in visualization_button.
function visualization_button_Callback(hObject, eventdata, handles)
% hObject    handle to visualization_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in analysis_button.
function analysis_button_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
