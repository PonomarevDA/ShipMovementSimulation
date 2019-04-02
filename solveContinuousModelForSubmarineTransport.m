function [t, x, P, v] = solveContinuousModelForSubmarineTransport(model)
global InitialValueX0 InitialValueV0 t_0 t_end SimulationType

% Constants for translation to SI
KNOT_TO_METER_PER_SEC = 0.51;
HORSEPOWER_TO_WATT = 735.5;
TON_TO_KILOGRAM = 1000;

% Calculate model parameters and 
% translate them to international system of units format
Vk = model.Vk * KNOT_TO_METER_PER_SEC;
V1 = model.V1 * KNOT_TO_METER_PER_SEC;
V2 = model.V2 * KNOT_TO_METER_PER_SEC;
N = model.N * HORSEPOWER_TO_WATT;
F = N / Vk;
if model.W < 10000
    deltaF = F * 0.1;
else
    deltaF = F * 0.2;
end
m = model.W * TON_TO_KILOGRAM;
A1 = F/(V1^2);
A2 = F/(V2^2);

% Create continuous system model
timeWhenPWillBeMax = F / deltaF;
A = @(v) A1*(v <= Vk) + A2*(v >= V1) + (A1 - (v - Vk)*(A1 - A2)/(V1 - Vk))*((v > Vk) && (v < V1));
% For acceleration direction
P_acceleration = @(t) 100 + (t < timeWhenPWillBeMax).*(t.*100./timeWhenPWillBeMax - 100);
F_acceleration = @(t) P_acceleration(t)*F/100;
dx_dt_acceleration = @(t, s) s(2);
dv_dt_acceleration = @(t, s) 1 / m * (F_acceleration(t) - A(s(2)) * s(2) * abs(s(2)));
continuous_model_acceleration = @(t, s) [dx_dt_acceleration(t, s); dv_dt_acceleration(t, s)];
% For braking direction
P_braking = @(t) -100 + (t < 2*timeWhenPWillBeMax).*(-t.*100./timeWhenPWillBeMax + 200);
F_braking = @(t) P_braking(t)*F/100;
dx_dt_braking = @(t, s) s(2);
dv_dt_braking = @(t, s) 1 / m * (F_braking(t) - A(s(2)) * s(2) * abs(s(2)));
continuous_model_braking = @(t, s) [dx_dt_braking(t, s); dv_dt_braking(t, s)];


% Solve system by ode45
t = 0; s = 0; P = 0;
if SimulationType == 1
    [t, s] = ode45(continuous_model_acceleration, [t_0 t_end], [InitialValueX0 InitialValueV0]); 
    P = P_acceleration(t);
    x = s(1:end, 1);
    v = s(1:end, 2);
elseif SimulationType == 2
    [t, s] = ode45(continuous_model_braking, [t_0 t_end], [InitialValueX0 InitialValueV0]); 
    P = P_braking(t);
    x = s(1:end, 1);
    v = s(1:end, 2);
elseif SimulationType == 3
    [t1, s1] = ode45(continuous_model_acceleration, [t_0 t_end], [InitialValueX0 InitialValueV0]); 
    
    parameters = calculateSurfaceShipAccelerationParameters(t1, s1(1:end, 1), s1(1:end, 2));
    t1 = t1(1 : parameters.PointsAmount);
    x1 = s1(1 : parameters.PointsAmount, 1);
    v1 = s1(1 : parameters.PointsAmount, 2);
    P1 = P_acceleration(t1); 
    
    [t2, s2] = ode45(continuous_model_braking, [t_end (2*t_end - t_0)], [x1(end) v1(end)]); 
    x2 = s2(1:end, 1);
    v2 = s2(1:end, 2);
    P2 = P_braking(t2);   
    
    t = [t1; t2];
    x = [x1; x2];
    v = [v1; v2];
    P = [P1; P2];
end


