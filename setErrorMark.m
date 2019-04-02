%======================================================================
%> @brief Set all initial data off
%> @param hObject - handle to object
%> @note There is a bug when you try this sequence:
% 1. Set the object to red color
% 2. Disable the object
% 3. Enable object
% In this moment the object will have value of 'BackgroundColor' 
% parameter = 'red', but actual color will be 'white'.
% So, we will try to set firstly 'white', then 'red' to fix this bug:
%======================================================================
function setErrorMark(hObject)
set(hObject, 'BackgroundColor', 'white');
set(hObject, 'BackgroundColor', 'red');
end

