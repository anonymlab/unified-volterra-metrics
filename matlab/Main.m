%%
clear
close all
clc

%% load your saved input data and system response data
load input_data.mat % modify the name according to the saved data file.
load system_response.mat % modify the name according to the saved data file.

%% Input parameters
% Define maximum polynomial order and memory depth
K = 6;  % Memory depth
P = 10;  % Polynomial order
L = 1; % Maximum non-zero exponent (to remove cross terms)

N_start = 1000; % specify the starting time step for analysis.
N_end = 5800; % specify the total number of time steps for analysis.

% linear order approximation first to enhance approximation accuracy
[Coeff_matrix_linear,response_diff_matrix,NMSE_array_linear] = Volterra_series_approximation_linear(N_start,N_end,randomArray,response_matrix_final);

% compute the differences in linear order approximation
Input_data_array= randomArray;
System_reponse_matrix=response_diff_matrix;

% perform full series approximation to obtain estimated coefficients
[Coeff_matrix,Exponent_matrix,NMSE_array] = Volterra_series_approximation_full(K,P,L,N_start,N_end,randomArray,response_diff_matrix);

% use estimated coefficients together with exponent matrix to compute the
% metrics
[NL_average,MEM_average,NL_SD,MEM_SD] = Metrics_computation(Coeff_matrix,P,K,Exponent_matrix)