%======================================================================
%> @brief Updata all errors marks
%> @param handles - structure with handles to object
%> @note If object is active and have error string value, set his background
% to "Red", else set background to "white"
%======================================================================
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

