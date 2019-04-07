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

% Last Modified by GUIDE v2.5 04-Apr-2019 19:36:06

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
global InitialValueX0 InitialValueV0 t_0 t_end InitialRelativeThrust DesiredSpeed
InitialValueX0 = 0; 
InitialValueV0 = 0; 
InitialRelativeThrust = 0;
t_0 = 0; 
t_end = 100;
DesiredSpeed = 0;

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

% Global variables
global Model InitialValueX0 InitialValueV0 InitialRelativeThrust t_0 t_end DebugInfo

% Enums
SIMULATION_TYPE_ACCELERATION = 1;
SIMULATION_TYPE_BRAKING = 2;
SIMULATION_TYPE_BOTH_ACCELERATION_AND_BRAKING = 3;
SIMULATION_TYPE_CRUISE_CONTROL_PID = 4;
SIMULATION_TYPE_CRUISE_CONTROL_SMART = 5;
MODEL_TYPE_NO_MODEL = 1;
MODEL_TYPE_SURFACE_SHIP = 2;
MODEL_TYPE_SURFACE_BOAT = 3;
MODEL_TYPE_SUBMARINE_SHIP = 4;

% Simulate system model if there are no error marks
modelType = get(handles.popupmenuType, "Value");
if (updateAllErrorMarks(handles) == false) & (modelType ~= MODEL_TYPE_NO_MODEL)
    % 1. Get info about simulation
    simulationType = get(handles.popupmenuSimulationType, "Value");
    integrationMethod = get(handles.popupmenuIntegrationMethod, "Value");
    
    % 2. Method setting
    solve = @(x0, v0, p0, t_0, t_end, simulationType) solveModel(Model, ...
              x0, v0, p0, t_0, t_end, simulationType, integrationMethod);

    % 3. Simulate system and calculate parameters
    % 3.1. Acceleration (any ship)
    if simulationType == SIMULATION_TYPE_ACCELERATION
        [t, x, p, v] = solve(InitialValueX0, InitialValueV0, InitialRelativeThrust, t_0, t_end, SIMULATION_TYPE_ACCELERATION);
        outputParameters = calculateAccelerationParameters(t, x, v);
        
        set(handles.editAccelerationMaximumSpeed, "String", outputParameters.MaxSpeed)
        set(handles.editAccelerationTime, "String", outputParameters.MaxSpeedTime)
        set(handles.editAccelerationDistance, "String", outputParameters.Distance)
        
        set(handles.editAccelerationTimeDisplacementMode, "String", outputParameters.TimeDisplacementMode)
        set(handles.editAccelerationDistanceDisplacementMode, "String", outputParameters.DistanceDisplacementMode)
        
        set(handles.editAccelerationTimeGlindingMode, "String", outputParameters.TimeGlindingMode)
        set(handles.editAccelerationDistanceGlindingMode, "String", outputParameters.DistanceGlindingMode)
        
        set(handles.editAccelerationTimeOnTheWings, "String", outputParameters.TimeOnTheWings)
        set(handles.editAccelerationDistanceOnTheWings, "String", outputParameters.DistanceOnTheWings)

        set(handles.editBrakingTime, "String", "-")
        set(handles.editBrakingDistance, "String", "-")
        
        set(handles.editTotalTime, "String", "-")
        set(handles.editTotalDistance, "String", "-")
    % 3.2. Braking
    elseif simulationType == SIMULATION_TYPE_BRAKING
        [t, x, p, v] = solve(InitialValueX0, InitialValueV0, InitialRelativeThrust, t_0, t_end, SIMULATION_TYPE_BRAKING);
        outputParameters = calculateBrakingParameters(t, x, v);
        
        set(handles.editAccelerationMaximumSpeed, "String", "-")
        set(handles.editAccelerationTime, "String", "-")
        set(handles.editAccelerationDistance, "String", "-")
        
        set(handles.editAccelerationTimeDisplacementMode, "String", "-")
        set(handles.editAccelerationDistanceDisplacementMode, "String", "-")
        
        set(handles.editAccelerationTimeGlindingMode, "String", "-")
        set(handles.editAccelerationDistanceGlindingMode, "String", "-")
        
        set(handles.editAccelerationTimeOnTheWings, "String", "-")
        set(handles.editAccelerationDistanceOnTheWings, "String", "-")
        
        set(handles.editBrakingTime, "String", outputParameters.Time)
        set(handles.editBrakingDistance, "String", outputParameters.Distance)
        
        set(handles.editTotalTime, "String", "-")
        set(handles.editTotalDistance, "String", "-")
    % 3.3. Both Acceleration + braking
    elseif simulationType == SIMULATION_TYPE_BOTH_ACCELERATION_AND_BRAKING
        [t1, x1, p1, v1] = solve(InitialValueX0, InitialValueV0, InitialRelativeThrust, t_0, t_end, SIMULATION_TYPE_ACCELERATION);
        accerationParameters = calculateAccelerationParameters(t1, x1, v1);
        t1 = t1(1 : accerationParameters.PointsAmount); 
        x1 = x1(1 : accerationParameters.PointsAmount);
        p1 = p1(1 : accerationParameters.PointsAmount); 
        v1 = v1(1 : accerationParameters.PointsAmount);
        
        [t2, x2, p2, v2] = solve(x1(end), v1(end), 100, t1(end), t_end + 0.5, SIMULATION_TYPE_BRAKING); 
        brakingParameters = calculateBrakingParameters(t2, x2, v2);
        
        set(handles.editAccelerationMaximumSpeed, "String", accerationParameters.MaxSpeed)
        set(handles.editAccelerationTime, "String", accerationParameters.MaxSpeedTime)
        set(handles.editAccelerationDistance, "String", accerationParameters.Distance)
        
        set(handles.editAccelerationTimeDisplacementMode, "String", accerationParameters.TimeDisplacementMode)
        set(handles.editAccelerationDistanceDisplacementMode, "String", accerationParameters.DistanceDisplacementMode)
        
        set(handles.editAccelerationTimeGlindingMode, "String", accerationParameters.TimeGlindingMode)
        set(handles.editAccelerationDistanceGlindingMode, "String", accerationParameters.DistanceGlindingMode)
        
        set(handles.editAccelerationTimeOnTheWings, "String", accerationParameters.TimeOnTheWings)
        set(handles.editAccelerationDistanceOnTheWings, "String", accerationParameters.DistanceOnTheWings)

        set(handles.editBrakingTime, "String", brakingParameters.Time)
        set(handles.editBrakingDistance, "String", brakingParameters.Distance)
        
        set(handles.editTotalTime, "String", accerationParameters.MaxSpeedTime + brakingParameters.Time)
        set(handles.editTotalDistance, "String", accerationParameters.Distance + brakingParameters.Distance)
    elseif (simulationType == SIMULATION_TYPE_CRUISE_CONTROL_PID) | (simulationType == SIMULATION_TYPE_CRUISE_CONTROL_SMART)
    	[t, x, p, v] = solve(InitialValueX0, InitialValueV0, InitialRelativeThrust, t_0, t_end, simulationType);
        set(handles.editAccelerationMaximumSpeed, "String", "-")
        set(handles.editAccelerationTime, "String", "-")
        set(handles.editAccelerationDistance, "String", "-")
        
        set(handles.editAccelerationTimeDisplacementMode, "String", "-")
        set(handles.editAccelerationDistanceDisplacementMode, "String", "-")
        
        set(handles.editAccelerationTimeGlindingMode, "String", "-")
        set(handles.editAccelerationDistanceGlindingMode, "String", "-")
        
        set(handles.editAccelerationTimeOnTheWings, "String", "-")
        set(handles.editAccelerationDistanceOnTheWings, "String", "-")

        set(handles.editBrakingTime, "String", "-")
        set(handles.editBrakingDistance, "String", "-")
        
        set(handles.editTotalTime, "String", "-")
        set(handles.editTotalDistance, "String", "-")
    end
    
    % 4. Create graph
    %figure
    yyaxis left
    if (simulationType == SIMULATION_TYPE_ACCELERATION) | (simulationType == SIMULATION_TYPE_BRAKING) | ...
       (simulationType == SIMULATION_TYPE_CRUISE_CONTROL_PID) | (simulationType == SIMULATION_TYPE_CRUISE_CONTROL_SMART)
        plot(t, x, 'b')
    elseif simulationType == SIMULATION_TYPE_BOTH_ACCELERATION_AND_BRAKING
        plot(t1, x1, 'b', t2, x2,'b')
    end
    ylabel('Distance x, meters')
    yyaxis right
    if (simulationType == SIMULATION_TYPE_ACCELERATION) | (simulationType == SIMULATION_TYPE_BRAKING) | ...
       (simulationType == SIMULATION_TYPE_CRUISE_CONTROL_SMART) | (simulationType == SIMULATION_TYPE_CRUISE_CONTROL_PID)
        plot(t, p, 'r', t, v, 'g')
    %elseif simulationType == SIMULATION_TYPE_CRUISE_CONTROL_PID
    %    [T, P] = getPowerFromPid();
    %    plot(T, P, 'r', t, v, 'g')
    elseif simulationType == SIMULATION_TYPE_BOTH_ACCELERATION_AND_BRAKING
        plot(t1, p1, 'r-', t1, v1, 'g', t2, p2, 'r', t2, v2, 'g')
    end
    ylabel('Traction force, %, Speed, meters/sec')
    grid on;
    title('Blue - distance, red - traction force, green - speed')
    
	% Debug information
    if simulationType == SIMULATION_TYPE_BOTH_ACCELERATION_AND_BRAKING
        DebugInfo = [[t1; t2], [x1; x2], [p1; p2], [v1; v2]];
    else
        %DebugInfo = [t, x, p, v];
    end
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
function sliderRelativeThrust_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRelativeThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global InitialRelativeThrust
InitialRelativeThrust = get(hObject, "Value");
restValue = mod(InitialRelativeThrust, 10);
InitialRelativeThrust = (fix(InitialRelativeThrust/10) + (restValue >= 5)) * 10;
set(handles.editRelativeThrust, "String", InitialRelativeThrust);


