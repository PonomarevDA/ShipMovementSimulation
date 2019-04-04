function [T, P] = getPowerFromPid()
global iteration Powers Times
[T, arrayOfIndexes] = sort(Times);
P = zeros(size(T));
for index = 1 : length(P)
    P(index) = Powers(arrayOfIndexes(index));
end
end

