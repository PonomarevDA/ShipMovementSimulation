clc; close all; clear;

% note: variant 11/8/27

% Table 5.1. surface ship
surfaceShip.Type = "Surface ship";
surfaceShip.Number = 11;
surfaceShip.Group = "Destroyer leaders";
surfaceShip.Name = "Tashkent";
surfaceShip.W = 3200;           % displacement, ton
surfaceShip.N = 110000;         % power, horsepower
surfaceShip.V = 42;             % speed, knots

% Table 5.2. boat
boat.Type = "Boat";
boat.Number = 8;
boat.Group = "Internal rides boat";
boat.Name = "New";
boat.W = 1.2;                   % displacement, ton
boat.N = 70;                    % power, horsepower
boat.V = 20.8;                  % speed, knots

% Table 5.3. hydrofoil ship
hydrofoilShip.Type = "Hydrofoil ship";
hydrofoilShip.Number = 27;      % Variant number
boat.Group = "No group";
boat.Name = "No name";
hydrofoilShip.W = 40;           % displacement, ton
hydrofoilShip.N = 2000;         % power, horsepower
hydrofoilShip.Vk = 13.2;        % speed, knots
hydrofoilShip.V1 = 15.8;        % speed, knots
hydrofoilShip.V2 = 38;          % speed, knots

% TestModel
test.Type = "Surface ship";
test.Number = 0;
test.Group = "No group";
test.Name = "No name";
test.M = 1000;
test.F = 1000;
test.DeltaF = 200;
test.V = 20;

% Solution
surfaceShip
[t, x, P, v] = solveDifferenceModel(surfaceShip);
[x, P, v] = normalize(x, P, v);

figure;
plot(t, x, 'b', ...
     t, P, 'r', ...
     t, v, 'g')
grid on;