% --- Executes during object creation, after setting all properties.
function sliderRelativeThrust_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRelativeThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value', 0);


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



function editAccelerationDistance_Callback(hObject, eventdata, handles)
% hObject    handle to editAccelerationDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAccelerationDistance as text
%        str2double(get(hObject,'String')) returns contents of editAccelerationDistance as a double


% --- Executes during object creation, after setting all properties.
function editAccelerationDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAccelerationDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAccelerationMaximumSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to editAccelerationMaximumSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAccelerationMaximumSpeed as text
%        str2double(get(hObject,'String')) returns contents of editAccelerationMaximumSpeed as a double


% --- Executes during object creation, after setting all properties.
function editAccelerationMaximumSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAccelerationMaximumSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAccelerationTime_Callback(hObject, eventdata, handles)
% hObject    handle to editAccelerationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAccelerationTime as text
%        str2double(get(hObject,'String')) returns contents of editAccelerationTime as a double


% --- Executes during object creation, after setting all properties.
function editAccelerationTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAccelerationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBrakingDistance_Callback(hObject, eventdata, handles)
% hObject    handle to editBrakingDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBrakingDistance as text
%        str2double(get(hObject,'String')) returns contents of editBrakingDistance as a double


% --- Executes during object creation, after setting all properties.
function editBrakingDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBrakingDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBrakingTime_Callback(hObject, eventdata, handles)
% hObject    handle to editBrakingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBrakingTime as text
%        str2double(get(hObject,'String')) returns contents of editBrakingTime as a double


