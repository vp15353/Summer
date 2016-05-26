function varargout = TableController(varargin)
% TABLECONTROLLER MATLAB code for TableController.fig
%      TABLECONTROLLER, by itself, creates a new TABLECONTROLLER or raises the existing
%      singleton*.
%
%      H = TABLECONTROLLER returns the handle to a new TABLECONTROLLER or the handle to
%      the existing singleton*.
%
%      TABLECONTROLLER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABLECONTROLLER.M with the given input arguments.
%
%      TABLECONTROLLER('Property','Value',...) creates a new TABLECONTROLLER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TableController_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TableController_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TableController

% Last Modified by GUIDE v2.5 23-May-2016 21:37:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TableController_OpeningFcn, ...
                   'gui_OutputFcn',  @TableController_OutputFcn, ...
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


% --- Executes just before TableController is made visible.
function TableController_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TableController (see VARARGIN)

% Choose default command line output for TableController
handles.output = hObject;

handles.ValuesOK=0;
 set(handles.bt_acc,'Enable','off')
 set(handles.bt_deac,'Enable','off')
 set(handles.bt_startlib,'Enable','off')
 set(handles.bt_stoplib,'Enable','off')
 handles.rpm2v=0.25;
 
handles.ljasm = NET.addAssembly('LJUDDotNet'); %Make the UD .NET assembly visible in MATLAB
handles.ljudObj = LabJack.LabJackUD.LJUD;
[handles.ljerror, handles.ljhandle] = handles.ljudObj.OpenLabJack(LabJack.LabJackUD.DEVICE.U3, LabJack.LabJackUD.CONNECTION.USB, '0', true, 0);
handles.ljudObj.ePut(handles.ljhandle, LabJack.LabJackUD.IO.PUT_CONFIG, LabJack.LabJackUD.CHANNEL.TDAC_SCL_PIN_NUM, 4, 0)



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TableController wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TableController_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bt_deac.
function bt_deac_Callback(hObject, eventdata, handles)
% hObject    handle to bt_deac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  set(handles.bt_startlib,'Enable','off')
    set(handles.bt_deac,'Enable','off')
  drawnow;
vpl_DecTable(handles)
  

  set(handles.bt_acc,'Enable','on')
  set(handles.bt_plot,'Enable','on')

set(handles.ed_meanrpm, 'Enable', 'on')
set(handles.ed_acctime, 'Enable', 'on')
set(handles.ed_dectime, 'Enable', 'on')
set(handles.ed_libamp, 'Enable', 'on')
set(handles.ed_libper, 'Enable', 'on')
set(handles.ed_updaterate, 'Enable', 'on')


    


% --- Executes on button press in bt_acc.
function bt_acc_Callback(hObject, eventdata, handles)
% hObject    handle to bt_acc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.ValuesOK==1 
set(handles.bt_acc,'Enable','off')
set(handles.bt_plot,'Enable','off')


set(handles.ed_meanrpm, 'Enable', 'off')
set(handles.ed_acctime, 'Enable', 'off')
set(handles.ed_dectime, 'Enable', 'off')
set(handles.ed_libamp, 'Enable', 'off')
set(handles.ed_libper, 'Enable', 'off')
set(handles.ed_updaterate, 'Enable', 'off')
drawnow;

    vpl_AccTable(handles)
    set(handles.bt_startlib,'Enable','on')
set(handles.bt_deac,'Enable','on')
end





% --- Executes on button press in bt_stoplib.
function bt_stoplib_Callback(hObject, eventdata, handles)
% hObject    handle to bt_stoplib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.bt_stoplib,'Enable','off')
stop(handles.t)
delete(handles.t)
set(handles.bt_startlib,'Enable','on')

      set(handles.bt_deac,'Enable','on')
      




% --- Executes on button press in bt_startlib.
function bt_startlib_Callback(hObject, eventdata, handles)
% hObject    handle to bt_startlib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  set(handles.bt_startlib,'Enable','off')
  set(handles.bt_deac,'Enable','off')
drawnow

handles.t=timer();
handles.t.StartDelay = 0;
handles.t.Period=handles.UpdateRate;
handles.t.ExecutionMode='fixedRate';
handles.t.TasksToExecute=inf;
handles.t.StartFcn = @(x,y)tic;
handles.t.StopFcn = {@vpl_StopLibration,handles};
handles.t.TimerFcn = {@vpl_StartLibration,handles};
guidata(hObject,handles)
disp('Starting Libration')
start(handles.t)
set(handles.bt_stoplib,'Enable','on')

    



function ed_acctime_Callback(hObject, eventdata, handles)
% hObject    handle to ed_acctime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_acctime as text
%        str2double(get(hObject,'String')) returns contents of ed_acctime as a double
    set(handles.bt_acc,'Enable','off')
    handles.ValuesOK=0;



% --- Executes during object creation, after setting all properties.
function ed_acctime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_acctime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_dectime_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dectime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dectime as text
%        str2double(get(hObject,'String')) returns contents of ed_dectime as a double
    set(handles.bt_acc,'Enable','off')
handles.ValuesOK=0;

% --- Executes during object creation, after setting all properties.
function ed_dectime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dectime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_meanrpm_Callback(hObject, eventdata, handles)
% hObject    handle to ed_meanrpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_meanrpm as text
%        str2double(get(hObject,'String')) returns contents of ed_meanrpm as a double
    set(handles.bt_acc,'Enable','off')
handles.ValuesOK=0;

% --- Executes during object creation, after setting all properties.
function ed_meanrpm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_meanrpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_libamp_Callback(hObject, eventdata, handles)
% hObject    handle to ed_libamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_libamp as text
%        str2double(get(hObject,'String')) returns contents of ed_libamp as a double
    set(handles.bt_acc,'Enable','off')
handles.ValuesOK=0;

% --- Executes during object creation, after setting all properties.
function ed_libamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_libamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_libper_Callback(hObject, eventdata, handles)
% hObject    handle to ed_meanrpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_meanrpm as text
%        str2double(get(hObject,'String')) returns contents of ed_meanrpm as a double
    set(handles.bt_acc,'Enable','off')
handles.ValuesOK=0;

% --- Executes during object creation, after setting all properties.
function ed_libper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_meanrpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_plot.
function bt_plot_Callback(hObject, eventdata, handles)
% hObject    handle to bt_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

handles=vpl_ValuesValidation(handles);
guidata(hObject,handles)

if handles.ValuesOK==1
    vpl_PlotPreview(handles)
    set(handles.bt_acc,'Enable','on')
    
end




function ed_updaterate_Callback(hObject, eventdata, handles)
% hObject    handle to ed_updaterate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_updaterate as text
%        str2double(get(hObject,'String')) returns contents of ed_updaterate as a double
    set(handles.bt_acc,'Enable','off')
handles.ValuesOK=0;

% --- Executes during object creation, after setting all properties.
function ed_updaterate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_updaterate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
