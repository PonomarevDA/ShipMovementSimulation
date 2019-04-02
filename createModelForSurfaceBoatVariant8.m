%======================================================================
%> @brief Create model for surface boat variant8
%======================================================================
function model = createModelForSurfaceBoatVariant8()
model.Type = "Surface boat";
model.Variant = 8;
model.Group = "Internal rides boat";
model.Name = "New";
model.W = 1.2;                          % displacement, ton
model.N = 70;                           % power, horsepower
model.V = 20.8;                        	% speed, knots
model.Vk = "-";                         % speed, knots
model.V1 = "-";                         % speed, knots
model.V2 = "-";                         % speed, knots
end