% --- Executes during object creation, after setting all properties.
function editBrakingTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBrakingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTotalDistance_Callback(hObject, eventdata, handles)
% hObject    handle to editTotalDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTotalDistance as text
%        str2double(get(hObject,'String')) returns contents of editTotalDistance as a double


% --- Executes during object creation, after setting all properties.
function editTotalDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTotalDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTotalTime_Callback(hObject, eventdata, handles)
% hObject    handle to editTotalTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTotalTime as text
%        str2double(get(hObject,'String')) returns contents of editTotalTime as a double


% --- Executes during object creation, after setting all properties.
function editTotalTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTotalTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuSimulationType.
function popupmenuSimulationType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSimulationType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSimulationType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSimulationType
global SimulationType
SimulationType = get(hObject, 'Value');

% --- Executes during object creation, after setting all properties.
function popupmenuSimulationType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSimulationType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAccelerationTimeOnTheWings_Callback(hObject, eventdata, handles)
% hObject    handle to editAccelerationTimeOnTheWings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAccelerationTimeOnTheWings as text
%        str2double(get(hObject,'String')) returns contents of editAccelerationTimeOnTheWings as a double


% --- Executes during object creation, after setting all properties.
function editAccelerationTimeOnTheWings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAccelerationTimeOnTheWings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAccelerationDistanceOnTheWings_Callback(hObject, eventdata, handles)
% hObject    handle to editAccelerationDistanceOnTheWings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAccelerationDistanceOnTheWings as text
%        str2double(get(hObject,'String')) returns contents of editAccelerationDistanceOnTheWings as a double


