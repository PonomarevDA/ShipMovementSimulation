function model = createModelForSurfaceShipTest()
model.Type = "Submarine ship";
model.Variant = 0;
model.Group = "No group";
model.Name = "No name";
model.V = "-";                       	% speed, knots
M = 100000;                             % Max ship weight, kg
F = 5 * 10^4;                           % Max traction force, N
deltaF = 1000;                          % Allowable change traction force, N/sec
Vk = 6.9444;                            % Planing start speed, meter/sec
V1 = 8.3333;                            % 
V2 = 20;                                %

% Constants for translation to SI
KNOT_TO_METER_PER_SEC = 0.51;
HORSEPOWER_TO_WATT = 735.5;
TON_TO_KILOGRAM = 1000;

% ReStandart:
N = F*Vk;
model.W = M / TON_TO_KILOGRAM;          % displacement, ton
model.Vk = Vk / KNOT_TO_METER_PER_SEC;  % speed, knots
model.V1 = V1 / KNOT_TO_METER_PER_SEC;  % speed, knots
model.V2 = V2 / KNOT_TO_METER_PER_SEC;  % speed, knots
model.N = N / HORSEPOWER_TO_WATT;       % power, horsepower

end

