% This is a MATLAB script that is used to generate the Mumax3 code for the 
% input of applied magnetic field (i.e., input signal).

% This function will generate a text file that contains the appropriate
% Mumax3 code for the simulation of input fields for the spintronic reservoir.


clear
close all
clc

%% Input parameters
rng(1010) % assign a random seed.

% discrete-time data settings
N_length = 6000; % define the length of the input data
values = [0.05, 0.15, 0.25, 0.35, 0.45]; % define the possible values of the input data.

% discrete to continuous time conversion parameters
f_c = 20; % frequency of the oscillatory magnetic field (in GHz)
T_number = 1; % number of periods modulated for each discrete-time data symbols.
time_step = 0.01; % interpolation time step.

%% Generate the discrete-time input data signals
Save_file_name = 'input_data.mat';
randomArray = randsample(values, N_length, true);
% save the discrete-time input signal data.
save(Save_file_name,"randomArray")

%% Convert discrete-time symbols to continuous-time field values

T_c = 1/f_c/time_step; % ompute number of interplolated time steps for one continuous-time period.
T_symbol = T_number*T_c; % compute number of interplolated time steps for one continuous-time symbol.

tt = 0:0.01:0.01*N_length*T_symbol; % define the total continuous-time array.

% amplitude modulation by sine waves.
Cont_input_signal = zeros(1,N_length/f_c/time_step);
for i = 1:N_length
    for j = 1:T_symbol
        Cont_input_signal((i-1)*T_symbol + j) = randomArray(i) * sin(2*pi*f_c*tt((i-1)*T_symbol + j));
    end
end


%% Differentiation to obtain appropriate magnetic field

H_input = normalize(diff(Cont_input_signal));

%% Figure plots for check

figure;
plot(randomArray)
xlabel('discrete time step')
ylabel('signal level')
title('Discrete-time signal')

figure;
plot(Cont_input_signal)
xlabel('continuous time (ns)')
ylabel('signal level')
title('Continuous-time signal after modulation')


%% Write the script of input magnetic field for Mumax3 simulation.

% Open the text file for writing
fileID = fopen('input_magnetic_field.txt', 'w');
for i = 1:length(tt)-3
    H_diff = H_input(i+1)-H_input(i);
    delta_t = 0.01e-9;
    H_grad = H_diff/delta_t;
    H_bias = H_input(i)-H_grad*tt(i)*1e-9;
    fprintf(fileID, 't = %fe-9\n', tt(i));
    fprintf(fileID, 'B_ext = vector(0, 0, B_in*(%f*t+(%f)))\n', H_grad,H_bias);
    fprintf(fileID, 'tableautosave(1e-11)\n');
    fprintf(fileID, 'run(0.01e-9)\n\n');
end

fclose(fileID);
