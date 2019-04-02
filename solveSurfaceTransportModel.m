%======================================================================
%> @brief Solve (continuous or differential) model for surface transport
%> @param model - struct with initial data of model
%> @param x0 - initial value of distance
%> @param v0 - initial value of speed
%> @param t_0 - initial time of integration
%> @param t_end - end time of integration
%> @param simulationType - type of simulation (acceleration or braking)
%> @param integrationMethod - method of integration (continuous or differential)
%> @retval row of time, distance, traction and speed vectors
%======================================================================
function [t, x, p, v] = solveSurfaceTransportModel(model, ...
    x0, v0, t_0, t_end, simulationType, integrationMethod)

% Enums
SIMULATION_TYPE_ACCELERATION = 1;
SIMULATION_TYPE_BRAKING = 2;
INTEGRATION_METHOD_CONTINUOUS = 1;
INTEGRATION_METHOD_DIFFERENTIAL = 2;

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


% Solve Continuous or Differential model
if integrationMethod == INTEGRATION_METHOD_CONTINUOUS
    % Init common part of system model
    timeWhenPWillBeMax = F / deltaF;
    A = F / (V^2);
    % Init other part of system model
    if simulationType == SIMULATION_TYPE_ACCELERATION
        P = @(t) 100 + ((t - t_0) < timeWhenPWillBeMax).*((t - t_0).*100./timeWhenPWillBeMax - 100);
        F = @(t) P(t)*F/100;
        dx_dt = @(t, s) s(2);
        dv_dt = @(t, s) 1 / M * (F(t) - A * s(2) * abs(s(2)));
        continuousModel = @(t, s) [dx_dt(t, s); dv_dt(t, s)];
    elseif simulationType == SIMULATION_TYPE_BRAKING
        P = @(t) -100 + ((t - t_0) < 2*timeWhenPWillBeMax).*(-(t - t_0).*100./timeWhenPWillBeMax + 200);
        F = @(t) P(t)*F/100;
        dx_dt = @(t, s) s(2);
        dv_dt = @(t, s) 1 / M * (F(t) - A * s(2) * abs(s(2)));
        continuousModel = @(t, s) [dx_dt(t, s); dv_dt(t, s)];
    end
    % Solve system by ode45
    [t, s] = ode45(continuousModel, [t_0 t_end], [x0 v0]);
    p = P(t);
    x = s(1:end, 1);
    v = s(1:end, 2);
    
elseif integrationMethod == INTEGRATION_METHOD_DIFFERENTIAL
    % Init parameters
    deltaTime = 0.01;
    deltaPMax = deltaTime*(deltaF / F)*100;
    A = F / (V^2);
    t = t_0 * ones(50, 1);
    v = v0 * ones(50, 1);
    x = x0 * ones(50, 1); 
    x(1) = x(2) - v(1)*deltaTime;
    index = 2; 
    if simulationType == SIMULATION_TYPE_ACCELERATION
        p = zeros(50, 1);
        calculateNewP = @(oldP) oldP + deltaPMax;
    elseif simulationType == SIMULATION_TYPE_BRAKING  
        p = 100*ones(50, 1);
        calculateNewP = @(oldP) oldP - deltaPMax;
    end
    % Solve system model
    while t(index) < t_end
        p(index + 1) = calculateNewP(p(index));
        if p(index + 1) > 100
            p(index + 1) = 100;
        elseif p(index + 1) < -100
            p(index + 1) = -100;
        end
        deltaXi = x(index) - x(index - 1);
        x(index + 1) = x(index) + deltaXi + (p(index) * F * deltaTime^2/100 - A * deltaXi * abs(deltaXi)) / M;
        v(index + 1) = (x(index + 1) - x(index)) / deltaTime;
        t(index + 1) = t(index) + deltaTime;
        index = index + 1;
    end
    % Reduce the size of the array
    t = t(2 : index);
    x = x(2 : index);
    p = p(2 : index);
    v = v(2 : index);
end