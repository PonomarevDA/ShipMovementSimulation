%======================================================================
%> @brief Set all initial data on
%> @param handles - structure with handles and user data
%======================================================================
function setAllInitialDataOn(handles)
set(handles.popupmenuType,      'Enable', "On");
set(handles.editVariant,        'Enable', "On");
set(handles.editGroup,          'Enable', "On");
set(handles.editName,           'Enable', "On");
set(handles.editDisplacement,	'Enable', "On");
set(handles.editPower,          'Enable', "On");
set(handles.editSpeed,          'Enable', "On");
set(handles.editSpeedVk,        'Enable', "On");
set(handles.editSpeedV1,        'Enable', "On");
set(handles.editSpeedV2,        'Enable', "On");
end

