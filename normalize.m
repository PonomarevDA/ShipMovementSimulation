function [x, P, v] = normalize(x, P, v)
x = x/max(x);
P = P/max(P)*0.5;
v = v/max(v);
end

