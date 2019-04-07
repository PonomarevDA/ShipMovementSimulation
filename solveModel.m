%======================================================================
%> @brief Solve (continuous or differential) model for any ship
%> @param model - struct with initial data of model
%> @param x0 - initial value of distance
%> @param v0 - initial value of speed
%> @param p0 - initial value of relative thrust
%> @param t_0 - initial time of integration
%> @param t_end - end time of integration
%> @param simulationType - type of simulation (acceleration or braking)
%> @param integrationMethod - method of integration (continuous or differential)
%> @retval row of time, distance, traction and speed vectors
%======================================================================
function [t, x, p, v] = solveModel(model, ...
    x0, v0, p0, t_0, t_end, simulationType, integrationMethod)

global DesiredSpeed MaxChangeInRelativeThrustPerSecond

% Enums
SIMULATION_TYPE_ACCELERATION = 1;
SIMULATION_TYPE_BRAKING = 2;
SIMULATION_TYPE_CRUISE_CONTROL_PID = 4;
SIMULATION_TYPE_CRUISE_CONTROL_SMART = 5;
INTEGRATION_METHOD_CONTINUOUS = 1;
INTEGRATION_METHOD_DIFFERENTIAL = 2;

% Constants for translation to SI
KNOT_TO_METER_PER_SEC = 0.51;
HORSEPOWER_TO_WATT = 735.5;
TON_TO_KILOGRAM = 1000;

% Calculate model parameters and 
% translate them to international system of units format
if (model.Type == "Surface ship") | (model.Type == "Surface boat")
    V = model.V * KNOT_TO_METER_PER_SEC;
    N = model.N * HORSEPOWER_TO_WATT;
    F = N / V;
    M = model.W * TON_TO_KILOGRAM;
    deltaF = calculateDeltaF(N, M, F);
    A = @(v) F / (V^2);
elseif model.Type == "Submarine ship"
    Vk = model.Vk * KNOT_TO_METER_PER_SEC
    V1 = model.V1 * KNOT_TO_METER_PER_SEC
    V2 = model.V2 * KNOT_TO_METER_PER_SEC
    N = model.N * HORSEPOWER_TO_WATT;
    F = N / Vk
    M = model.W * TON_TO_KILOGRAM
    deltaF = calculateDeltaF(N, M, F)
    A1 = F / (V1^2)
    A2 = F / (V2^2)
    A = @(v) A1*(v <= Vk) + A2*(v >= V1) + (A1 - (v - Vk)*(A1 - A2)/(V1 - Vk))*((v > Vk) && (v < V1));
end

% Solve Continuous or Differential model
if integrationMethod == INTEGRATION_METHOD_CONTINUOUS
    % Init other part of system model
    if simulationType == SIMULATION_TYPE_ACCELERATION
        endP = 100;
        dP = endP - p0;
        timeWhenPWillBeMax = dP / 100 * F / deltaF;
        speedP = F / deltaF;
        calculateP = @(t) endP + ((t - t_0) < timeWhenPWillBeMax).*((t - t_0).*endP./speedP - dP);
        calculateF = @(t) calculateP(t)*F/100;
        dx_dt = @(t, s) s(2);
        dv_dt = @(t, s) 1 / M * (calculateF(t) - A(s(2)) * s(2) * abs(s(2)));
        continuousModel = @(t, s) [dx_dt(t, s); dv_dt(t, s)];
    elseif simulationType == SIMULATION_TYPE_BRAKING
        endP = -100;
        dP = endP - p0;
        timeWhenPWillBeMax = abs(dP / 100 * F / deltaF) ;
        speedP = F / deltaF;
        calculateP = @(t) endP + ((t - t_0) < timeWhenPWillBeMax).*((t - t_0).*endP./speedP - dP);
        calculateF = @(t) calculateP(t)*F/100;
        dx_dt = @(t, s) s(2);
        dv_dt = @(t, s) 1 / M * (calculateF(t) - A(s(2)) * s(2) * abs(s(2)));
        continuousModel = @(t, s) [dx_dt(t, s); dv_dt(t, s)]; 
    elseif simulationType == SIMULATION_TYPE_CRUISE_CONTROL_PID
        Kp = 0; Ki = 0.45;
        calculateF = @(t, s) (s(3))*F/100;
        dx_dt = @(t, s) s(2);
        dv_dt = @(t, s) 1 / M * (calculateF(t, s) - A(s(2)) * s(2) * abs(s(2)));
        dp_dt = @(t, s) Ki * (DesiredSpeed - s(2));
        dp_dt_limitation = @(t, s) ((s(3) + dp_dt(t, s) <= 100) & (s(3) + dp_dt(t, s) >= -100)) * dp_dt(t, s);
        dp_dt_saturation = @(t, s) (dp_dt_limitation(t, s) < MaxChangeInRelativeThrustPerSecond) * dp_dt_limitation(t, s) + (dp_dt_limitation(t, s) >= MaxChangeInRelativeThrustPerSecond) * MaxChangeInRelativeThrustPerSecond;
        continuousModel = @(t, s) [dx_dt(t, s); dv_dt(t, s); dp_dt_saturation(t, s)];
    elseif simulationType == SIMULATION_TYPE_CRUISE_CONTROL_SMART
        calculateF = @(t, s) s(3)*F/100;
        dx_dt = @(t, s) s(2);
        dv_dt = @(t, s) 1 / M * (calculateF(t, s) - A(s(2)) * s(2) * abs(s(2)));
        needP = A(DesiredSpeed) * 100 / F * DesiredSpeed^2;
        dp_dt = @(t, s) (needP > s(3)) * MaxChangeInRelativeThrustPerSecond + (needP < s(3)) * (-MaxChangeInRelativeThrustPerSecond);        
        continuousModel = @(t, s) [dx_dt(t, s); dv_dt(t, s); dp_dt(t, s)];
    end
    % Solve system by ode45
    if (simulationType == SIMULATION_TYPE_CRUISE_CONTROL_SMART) | (simulationType == SIMULATION_TYPE_CRUISE_CONTROL_PID)   
        [t, s] = ode45(continuousModel, [t_0 t_end], [x0 v0 p0]);
        p = s(1:end, 3);
    elseif (simulationType == SIMULATION_TYPE_ACCELERATION) | (simulationType == SIMULATION_TYPE_BRAKING)
        [t, s] = ode45(continuousModel, [t_0 t_end], [x0 v0]);
        p = calculateP(t);
    end
    x = s(1:end, 1);
    v = s(1:end, 2);
