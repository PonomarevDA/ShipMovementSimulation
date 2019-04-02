%======================================================================
%> @brief Create model for submarine ship variant27
%======================================================================
function model = createModelForSubmarineShipVariant27()
model.Type = "Submarine ship";
model.Variant = 27;
model.Group = "No group";
model.Name = "No name";
model.W = 40;                         	% displacement, ton
model.N = 2000;                        	% power, horsepower
model.V = "-";                        	% speed, knots
model.Vk = 13.2;                       	% speed, knots
model.V1 = 15.8;                       	% speed, knots
model.V2 = 38;                          % speed, knots
end

