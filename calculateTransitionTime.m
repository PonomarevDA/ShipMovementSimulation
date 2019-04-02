%======================================================================
%> @brief Search for the index of the last item when the transition is over
%> @param x - variable vector with size (pointsAmount, 1)
%> @param steadyState - steady state of variable
%> @retval lastPointIndex - index of last point when the transition is over
%======================================================================
function lastPointIndex = calculateTransitionTime(v, steadyState)
transitionTerminationCriterion = 0.99;
lastPointIndex = length(v);
    if v(end) >= steadyState*0.99
        for lastPointIndex = length(v) : -1 : 1
            if v(lastPointIndex) < steadyState * transitionTerminationCriterion
                break
            end
        end
    end
end

