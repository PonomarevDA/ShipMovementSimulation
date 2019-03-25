function setModelInfoInGui(handles, model)
switch model.Type
    case "Surface ship"
        set(handles.popupmenuType, 'Value', 2);
	case "Surface boat"
        set(handles.popupmenuType, 'Value', 3);
    case "Submarine ship"
        set(handles.popupmenuType, 'Value', 4);
    otherwise
        set(handles.popupmenuType, 'Value', 1);
end
set(handles.editVariant, 'String', model.Variant);
set(handles.editGroup, 'String', model.Group);
set(handles.editName, 'String', model.Name);
set(handles.editDisplacement, 'String', model.W);
set(handles.editPower, 'String', model.N);
set(handles.editSpeed, 'String', model.V);
set(handles.editSpeedVk, 'String', model.Vk);
set(handles.editSpeedV1, 'String', model.V1);
set(handles.editSpeedV2, 'String', model.V2);
end

