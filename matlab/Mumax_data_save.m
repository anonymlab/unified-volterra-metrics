clc
clear all
close all

% This MATLAB file converts the simulated Mumax3 spin responses to MATLAB 
% readable data.

%% Input parameters

Total_time_steps = 29995; % provide the total continuous time length (in ns) of the simulation
time_interval = 0.01e-9; % used sampling time interval, in second.
Result_file_name = 'results.txt'; % use the appropriate file name of the Mumax3 result.
Save_file_name = 'results.mat'; % provide the final data file name.
Code_case = 3; % provide the code case number according to Mumax3 code (i.e., 1, 2, or 3).

%% Extract the results and arrange them into matrix form.

% read the data
fileID = fopen(Result_file_name,'r');

formatSpec = '%f' ;
Output_total = (fscanf (fileID, formatSpec))';


if Code_case == 1
    output_number = 140; 
elseif Code_case == 2
    output_number = 140; 
elseif Code_case == 3
    output_number = 120; 
end

% total index include all three components of spins (x, y, and z).
total_index = 3*(output_number+1)+2;

% first extract the time step vector from the results.
time_vector = Output_total(1:total_index:end);

% create a response matrix to record all system responses. 
response_matrix = zeros(output_number+1,length(time_vector));

% The first row of this matrix is for the time vector.
response_matrix(1,:) = time_vector;

% The other rows record the z component of spin responses.
for i = 1:output_number
    response_matrix(i+1,:) = Output_total(4+3*i:total_index:end);
end

%% Remove repeated or empty sampled data in the Mumax3 results 

% Get the first row
first_row = response_matrix(1, :);

% Initialize a logical array to mark columns to be removed
columns_to_remove = false(1, size(response_matrix, 2));

% Iterate over each element in the first row
for i = 1:length(first_row)
    % Check if the current element has appeared before in the first row
    if sum(first_row(1:i - 1) == first_row(i)) > 0
        % Mark the corresponding column to be removed
        columns_to_remove(i) = true;
    end
end

% Remove columns marked for removal
response_matrix(:, columns_to_remove) = [];

%% Redo the time interpolation to make the time intervals uniform.
tt_old = response_matrix(1,:);
tt_new = 0:time_interval:Total_time_steps*time_interval;
response_matrix_new = zeros(output_number,length(tt_new));
for i = 1:output_number
    response_matrix_new(i,:) = interp1(tt_old,response_matrix(i+1,:),tt_new);
end

%% record the data in MATLAB data format.

response_matrix_final = response_matrix_new;
save(Save_file_name,"response_matrix_final")
