%%本例演示用GUIDATA传递参数
%                  -------2016.6.30 陆伟



function varargout = guidedemo1(varargin)
% GUIDEDEMO1 M-file for guidedemo1.fig
%      GUIDEDEMO1, by itself, creates a new GUIDEDEMO1 or raises the existing
%      singleton*.
%
%      H = GUIDEDEMO1 returns the handle to a new GUIDEDEMO1 or the handle to
%      the existing singleton*.
%
%      GUIDEDEMO1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDEDEMO1.M with the given input arguments.
%
%      GUIDEDEMO1('Property','Value',...) creates a new GUIDEDEMO1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guidedemo1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guidedemo1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guidedemo1

% Last Modified by GUIDE v2.5 26-Jun-2013 20:58:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guidedemo1_OpeningFcn, ...
                   'gui_OutputFcn',  @guidedemo1_OutputFcn, ...
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


% --- Executes just before guidedemo1 is made visible.
function guidedemo1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guidedemo1 (see VARARGIN)

% Choose default command line output for guidedemo1
handles.output = hObject;

handles.f1 = 50;
handles.f2 = 200;
handles.t = [0:0.001:0.25];

% Update handles structure
guidata(hObject, handles);

% % UIWAIT makes guidedemo1 wait for user response (see UIRESUME)
% % uiwait(handles.figure1);
% f1 = str2double(get(handles.f1_input,'String'));
% f2 = str2double(get(handles.f2_input,'String'));
% t = eval(get(handles.t_input,'String'));
% 
% % Calculate data
% x = sin(2*pi*f1*t) + sin(2*pi*f2*t);
% y = fft(x,512);
% m = y.*conj(y)/512;
% f = 1000*(0:256)/512;
% 
% % Create frequency plot
% axes(handles.frequency_axes)
% plot(f,m(1:257))
% set(handles.frequency_axes,'XMinorTick','on')
% grid on
% 
% % Create time plot
% axes(handles.time_axes)
% plot(t,x)
% set(handles.time_axes,'XMinorTick','on')
% grid on

% --- Outputs from this function are returned to the command line.
function varargout = guidedemo1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function f1_input_Callback(hObject, eventdata, handles)
% hObject    handle to f1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f1_input as text
%        str2double(get(hObject,'String')) returns contents of f1_input as a double
handles.f1 = str2num(get(hObject,'string'));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function f1_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f2_input_Callback(hObject, eventdata, handles)
% hObject    handle to f2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f2_input as text
%        str2double(get(hObject,'String')) returns contents of f2_input as a double
handles.f2 = str2num(get(hObject,'string'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function f2_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function t_input_Callback(hObject, eventdata, handles)
% hObject    handle to t_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_input as text
%        str2double(get(hObject,'String')) returns contents of t_input as a double
handles.t = eval(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function t_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get user input from GUI
% f1 = str2double(get(handles.f1_input,'String'));
% f2 = str2double(get(handles.f2_input,'String'));
% t = eval(get(handles.t_input,'String'));

f1 = handles.f1;
f2 = handles.f2;
t = handles.t;

% Calculate data
x = sin(2*pi*f1*t) + sin(2*pi*f2*t);
y = fft(x,512);
m = y.*conj(y)/512;
f = 1000*(0:256)/512;

% Create frequency plot
axes(handles.frequency_axes)
plot(f,m(1:257))
set(handles.frequency_axes,'XMinorTick','on')
grid on

% Create time plot
axes(handles.time_axes)
plot(t,x)
set(handles.time_axes,'XMinorTick','on')
grid on


