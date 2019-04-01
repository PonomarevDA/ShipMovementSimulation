function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 30-Mar-2019 00:21:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Init global variables
global InitialValueX0 InitialValueV0 t_0 t_end
InitialValueX0 = 0; 
InitialValueV0 = 0; 
t_0 = 0; 
t_end = 100;

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenuChoice.
function popupmenuChoice_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuChoice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuChoice

global Model

choice = get(hObject, 'Value');
switch choice
    case 1
        disp('The user has not choose anything')
        Model = createModelEmpty();
        setModelInfoInGui(handles, Model)
        setAllInitialDataOff(handles);
    case 2 
        disp('Table 5.1 - 11 variant')
        Model = createModelForSurfaceShipVariant11();
        disp(Model)
        setModelInfoInGui(handles, Model)
        setAllInitialDataOff(handles);
    case 3
        disp('Table 5.2 - 8 variant')
        Model = createModelForSurfaceBoatVariant8();
        disp(Model)
        setModelInfoInGui(handles, Model)
        setAllInitialDataOff(handles);
    case 4
        disp('Table 5.3 - 27 variant')
        Model = createModelForSubmarineShipVariant27();
        disp(Model)
        setModelInfoInGui(handles, Model)
        setAllInitialDataOff(handles);
    case 5
        disp('Test model - surface ship')
        Model = createModelForSurfaceShipTest();
        disp(Model)
        setModelInfoInGui(handles, Model)
        setAllInitialDataOff(handles);
	case 6
        disp('Test model - submarine ship')
        Model = createModelForSubmarineShipTest();
        disp(Model)
        setModelInfoInGui(handles, Model)
        setAllInitialDataOff(handles);
    case 7
        disp('Individual model')
        setAllInitialDataOn(handles);
    otherwise
        disp('Unknown choice')
