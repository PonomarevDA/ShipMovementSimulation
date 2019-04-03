%======================================================================
%> @brief Calculate braking parameters any ship
%> @param t - time vector with size (pointsAmount, 1)
%> @param x - distance vector with size (pointsAmount, 1)
%> @param v - speed vector with size (pointsAmount, 1)
%> @retval parameters - struct with parameters:
%> Time - braking time (when speed = 0)
%> Distance - braking distance
%======================================================================
function parameters = calculateBrakingParameters(t, x, v)
for lastPointIndex = 1 : length(t)
	if v(lastPointIndex) < 0
        break
	end
end
parameters.Time = t(lastPointIndex) - t(1);
parameters.Distance = x(lastPointIndex) - x(1);

