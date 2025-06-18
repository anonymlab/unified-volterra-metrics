% This is a MATLAB script that is used to generate the desired damping
% distribution for the Mumax3 simulation of the spintronic reservoir.

% This function will generate a text file that contains the appropriate
% Mumax3 code for the simulation of damping distributions for the
% spintronic reservoir.

clear
close all
clc

%% Input parameters 
% M: number of subregions along one side (i.e.,total subregions are M by M)
% lambda_ave: damping factor average (one control parameter)
% lambda_spread: damping factor spread (the other control parameter)

rng(1010); % assign a random seed.
M = 10;
lambda_ave = 0.4; 
lambda_spread = 0.05;

%% Generation of random damping distributions
lambda_matrix = lambda_ave * ones(M,M); % initialize the lambda_matrix according to the average value.
eta_matrix = lambda_spread * (rand(M) - 0.5); % generate a random eta matrix to introduce variations.
lambda_matrix = lambda_matrix + eta_matrix;

alpha_matrix = zeros(M,M); % create an empty matrix to record the values of Gilbert damping constant alpha. 
for i = 1:M
    for j = 1:M
        alpha_matrix(i,j) = (1 - sqrt(1-4*lambda_matrix(i,j)*lambda_matrix(i,j)))/2/lambda_matrix(i,j); 
        % convert damping factor lambda to Gilbert damping constant alpha according to their relations.
    end
end

%% Plot the lambda distribution
figure
imagesc(lambda_matrix,[0,0.5])
colormap(turbo)

% Get the current colormap
currentColormap = colormap;

% Reverse the order of the colormap
reversedColormap = flipud(currentColormap);

% Apply the reversed colormap
colormap(reversedColormap);

colorbar
title('Lambda distribution')

%% Plot the alpha distribution after conversion
figure
imagesc(alpha_matrix,[0,1])
colormap autumn

% Get the current colormap
currentColormap = colormap;

% Reverse the order of the colormap
reversedColormap = flipud(currentColormap);

% Apply the reversed colormap
colormap(reversedColormap);

colorbar
title('Alpha distribution')


%% write the script that is used in the Mumax3 code.

fileID = fopen('Damping_distribution.txt', 'w');
for i = 1:M
    for j = 1:M
        label = M*(i-1)+j;
        label_number = M*(i-1)+j;
        y_trans = -4.5/10 + 1/10*(i-1);
        x_trans = -4.5/10 + 1/10*(j-1);
        fprintf(fileID, 'region_%d:=rect(1/10*sizeX,1/10*sizeY).transl(%f*sizeX,%f*sizeY,0)\n', label,x_trans,y_trans);
        fprintf(fileID, 'defregion(%d,region_%d)\n', label_number,label);
        fprintf(fileID, 'alpha.setregion(%d,%f)\n', label_number,alpha_matrix(i,j));
    end
end

fclose(fileID);
