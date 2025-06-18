%%
clear
close all
clc

%% load the matrices that contains physics-to-metric information

% For our case, we arrange the four metrics with respect to the two control
% parameters (lambda_bar and sigma_lambda) as four 2 by 2 matrices.
% We perform approximations regarding these matrices as functions of these
% control parameters.
load NL_mean_matrix.mat
load NL_std_matrix.mat
load MEM_mean_matrix.mat
load MEM_std_matrix.mat

%% Specify the range of control paramters.
damping_average = 0.15:0.05:0.4;
damping_spread = 0.05:0.05:0.25;

%% Perform least-squares regression to estimation the governing relationships.

% code arranged according to each metric.
% Here, metric number 1: nonlinearity average, 2: memory average,
% 3:nonlinearity SD, and 4: memory SD
Metric_number = 4;

% In picking the polynomial terms to fit the relationships,
% we find the optimal ones by exhaustive search, where we attempt to use 
% minimum terms to approximate the governing relationships while
% maintaining low NMSE.

if Metric_number == 1 % Nonlinearity average
    [x, y] = meshgrid(0.05:0.05:0.25, 0:0.05:0.25); % x: damping spread, y: damping average
    F_matrix = NL_mean_matrix(1:5,1:6)';
    x = x(:); % Convert x to column vector
    y = y(:); % Convert y to column vector
    X = [ones(size(x)), y.^2]; 

elseif Metric_number == 2 % Memory average
    [x, y] = meshgrid(0.05:0.05:0.25, -0.25:0.05:0);
    F_matrix = MEM_mean_matrix(1:5,1:6)';
    x = x(:); % Convert x to column vector
    y = y(:); % Convert y to column vector
    X = [ones(size(x)),y.^2];

elseif Metric_number == 3 % Nonlinearity SD
    [x, y] = meshgrid(0.05-0.05:0.05:0.25-0.05, 0.15-0.15:0.05:0.4-0.15); 
    F_matrix = NL_std_matrix(1:5,1:6)';
    x = x(:); % Convert x to column vector
    y = y(:); % Convert y to column vector
    X = [ones(size(x)),x.*(0.1939*ones(size(x))+9.0768*y.^2)]; % here, the second term contains the approximated nonlinearity average
 
elseif Metric_number == 4 % Memory SD
    [x, y] = meshgrid(0.05+1:0.05:0.25+1, -0.25:0.05:0); 
    F_matrix = MEM_std_matrix(1:5,1:6)';
    x = x(:); % Convert x to column vector
    y = y(:); % Convert y to column vector
    X = [ones(size(x)),x.*(0.2394*ones(size(x))+2.1230*y.^2)]; % here, the second term contains the approximated memory average
end


% discard the last entry that is not physical
F = F_matrix(:);
F = F(1:end-1);
X = X(1:29,:);

% least square fitting
coeffs = X \ F

% display fitting coefficients
disp('Quadratic fit coefficients [a0, a1, a2, a3, a4, a5]:');
disp(coeffs);

% generate fitted values for visualization
F_fit = X * coeffs;
F_fit = [F_fit;0];
F_fit_matrix = reshape(F_fit,[6,5]);

% fill in the last entry with NaN to avoid weird plots
F_fit_matrix(6,5) =NaN;
F_matrix(6,5) =NaN;

% calculate the fitting NMSE
nmse = sum((F - X * coeffs).^2) / sum(F.^2);

% Display NMSE
disp('Normalized Mean Squared Error (NMSE):');
disp(nmse);


%% Plot the figures for both experimental results and approximations
figure;
surf(damping_average,damping_spread, F_matrix', 'FaceAlpha', 0.1,'LineWidth',1.5); 
hold on;
mesh(damping_average,damping_spread, F_fit_matrix','FaceAlpha', 0,'LineWidth',1.5,'LineStyle','--');
colormap winter;
% legend({'Experiment', 'Estimated'});
hold off;
if Metric_number == 1
    ylabel('$\sigma_{\lambda}$','Interpreter', 'latex','FontSize',17); xlabel('$\bar{\lambda}$','Interpreter', 'latex','FontSize',17); 
    zlabel('$\bar{\mathcal{N}}$','Interpreter', 'latex','FontSize',17);
elseif Metric_number == 2
    ylabel('$\sigma_{\lambda}$','Interpreter', 'latex','FontSize',17); xlabel('$\bar{\lambda}$','Interpreter', 'latex','FontSize',17); 
    zlabel('$\bar{\mathcal{M}}$','Interpreter', 'latex','FontSize',17);
    % zlim([0,5.05])
elseif Metric_number == 3
    ylabel('$\sigma_{\lambda}$','Interpreter', 'latex','FontSize',17); xlabel('$\bar{\lambda}$','Interpreter', 'latex','FontSize',17); 
    zlabel('$\sigma_{\mathcal{N}}$','Interpreter', 'latex','FontSize',17);
    zlim([0.03,0.3])
elseif Metric_number == 4
    ylabel('$\sigma_{\lambda}$','Interpreter', 'latex','FontSize',17); xlabel('$\bar{\lambda}$','Interpreter', 'latex','FontSize',17); 
    zlabel('$\sigma_{\mathcal{M}}$','Interpreter', 'latex','FontSize',17);
end
% xticks([0.15,0.2,0.25,0.3,0.35,0.4])
% xlim([0.12,0.42])
% yticks([0.05,0.1,0.15,0.2,0.25])
% ylim([0.03,0.27])
