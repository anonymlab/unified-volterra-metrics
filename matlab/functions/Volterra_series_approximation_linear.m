function [Coeff_matrix,response_diff_matrix,NMSE_array] = Volterra_series_approximation_linear(N_start,N_end,Input_data_array,System_reponse_matrix)
% This function performs linear Volterra-series approximation based on 
% simple least-squares method. It approximates a system reponse by using
% the input signal and a bias term only. This is first performed to enhance
% prediction accuracy. More advanced method could be adopted to further
% improve the series approximation robustness.
% It involves the following input parameters:
% N_start: initial time step for the data used in the approximation
% N_end: final time step for the data used in the approximation
% Input_data_array: input data for analysis
% System_reponse_matrix: matrix of system responses for analysis
% This function outputs the following:
% Coeff_matrix: estimated Volterra series coefficients, with each row
% corresponding to each system response. They are ordered by first fixing
% memory depth k and iterating through p = 1 to P. Then repeat to the next
% k value, iterating from k=0 to K.
% Exponent_matrix: matrix containing all possible exponent vectors as
% investigated
% response_diff_matrix: obtained, renormalized differences of the system 
% response from its linear approximation. This will be used for the full
% Volterra-series approximation to enhance accuracy.
% NMSE_array: an array recording the NMSEs of this approximation for each
% system response.



%% Construct the regression matrix for monomial bases

N_total = N_end-N_start; % compute the total time steps for approximation

Basis_matrix = zeros(N_total, 2);

% Introduce linear basis and a bias basis term
Basis_matrix(:,1) = ones(1,N_total);
Basis_matrix(:,2) = normalize(Input_data_array(N_start+1:N_start+N_total));

%% Perform least-squares regression to compute the Volterra kernel coefficients

% read the total number of system responses
N_Response = size(System_reponse_matrix, 1);
% initialize a coefficient matrix
Coeff_matrix = zeros(N_Response,2);
% initialize an NMSE array
NMSE_array = zeros(N_Response,1);
% initialize the response difference matrix
response_diff_matrix = zeros(N_Response,N_total);


% iterate for each system response for approximation.
for i = 1:N_Response
    % Define the target signal of this regression
    Target_signal = System_reponse_matrix(i,N_start+1:N_start+N_total)';
    % Perform regression to obtain the estimated coefficients
    Coeff_vector = leastSquaresSolver(Basis_matrix, Target_signal);
    % record the coefficients as a row in the matrix
    Coeff_matrix(i,:) = Coeff_vector;

    approximated_response = Basis_matrix*Coeff_vector;

    % Calculate the MSE of the approximation
    MSE = mean((Target_signal - approximated_response).^2);
    % Calculate the variance of the target system response
    Variance = var(Target_signal);
    % Calculate the NMSE of the approximation
    NMSE = MSE / Variance;
    NMSE_array(i) = NMSE;

    % Calculate the differences in approximation, extract the remaining
    % nonlinear part, and rescale it with respect to its linear
    % coefficient. This rescaling ensures the coefficient of its linear
    % term to be 1, for easy calculation later.
    response_diff_matrix(i,:) = (Target_signal - approximated_response)/Coeff_vector(2);
    
end

end