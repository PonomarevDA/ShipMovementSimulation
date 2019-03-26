function model = createModelForSurfaceShipTest()
model.Type = "Surface ship";
model.Variant = 0;
model.Group = "No group";
model.Name = "No name";
model.Vk = "-";                       	% speed, knots
model.V1 = "-";                       	% speed, knots
model.V2 = "-";                         % speed, knots
deltaF = 200;
F = 1000;
M = 1000;
V = 20;
N = F*V;

% Constants for translation to SI
KNOT_TO_METER_PER_SEC = 0.51;
HORSEPOWER_TO_WATT = 735.5;
TON_TO_KILOGRAM = 1000;

% ReStandart:
model.W = M / TON_TO_KILOGRAM;          % displacement, ton
model.V = V / KNOT_TO_METER_PER_SEC;    % speed, knots
model.N = N / HORSEPOWER_TO_WATT;       % power, horsepower

end

