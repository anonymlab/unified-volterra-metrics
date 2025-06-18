function [NL_average,MEM_average,NL_SD,MEM_SD] = Metrics_computation(Coeff_matrix,P,K,Exponent_matrix)
% This function computes the metrics according to our definitions.
% Here, we note that the linear memoryless term is rescaled to have a
% coefficient of 1, as a consequence of previous normalization.
% Coeff_matrix: estimated full Volterra kernel coefficients.
% P: maximum polynomial order
% K: maximum memory depth
% Exponent_matrix: generated in the estimation process, which helps to
% identify elements used for metric calculations.
% The function outputs the four metrics accordingly:
% NL_average: Nonlinearity average
% MEM_average: Memory average
% NL_SD: Nonlinearity SD
% MEM_SD: Memory SD


%%
% read the total number of system responses
N_Response = size(Coeff_matrix, 1);

% create arrays and matrixs for use
NL_measure_array = zeros(N_Response,1);
NL_measure_matrix = zeros(N_Response,P);
MEM_measure_array = zeros(N_Response,1);
MEM_measure_matrix = zeros(N_Response,K+1);

% Calculate nonlinearity and memory measures for each system response.
for i = 1:N_Response
    NL_measure_orders = zeros(P,1);
    for p = 1:P
        NL_measure_orders(p) = NL_measure_porder_compute(Coeff_matrix(i,:),p,Exponent_matrix);
    end
    NL_measure_matrix(i,:) = NL_measure_orders;
    
    MEM_measure_orders = zeros(K,1);
    for k = 0:K
        MEM_measure_orders(k+1) = MEM_measure_porder_compute(Coeff_matrix(i,:),k,Exponent_matrix);
    end
    MEM_measure_matrix(i,:) = MEM_measure_orders;

    NL_power = 0;
    for p = 2:P
        NL_power = NL_power + p*(NL_measure_orders(p)/(1+NL_measure_orders(1))).^2;
    end
    NL_measure = sqrt(NL_power);

    MEM_power = 0;
    for k = 1:K
        MEM_power = MEM_power + k*(MEM_measure_orders(k+1)/(1+MEM_measure_orders(1))).^2;
    end
    MEM_measure = sqrt(MEM_power);

    NL_measure_array(i) = NL_measure;
    MEM_measure_array(i) = MEM_measure;

end

% compute their averages and SDs as global metrics
NL_average = mean(NL_measure_array);
MEM_average = mean(MEM_measure_array);
NL_SD = std(NL_measure_array);
MEM_SD = std(MEM_measure_array);

end