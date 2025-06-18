function [Coeff_matrix,Exponent_matrix,approximated_response,NMSE_array] = Volterra_series_approximation_full(K,P,L,N_start,N_end,Input_data_array,System_reponse_matrix)
% This function performs Volterra-series approximation based on simple
% least-squares method. It involves the following input parameters:
% K: Maximum memory depth
% P: Maximum polynomial order
% L: Maximum non-zero exponent (as a constraint to simplify the
% approximation)
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
% approximated_response: obtained approximation of the system response
% NMSE_array: an array recording the NMSEs of this approximation for each
% system response.

%% Generate possible arrangements of exponents based on provided parameters

% initialize an empty exponent matrix.
Exponent_matrix = [];

% iterate the exponent arrangment process for all p = 1 to P.
for p = 1:P
    % use the defined exponent function to find possible exponent vectors.
    exponent_array_constrain = exponent_arranger_with_constraint(p, K, L);
    % concatenate the matrix for all order p;
    Exponent_matrix = [Exponent_matrix;exponent_array_constrain];
end


%% Construct the regression matrix for monomial bases

N_total = N_end-N_start; % compute the total time steps for approximation

Basis_matrix = zeros(N_total, length(Exponent_matrix));

% Each monomial basis is computed as one row of the regression matrix.
for i = 1:length(Exponent_matrix)
    basis_temp = ones(N_total,1);
    % We iteratively multiply individual bases according to the generated 
    % exponent vectors.
    for k = 0:K
        if Exponent_matrix(i,k+1) ~=0
            basis_temp = basis_temp.*((Input_data_array(N_start+1-k:N_start+N_total-k))'.^(Exponent_matrix(i,k+1)));
        end
    end
    
    % normalization is performed to ensure comparison fairness
    Basis_matrix(:,i) = normalize(basis_temp);
end

% disable the linear memoryless term since it has been done.
Basis_matrix(:,K+1) = zeros(N_total,1);

%% Perform least-squares regression to compute the Volterra kernel coefficients

% read the total number of system responses
N_Response = size(System_reponse_matrix, 1);
% initialize a coefficient matrix
Coeff_matrix = zeros(N_Response,(K+1) * P);
% initialize an NMSE array
NMSE_array = zeros(N_Response,1);


% iterate for each system response for approximation.
for i = 1:N_Response
    % Define the target signal of this regression
    Target_signal = System_reponse_matrix(i,:)';
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
end

end