% --- Executes during object creation, after setting all properties.
function editAccelerationDistanceOnTheWings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAccelerationDistanceOnTheWings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAccelerationTimeGlindingMode_Callback(hObject, eventdata, handles)
% hObject    handle to editAccelerationTimeGlindingMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAccelerationTimeGlindingMode as text
%        str2double(get(hObject,'String')) returns contents of editAccelerationTimeGlindingMode as a double


% --- Executes during object creation, after setting all properties.
function editAccelerationTimeGlindingMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAccelerationTimeGlindingMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAccelerationDistanceGlindingMode_Callback(hObject, eventdata, handles)
% hObject    handle to editAccelerationDistanceGlindingMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAccelerationDistanceGlindingMode as text
%        str2double(get(hObject,'String')) returns contents of editAccelerationDistanceGlindingMode as a double


% --- Executes during object creation, after setting all properties.
function editAccelerationDistanceGlindingMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAccelerationDistanceGlindingMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAccelerationTimeDisplacementMode_Callback(hObject, eventdata, handles)
% hObject    handle to editAccelerationTimeDisplacementMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAccelerationTimeDisplacementMode as text
%        str2double(get(hObject,'String')) returns contents of editAccelerationTimeDisplacementMode as a double


% --- Executes during object creation, after setting all properties.
function editAccelerationTimeDisplacementMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAccelerationTimeDisplacementMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAccelerationDistanceDisplacementMode_Callback(hObject, eventdata, handles)
% hObject    handle to editAccelerationDistanceDisplacementMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAccelerationDistanceDisplacementMode as text
%        str2double(get(hObject,'String')) returns contents of editAccelerationDistanceDisplacementMode as a double


% --- Executes during object creation, after setting all properties.
function editAccelerationDistanceDisplacementMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAccelerationDistanceDisplacementMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRelativeThrust_Callback(hObject, eventdata, handles)
% hObject    handle to editRelativeThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRelativeThrust as text
%        str2double(get(hObject,'String')) returns contents of editRelativeThrust as a double


% --- Executes during object creation, after setting all properties.
function editRelativeThrust_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRelativeThrust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String', 0);



function editCruiseControl_Callback(hObject, eventdata, handles)
% hObject    handle to editCruiseControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCruiseControl as text
%        str2double(get(hObject,'String')) returns contents of editCruiseControl as a double


% --- Executes during object creation, after setting all properties.
function editCruiseControl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCruiseControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderCruiseControl_Callback(hObject, eventdata, handles)
% hObject    handle to sliderCruiseControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global DesiredSpeed Model
KNOT_TO_METER_PER_SEC = 0.51;
if (Model.Type == "Surface ship") | (Model.Type == "Surface boat")
    DesiredSpeed = Model.V / 100 * get(hObject, "Value");
else
    DesiredSpeed = Model.V2 / 100 * get(hObject, "Value");
end
DesiredSpeed = DesiredSpeed * KNOT_TO_METER_PER_SEC;
set(handles.editCruiseControl, "String", get(hObject, "Value"));


% --- Executes during object creation, after setting all properties.
function sliderCruiseControl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderCruiseControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
