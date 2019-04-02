%======================================================================
%> @brief Create model for surface ship variant11
%======================================================================
function model = createModelForSurfaceShipVariant11()
model.Type = "Surface ship";
model.Variant = 11;
model.Group = "Destroyer leaders";
model.Name = "Tashkent";
model.W = 3200;                         % displacement, ton
model.N = 110000;                       % power, horsepower
model.V = 42;                           % speed, knots
model.Vk = "-";                         % speed, knots
model.V1 = "-";                         % speed, knots
model.V2 = "-";                         % speed, knots
end