elseif integrationMethod == INTEGRATION_METHOD_DIFFERENTIAL
    % Init parameters
    deltaTime = 0.1
    deltaPMax = deltaTime*(deltaF / F)*100
    t = t_0 * ones(50, 1);
    v = v0 * ones(50, 1);
    x = x0 * ones(50, 1); 
    x(1) = x(2) - v(1)*deltaTime;
    index = 2; 
    if simulationType == SIMULATION_TYPE_ACCELERATION
        p = p0*ones(50, 1);
        calculateNewP = @(oldP, v, t) oldP + deltaPMax;
        arrayTreshold = 2;
    elseif simulationType == SIMULATION_TYPE_BRAKING  
        p = p0*ones(50, 1);
        calculateNewP = @(oldP, v, t) oldP - deltaPMax;
        arrayTreshold = 3;
    elseif simulationType == SIMULATION_TYPE_CRUISE_CONTROL_PID
        p = p0*ones(50, 1);
        Kp = 0; Ki = 0.45;
        error = @(newV) (DesiredSpeed - newV);
        calculateNewP = @(oldP, newV, oldT) error(newV)*Kp + oldP + Ki * error(newV) * deltaTime;
        arrayTreshold = 2;
    elseif simulationType == SIMULATION_TYPE_CRUISE_CONTROL_SMART
        p = p0*ones(50, 1);
        calculateNewP = @(oldP, newV, oldT) A(DesiredSpeed) / F * abs(DesiredSpeed) * (DesiredSpeed) * 100;
        arrayTreshold = 2;
    end
    % Solve system model
    while t(index) < t_end
        p(index + 1) = calculateNewP(p(index), v(index), t(index));
        if (p(index + 1) - p(index)) > (MaxChangeInRelativeThrustPerSecond * deltaTime)
            p(index + 1) = p(index) + MaxChangeInRelativeThrustPerSecond * deltaTime;
        elseif (p(index + 1) - p(index)) < (-MaxChangeInRelativeThrustPerSecond * deltaTime)
            p(index + 1) = p(index) - MaxChangeInRelativeThrustPerSecond * deltaTime;
        end
        if p(index + 1) > 100
            p(index + 1) = 100;
        elseif p(index + 1) < -100
            p(index + 1) = -100;
        end
        deltaXi = x(index) - x(index - 1);
        x(index + 1) = x(index) + deltaXi + (p(index + 1) * F * deltaTime^2/100 - A(v(index)) * deltaXi * abs(deltaXi)) / M;
        v(index + 1) = (x(index + 1) - x(index)) / deltaTime;
        t(index + 1) = t(index) + deltaTime;
        index = index + 1;
    end
    % Reduce the size of the array
    t = t(arrayTreshold : index - 1);
    x = x(arrayTreshold : index - 1);
    p = p(arrayTreshold : index - 1);
    v = v(arrayTreshold : index - 1);
end