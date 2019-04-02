%======================================================================
%> @brief Calculate acceleration parameters any ship
%> @param t - time vector with size (pointsAmount, 1)
%> @param x - distance vector with size (pointsAmount, 1)
%> @param v - speed vector with size (pointsAmount, 1)
%> @retval parameters - struct with parameters
%======================================================================
function parameters = calculateAccelerationParameters(t, x, v)

global Model
KNOT_TO_METER_PER_SEC = 0.51;

if (Model.Type == "Surface ship") | (Model.Type == "Surface boat")
    maxSpeed = Model.V * KNOT_TO_METER_PER_SEC;
    lastPointIndex = calculateTransitionTime(v, maxSpeed);
    parameters.MaxSpeed = v(lastPointIndex);
    parameters.MaxSpeedTime = t(lastPointIndex);
    parameters.Distance = x(lastPointIndex);
    parameters.PointsAmount = lastPointIndex;
    
    parameters.TimeDisplacementMode = "-";
    parameters.DistanceDisplacementMode = "-";
    
    parameters.TimeGlindingMode = "-";
    parameters.DistanceGlindingMode = "-";
    
    parameters.TimeOnTheWings = "-";
    parameters.DistanceOnTheWings = "-";
elseif Model.Type == "Submarine ship"
    maxSpeed = Model.V2 * KNOT_TO_METER_PER_SEC;
    lastPointIndex = calculateTransitionTime(v, maxSpeed);
    parameters.MaxSpeed = v(lastPointIndex);
    parameters.MaxSpeedTime = t(lastPointIndex);
    parameters.Distance = x(lastPointIndex);
    parameters.PointsAmount = lastPointIndex;
    
    maxSpeed = Model.Vk * KNOT_TO_METER_PER_SEC;
    lastPointIndex = calculateTransitionTime(v, maxSpeed);
    parameters.TimeDisplacementMode = t(lastPointIndex);
    parameters.DistanceDisplacementMode = x(lastPointIndex);
    
    maxSpeed = Model.V1 * KNOT_TO_METER_PER_SEC;
    lastPointIndex = calculateTransitionTime(v, maxSpeed);
    parameters.TimeGlindingMode = t(lastPointIndex) - parameters.TimeDisplacementMode;
    parameters.DistanceGlindingMode = x(lastPointIndex) - parameters.DistanceDisplacementMode;
    
    parameters.TimeOnTheWings = parameters.MaxSpeedTime - t(lastPointIndex);
    parameters.DistanceOnTheWings = parameters.Distance - x(lastPointIndex);
end

