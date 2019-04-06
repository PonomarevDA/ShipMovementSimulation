%======================================================================
%> @brief pid regulator - calculate new value for power 
%> @param timeCurrent - current time
%> @param currentSpeed - current speed
%> @param desiredSpeed - desired speed
%> @note There are several limitations and notes:
%> 1. output power can't leave the boundary: +100 and -100.
%> 2. output power can't change faster then max relative thrust change per
%>    second global variable allows
%> 3. ode45 can easy do step backwards in time, so we must take into
%     account this fact using appropriate processing: using table and 
%     looking for useful value from it!
%> 4. Before first call Iteration, Powers, Times and i must be initialized!
%> @retval powerNew - new power
%======================================================================
function powerNew = calculatePower(timeCurrent, currentSpeed, desiredSpeed)
global i MaxChangeInRelativeThrustPerSecond Iteration Powers Times

Kp = 5; Ki = 0.5; %Kd = 1;
% Calculate new integration part
if currentSpeed < desiredSpeed
    i = i + 1;
elseif currentSpeed > desiredSpeed
    i = i - 1;
end

% Find last time and power in arrays
timeLast = timeCurrent;
powerLast = 0;
for index = Iteration - 2 : -1 : 1
    if Times(index) < timeCurrent
        timeLast = Times(index);
        powerLast = Powers(index);
        break
    end
end
% timeLast = -inf;
% powerLast = 0;
% for index = Iteration - 2 : -1 : 1
%     if Times(index) < timeCurrent
%         if Times(index) > timeLast
%             timeLast = Times(index);
%             powerLast = Powers(index);
%         end
%     end
% end
% if timeLast == -inf
%     timeLast = timeCurrent;
% end

% Calculate new power with max relative thrust per second limitation
discrepancy = desiredSpeed - currentSpeed;
powerDesired = discrepancy * Kp + Ki * discrepancy * i;
maxChangeInRelativeThrustInThisIteration = MaxChangeInRelativeThrustPerSecond * (timeCurrent - timeLast);
if (powerDesired > powerLast) & (powerDesired > powerLast + maxChangeInRelativeThrustInThisIteration)
	powerNew = powerLast + maxChangeInRelativeThrustInThisIteration;
elseif powerDesired < powerLast - maxChangeInRelativeThrustInThisIteration
	powerNew = powerLast - maxChangeInRelativeThrustInThisIteration;
else
    powerNew = powerDesired;
end

% After arrays was update, consider boundary of max and min power value
if powerNew > 100
    powerNew = 100;
elseif powerNew < -100
    powerNew = -100;
end

% Update arrays
Powers(Iteration, 1) = powerNew;
Times(Iteration, 1) = timeCurrent;
Iteration = Iteration + 1;