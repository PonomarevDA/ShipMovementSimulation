%======================================================================
%> @brief Calculate value of maximum change in thrust per second
%> @param N - power in watt
%> @param M - weight in kg
%> @param F - thrust
%> @retval value of maximum change in thrust per second
%======================================================================
function deltaF = calculateDeltaF(N, M, F)
global MaxChangeInRelativeThrustPerSecond

deltaP = 0.0089 + 3822/N;
if M > 10000000
    maxDeltaP = 0.1;
else
    maxDeltaP = 0.2;
end
if deltaP > maxDeltaP
    deltaP = maxDeltaP;
end
deltaF = F*deltaP;

MaxChangeInRelativeThrustPerSecond = deltaP * 100;

