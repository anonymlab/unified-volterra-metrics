function coefficients = leastSquaresSolver(outputMatrix, targetSignal)
% This function performs the least-squares regression method to find the
% optimized coefficients to approximate the targetSignal by a linear 
% combination of the outputMatrix.

            coefficients = pinv(outputMatrix) * targetSignal;
end