function [t, x, p, v] = solveDifferenceModelForSubmarineTransport(model)
global InitialValueX0 InitialValueV0 t_0 t_end RelativeThrust

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

% Init parameters
deltaTime = 0.01;
deltaPMax = deltaTime*(deltaF / F)*100;
t = t_0 * ones(50, 1);
p = zeros(50, 1);
v = InitialValueV0 * ones(50, 1);
x = InitialValueX0 * ones(50, 1); 
x(1) = x(2) - v(1);

index = 2;
while t(index) <= t_end
    p(index + 1) = p(index) + deltaPMax;
    if p(index + 1) > 100
        p(index + 1) = 100;
    end
    deltaXi = x(index) - x(index - 1);
    if v(index) < Vk
        A = F / (V1^2);
    else
        A = F / (V2^2);
    end
    x(index + 1) = x(index) + deltaXi + (p(index) * F * deltaTime^2/100 - A * deltaXi * abs(deltaXi)) / m;
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

