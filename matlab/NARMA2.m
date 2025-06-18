
clear
close all
clc

%% Input parameters

% load the input data and system response to be used for the task
load input_data.mat
load system_response.mat

% specify discarding, training and testing lengths
N_discard = 100;
N_train = 4000;
N_test = 1500;


%% Compute target signal for NARMA2
NARMA_target = zeros(1,6000);
NARMA_target(1) = 0.4*0 + 0.4*0*0 +0.6*0^3 + 0.1;
NARMA_target(2) = 0.4*NARMA_target(1) + 0.4*NARMA_target(1)*0 +0.6*randomArray(1)^3 + 0.1;

for i = 3:6000
    NARMA_target(i) = 0.4*NARMA_target(i-1) + 0.4*NARMA_target(i-1)*NARMA_target(i-2) +0.6*randomArray(i-1)^3 + 0.1;
end


%%
% read the total number of system responses
N_Response = size(response_matrix_final, 1);

% specify matrix for training and testing
ResOut_matrix = response_matrix_final;
ResOut_train = ResOut_matrix(:,N_discard+1:N_discard+N_train);
ResOut_test = ResOut_matrix(:,N_discard+N_train+1:N_discard+N_train+N_test);

% specify target signals for training and testing
target_train = NARMA_target(N_discard+1:N_discard+N_train);
target_test = NARMA_target(N_discard+N_train+1:N_discard+N_train+N_test);

% Least-squares training
weight_vector = leastSquaresSolver(ResOut_train', target_train');
readout_train = ResOut_train'*weight_vector;
readout_test = ResOut_test'*weight_vector;

% Calculate the Mean Squared Error (MSE)
mse_test = mean((target_test - readout_test').^2);
mse_train = mean((target_train - readout_train').^2);

% Calculate the variance of the target signal
variance_d_test = var(target_test);
variance_d_train = var(target_train);

% Calculate the Normalized Mean Squared Error (NMSE)
nmse_train = mse_train / variance_d_train;
nmse_test = mse_test / variance_d_test;

display(nmse_train)
display(nmse_test)

%% Plot 200 time steps of target and output signals for examples
plot(target_test(201:400),Color='black')
hold on;
plot(readout_test(201:400),Color='red')
xlabel('Discrete-time step')
ylabel('Signal level')
legend('Target output','System output','FontSize', 12) 