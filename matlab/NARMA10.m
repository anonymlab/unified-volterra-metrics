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


%% Compute target signal for NARMA10
NARMA_order = 10; % specify NARMA order
NARMA_target = zeros(1,6000);
NARMA_target(1) = 0.3*0 + 0.05*0 +1.5*0 + 0.1;
for i = 2:6000
    NAMRA_sum = 0;
    for j = 1:NARMA_order
        if i-j > 0
            temp = NARMA_target(i-j);
        else
            temp = 0;
        end
        NAMRA_sum = NAMRA_sum + temp;
    end

    if i-NARMA_order > 0
        temp2 = randomArray(i-NARMA_order);
    else
        temp2 = 0;
    end
    NARMA_target(i) = 0.3*NARMA_target(i-1) + 0.05*NARMA_target(i-1)*NAMRA_sum +1.5*temp2*randomArray(i-1) + 0.1;
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

