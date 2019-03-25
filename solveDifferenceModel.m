function [t, x, P, v] = solveDifferenceModel(model)

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
    DeltaF = F * 0.1;
else
    DeltaF = F * 0.2;
end
M = model.W * TON_TO_KILOGRAM;

deltaTime = 1;
deltaPMax = deltaTime*(DeltaF / F)*100;
A = F / (V^2);
t = zeros(50, 1);
x = zeros(50, 1);
P = zeros(50, 1);
v = zeros(50, 1);

index = 2;
while v(index) <= 0.99 * V
    P(index + 1) = P(index) + deltaPMax;
    if P(index + 1) > 100
        P(index + 1) = 100;
    end
    deltaXi = x(index) - x(index - 1);
    x(index + 1) = x(index) + deltaXi + (P(index) * 1000 * deltaTime^2/100 - A * deltaXi * abs(deltaXi)) / M;
    v(index + 1) = (x(index + 1) - x(index)) / deltaTime;
    t(index + 1) = t(index) + deltaTime;
    index = index + 1;
    if index > 75
        break;
    end
end

% Reduce the size of the array
t = t(2 : index);
x = x(2 : index);
P = P(2 : index);
v = v(2 : index);
end

