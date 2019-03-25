function clearErrorMark(hObject)
% There is a bug when you try this sequence:
% 1. Set the object to white color
% 2. Disable the object
% 3. Enable object
% In this moment the object will have value of 'BackgroundColor' 
% parameter = 'white', but actual color will be 'red'.
% So, we will try to set firstly 'red', then 'white' to fix this bug:
set(hObject, 'BackgroundColor', 'red');
set(hObject, 'BackgroundColor', 'white');
end

