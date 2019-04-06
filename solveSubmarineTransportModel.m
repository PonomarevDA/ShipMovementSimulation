%======================================================================
%> @brief Solve (continuous or differential) model for submarine transport
%> @param model - struct with initial data of model
%> @param x0 - initial value of distance
%> @param v0 - initial value of speed
%> @param t_0 - initial time of integration
%> @param t_end - end time of integration
%> @param simulationType - type of simulation (acceleration or braking)
%> @param integrationMethod - method of integration (continuous or differential)
%> @retval row of time, distance, traction and speed vectors
%======================================================================
function [t, x, p, v] = solveSubmarineTransportModel(model, ...
    x0, v0, t_0, t_end, simulationType, integrationMethod)

global RelativeThrust

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
Vk = model.Vk * KNOT_TO_METER_PER_SEC
V1 = model.V1 * KNOT_TO_METER_PER_SEC
V2 = model.V2 * KNOT_TO_METER_PER_SEC
N = model.N * HORSEPOWER_TO_WATT;
F = N / Vk
m = model.W * TON_TO_KILOGRAM
deltaF = calculateDeltaF(N, m, F)
A1 = F / (V1^2)
A2 = F / (V2^2)

% Solve Continuous or Differential model
if integrationMethod == INTEGRATION_METHOD_CONTINUOUS
     % Init common part of system model
    timeWhenPWillBeMax = F / deltaF;
    A = @(v) A1*(v <= Vk) + A2*(v >= V1) + (A1 - (v - Vk)*(A1 - A2)/(V1 - Vk))*((v > Vk) && (v < V1));
    t = 0; s = 0; p = 0;
    % Init other part of system model and solve it
    if simulationType == SIMULATION_TYPE_ACCELERATION
        % Create system model
        P_acceleration = @(t) 100 + ((t - t_0) < timeWhenPWillBeMax).*((t - t_0).*100./timeWhenPWillBeMax - 100);
        F_acceleration = @(t) P_acceleration(t)*F/100;
        dx_dt_acceleration = @(t, s) s(2);
        dv_dt_acceleration = @(t, s) 1 / m * (F_acceleration(t) - A(s(2)) * s(2) * abs(s(2)));
        continuous_model_acceleration = @(t, s) [dx_dt_acceleration(t, s); dv_dt_acceleration(t, s)];
        % Solve system model
        [t, s] = ode45(continuous_model_acceleration, [t_0 t_end], [x0 v0]); 
        p = P_acceleration(t);
    elseif simulationType == SIMULATION_TYPE_BRAKING
        % Create system model
        P_braking = @(t) -100 + ((t - t_0) < 2*timeWhenPWillBeMax).*(-(t - t_0).*100./timeWhenPWillBeMax + 200);
        F_braking = @(t) P_braking(t)*F/100;
        dx_dt_braking = @(t, s) s(2);
        dv_dt_braking = @(t, s) 1 / m * (F_braking(t) - A(s(2)) * s(2) * abs(s(2)));
        continuous_model_braking = @(t, s) [dx_dt_braking(t, s); dv_dt_braking(t, s)];
        % Solve system model
        [t, s] = ode45(continuous_model_braking, [t_0 t_end], [x0 v0]); 
        p = P_braking(t);
    end
	x = s(1:end, 1);
	v = s(1:end, 2);
elseif integrationMethod == INTEGRATION_METHOD_DIFFERENTIAL
    % Init parameters
    deltaTime = 1
    deltaPMax = deltaTime*(deltaF / F)*100
    t = t_0 * ones(50, 1);
    v = v0 * ones(50, 1);
    x = x0 * ones(50, 1); 
    x(1) = x(2) - v(1)*deltaTime;
    index = 2;
    if simulationType == SIMULATION_TYPE_ACCELERATION
        p = zeros(50, 1);
        calculateNewP = @(oldP) oldP + deltaPMax;
        arrayTreshold = 2;
    elseif simulationType == SIMULATION_TYPE_BRAKING  
        p = 100*ones(50, 1);
        calculateNewP = @(oldP) oldP - deltaPMax;
        arrayTreshold = 3;
    end
    % Solve system model
    while t(index) <= t_end
        p(index + 1) = calculateNewP(p(index));
        if p(index + 1) > 100
            p(index + 1) = 100;
        elseif p(index + 1) < -100
            p(index + 1) = -100;
        end
        deltaXi = x(index) - x(index - 1);
        if v(index) < Vk
            A = A1;
        elseif v(index) >= V1
            A = A2;
        else
            A = A1 - (v(index) - Vk)*(A1 - A2)/(V1 - Vk);
        end
        x(index + 1) = x(index) + deltaXi + (p(index + 1) * F * deltaTime^2/100 - A * deltaXi * abs(deltaXi)) / m;
        v(index + 1) = (x(index + 1) - x(index)) / deltaTime;
        t(index + 1) = t(index) + deltaTime;
        index = index + 1;
    end
    % Reduce the size of the array
    t = t(arrayTreshold : index);
    x = x(arrayTreshold : index);
    p = p(arrayTreshold : index);
    v = v(arrayTreshold : index);
end

