function [t, x, P, v] = solveContinuousModelForSurfaceTransport(model)
global InitialValueX0 InitialValueV0 t_0 t_end

% Constants for translation to SI
KNOT_TO_METER_PER_SEC = 0.51;
HORSEPOWER_TO_WATT = 735.5;
TON_TO_KILOGRAM = 1000;

% Calculate model parameters and 
% translate them to international system of units format
V = model.V * KNOT_TO_METER_PER_SEC;
N = model.N * HORSEPOWER_TO_WATT;
F = N / V;
if model.W < 10000
    deltaF = F * 0.1;
else
    deltaF = F * 0.2;
end
M = model.W * TON_TO_KILOGRAM;

% Create continuous system model
timeWhenPWillBeMax = F / deltaF;
A = F / (V^2);
P = @(t) 100 + (t < timeWhenPWillBeMax).*(t.*100./timeWhenPWillBeMax - 100);
F = @(t) P(t)*F/100;
dx_dt = @(t, s) s(2);
dv_dt = @(t, s) 1 / M * (F(t) - A * s(2) * abs(s(2)));
continuousModel = @(t, s) [dx_dt(t, s); dv_dt(t, s)];

% Solve system by ode45
[t, s] = ode45(continuousModel, [t_0 t_end], [InitialValueX0 InitialValueV0]);
x = s(1:end, 1);
v = s(1:end, 2);
P = P(t);