end
popupmenuType_Callback(handles.popupmenuType, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function popupmenuChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSpeedV2_Callback(hObject, eventdata, handles)
% hObject    handle to editSpeedV2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSpeedV2 as text
%        str2double(get(hObject,'String')) returns contents of editSpeedV2 as a double
global Model
value = str2double(get(hObject, "String"));
if isnan(value)
    setErrorMark(hObject)
else
    clearErrorMark(hObject)
    Model.V2 = value;
end


% --- Executes during object creation, after setting all properties.
function editSpeedV2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSpeedV2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSpeedV1_Callback(hObject, eventdata, handles)
% hObject    handle to editSpeedV1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSpeedV1 as text
%        str2double(get(hObject,'String')) returns contents of editSpeedV1 as a double
global Model
value = str2double(get(hObject, "String"));
if isnan(value)
    setErrorMark(hObject)
else
    clearErrorMark(hObject)
    Model.V1 = value;
end


% --- Executes during object creation, after setting all properties.
function editSpeedV1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSpeedV1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSpeedVk_Callback(hObject, eventdata, handles)
% hObject    handle to editSpeedVk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSpeedVk as text
%        str2double(get(hObject,'String')) returns contents of editSpeedVk as a double
global Model
value = str2double(get(hObject, "String"));
if isnan(value)
    setErrorMark(hObject)
else
    clearErrorMark(hObject)
    Model.Vk = value;
end

% --- Executes during object creation, after setting all properties.
function editSpeedVk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSpeedVk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to editSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSpeed as text
%        str2double(get(hObject,'String')) returns contents of editSpeed as a double
global Model
value = str2double(get(hObject, "String"));
if isnan(value)
    setErrorMark(hObject)
else
    clearErrorMark(hObject)
    Model.V = value;
end


% --- Executes during object creation, after setting all properties.
function editSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPower_Callback(hObject, eventdata, handles)
% hObject    handle to editPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPower as text
%        str2double(get(hObject,'String')) returns contents of editPower as a double
global Model
value = str2double(get(hObject, "String"));
if isnan(value)
    setErrorMark(hObject)
else
    clearErrorMark(hObject)
    Model.N = value;
end


% --- Executes during object creation, after setting all properties.
function editPower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDisplacement_Callback(hObject, eventdata, handles)
% hObject    handle to editDisplacement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDisplacement as text
%        str2double(get(hObject,'String')) returns contents of editDisplacement as a double
global Model
value = str2double(get(hObject, "String"));
if isnan(value)
    setErrorMark(hObject)
else
    clearErrorMark(hObject)
    Model.W = value;
end


% --- Executes during object creation, after setting all properties.
function editDisplacement_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDisplacement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editName_Callback(hObject, eventdata, handles)
% hObject    handle to editName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editName as text
%        str2double(get(hObject,'String')) returns contents of editName as a double


% --- Executes during object creation, after setting all properties.
function editName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editName (see GCBO)
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



function editVariant_Callback(hObject, eventdata, handles)
% hObject    handle to editVariant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVariant as text
%        str2double(get(hObject,'String')) returns contents of editVariant as a double
global Model
value = str2double(get(hObject, "String"));
if isnan(value)
    setErrorMark(hObject)
else
    clearErrorMark(hObject)
    Model.Variant = value;
end




% --- Executes during object creation, after setting all properties.
function editVariant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVariant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editGroup_Callback(hObject, eventdata, handles)
% hObject    handle to editGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGroup as text
%        str2double(get(hObject,'String')) returns contents of editGroup as a double


% --- Executes during object creation, after setting all properties.
function editGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonStartSimulation.
function pushbuttonStartSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStartSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Model
if updateAllErrorMarks(handles) == false
    modelType = get(handles.popupmenuType, "Value");
    integrationMethod = get(handles.popupmenuIntegrationMethod, "Value");
    switch modelType
        case 2
            if integrationMethod == 1
                [t, x, p, v] = solveContinuousModelForSurfaceTransport(Model);
            else
                [t, x, p, v] = solveDifferenceModelForSurfaceTransport(Model);
            end
        case 3
             if integrationMethod == 1
                [t, x, p, v] = solveContinuousModelForSurfaceTransport(Model);
            else
                [t, x, p, v] = solveDifferenceModelForSurfaceTransport(Model);
            end
        case 4
            if integrationMethod == 1
                [t, x, p, v] = solveContinuousModelForSubmarineTransport(Model);
            else
                [t, x, p, v] = solveDifferenceModelForSubmarineTransport(Model);
            end
        otherwise
            t = 0; x = 0; p = 0; v = 0;
    end
    
    [x, p, v] = normalize(x, p, v);

    plot(t, x, 'b', ...
         t, p, 'r', ...
         t, v, 'g')
    grid on;
end


% --- Executes on selection change in popupmenuType.
function popupmenuType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuType
if get(handles.popupmenuChoice, 'Value') == 7
    if get(handles.popupmenuType, 'Value') == 4
        setAllInitialDataOn(handles)
        set(handles.editSpeed,   'Enable', "Off");
    elseif get(handles.popupmenuType, 'Value') == 1
        setAllInitialDataOff(handles)
        set(handles.popupmenuType, 'Enable', "On");
    else
        setAllInitialDataOn(handles)
        set(handles.editSpeedVk, 'Enable', "Off");
        set(handles.editSpeedV1, 'Enable', "Off");
        set(handles.editSpeedV2, 'Enable', "Off");
    end
end


% --- Executes during object creation, after setting all properties.
function popupmenuType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuIntegrationMethod.
function popupmenuIntegrationMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuIntegrationMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuIntegrationMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuIntegrationMethod


% --- Executes during object creation, after setting all properties.
function popupmenuIntegrationMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuIntegrationMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editInitialValueV0_Callback(hObject, eventdata, handles)
% hObject    handle to editInitialValueV0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editInitialValueV0 as text
%        str2double(get(hObject,'String')) returns contents of editInitialValueV0 as a double
global InitialValueV0
value = str2double(get(hObject, "String"));
if isnan(value)
    InitialValueV0 = 0;
    set(hObject, "String", 0);
else
    InitialValueV0 = value;
end


% --- Executes during object creation, after setting all properties.
function editInitialValueV0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editInitialValueV0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editInitialValueX0_Callback(hObject, eventdata, handles)
% hObject    handle to editInitialValueX0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editInitialValueX0 as text
%        str2double(get(hObject,'String')) returns contents of editInitialValueX0 as a double
global InitialValueX0
value = str2double(get(hObject, "String"));
if isnan(value)
    InitialValueX0 = 0;
    set(hObject, "String", 0);
else
    InitialValueX0 = value;
end

% --- Executes during object creation, after setting all properties.
function editInitialValueX0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editInitialValueX0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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



function editOde45TimeStart_Callback(hObject, eventdata, handles)
% hObject    handle to editOde45TimeStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOde45TimeStart as text
%        str2double(get(hObject,'String')) returns contents of editOde45TimeStart as a double
global t_0 t_end
value = str2double(get(hObject, "String"));
if isnan(value)
    t_0 = t_end - 1;
    set(hObject, "String", t_0);
else
    if value >= t_end
        t_0 = t_end - 1;
        set(hObject, "String", t_0);
    else
        t_0 = value;
    end
end


% --- Executes during object creation, after setting all properties.
function editOde45TimeStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOde45TimeStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOde45TimeEnd_Callback(hObject, eventdata, handles)
% hObject    handle to editOde45TimeEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOde45TimeEnd as text
%        str2double(get(hObject,'String')) returns contents of editOde45TimeEnd as a double
global t_0 t_end
value = str2double(get(hObject, "String"));
if isnan(value)
    t_end = t_0 + 1;
    set(hObject, "String", t_end);
else
    if value <= t_0
        t_end = t_0 + 1;
        set(hObject, "String", t_end);
    else
        t_end = value;
    end
end


% --- Executes during object creation, after setting all properties.
function editOde45TimeEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOde45TimeEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
