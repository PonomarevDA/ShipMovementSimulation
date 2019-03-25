function isThereAnError = updateAllErrorMarks(handles)
isThereAnError = false;

for objectsToCkeck = [handles.editVariant, handles.editDisplacement, ...
                      handles.editPower,   handles.editSpeed, ...
                      handles.editSpeedVk, handles.editSpeedV1, ...
                      handles.editSpeedV2]
    number = str2double(get(objectsToCkeck, "String"));
    if isnan(number) && (get(objectsToCkeck, "Enable") == "on")
        setErrorMark(objectsToCkeck)
        isThereAnError = true;
    else
        clearErrorMark(objectsToCkeck)
    end
end
end

