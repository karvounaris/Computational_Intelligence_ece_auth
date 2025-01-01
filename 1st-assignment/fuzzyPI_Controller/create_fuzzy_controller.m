% Author: Panagiotis Karvounaris
% University ID: 10193

close all;
clear;
clc;

% Create a new FIS system
fis = mamfis('Name', 'FuzzyController', 'AndMethod', 'min', 'OrMethod', 'max', ...
             'ImplicationMethod', 'prod', 'DefuzzificationMethod', 'centroid');

% Set inputs
fis = addInput(fis, [-1 1], 'Name', 'E'); % error E 
fis = addInput(fis, [-1 1], 'Name', 'dE'); % change of error dE

% Set outputs
fis = addOutput(fis, [-1 1], 'Name', 'dU'); % change of control input dU

% Set oral variables for E
fis = addMF(fis, 'E', 'trimf', [-1 -1 -0.666666], 'Name', 'NL'); % NL
fis = addMF(fis, 'E', 'trimf', [-1 -0.666666 -0.333333], 'Name', 'NM'); % NM
fis = addMF(fis, 'E', 'trimf', [-0.666666 -0.333333 0], 'Name', 'NS'); % NS
fis = addMF(fis, 'E', 'trimf', [-0.333333 0 0.333333], 'Name', 'ZR'); % ZR
fis = addMF(fis, 'E', 'trimf', [0 0.333333 0.666666], 'Name', 'PS'); % PS
fis = addMF(fis, 'E', 'trimf', [0.333333 0.666666 1], 'Name', 'PM'); % PM
fis = addMF(fis, 'E', 'trimf', [0.666666 1 1], 'Name', 'PL'); % PL

% Set oral variables for dE
fis = addMF(fis, 'dE', 'trimf', [-1 -1 -0.666666], 'Name', 'NL'); % NL
fis = addMF(fis, 'dE', 'trimf', [-1 -0.666666 -0.333333], 'Name', 'NM'); % NM
fis = addMF(fis, 'dE', 'trimf', [-0.666666 -0.333333 0], 'Name', 'NS'); % NS
fis = addMF(fis, 'dE', 'trimf', [-0.333333 0 0.333333], 'Name', 'ZR'); % ZR
fis = addMF(fis, 'dE', 'trimf', [0 0.333333 0.666666], 'Name', 'PS'); % PS
fis = addMF(fis, 'dE', 'trimf', [0.333333 0.666666 1], 'Name', 'PM'); % PM
fis = addMF(fis, 'dE', 'trimf', [0.666666 1 1], 'Name', 'PL'); % PL

% Set oral variables for dU
fis = addMF(fis, 'dU', 'trimf', [-1 -1 -0.75], 'Name', 'NV'); % NV
fis = addMF(fis, 'dU', 'trimf', [-1 -0.75 -0.5], 'Name', 'NL'); % NL
fis = addMF(fis, 'dU', 'trimf', [-0.75 -0.5 -0.25], 'Name', 'NM'); % NM
fis = addMF(fis, 'dU', 'trimf', [-0.5 -0.25 0], 'Name', 'NS'); % NS
fis = addMF(fis, 'dU', 'trimf', [-0.25 0 0.25], 'Name', 'ZR'); % ZR
fis = addMF(fis, 'dU', 'trimf', [0 0.25 0.5], 'Name', 'PS'); % PS
fis = addMF(fis, 'dU', 'trimf', [0.25 0.5 0.75], 'Name', 'PM'); % PM
fis = addMF(fis, 'dU', 'trimf', [0.5 0.75 1], 'Name', 'PL'); % PL
fis = addMF(fis, 'dU', 'trimf', [0.75 1 1], 'Name', 'PV'); % PV

% Set fuzzy rules
rules = [
    "If E is NL and dE is NL then dU is NV"
    "If E is NL and dE is NM then dU is NV"
    "If E is NL and dE is NS then dU is NV"
    "If E is NL and dE is ZR then dU is NL"
    "If E is NL and dE is PS then dU is NM"
    "If E is NL and dE is PM then dU is NS"
    "If E is NL and dE is PL then dU is ZR"
    "If E is NM and dE is NL then dU is NV"
    "If E is NM and dE is NM then dU is NV"
    "If E is NM and dE is NS then dU is NL"
    "If E is NM and dE is ZR then dU is NM"
    "If E is NM and dE is PS then dU is NS"
    "If E is NM and dE is PM then dU is ZR"
    "If E is NM and dE is PL then dU is PS"
    "If E is NS and dE is NL then dU is NV"
    "If E is NS and dE is NM then dU is NL"
    "If E is NS and dE is NS then dU is NM"
    "If E is NS and dE is ZR then dU is NS"
    "If E is NS and dE is PS then dU is ZR"
    "If E is NS and dE is PM then dU is PS"
    "If E is NS and dE is PL then dU is PM"
    "If E is ZR and dE is NL then dU is NL"
    "If E is ZR and dE is NM then dU is NM"
    "If E is ZR and dE is NS then dU is NS"
    "If E is ZR and dE is ZR then dU is ZR"
    "If E is ZR and dE is PS then dU is PS"
    "If E is ZR and dE is PM then dU is PM"
    "If E is ZR and dE is PL then dU is PL"
    "If E is PS and dE is NL then dU is NM"
    "If E is PS and dE is NM then dU is NS"
    "If E is PS and dE is NS then dU is ZR"
    "If E is PS and dE is ZR then dU is PS"
    "If E is PS and dE is PS then dU is PM"
    "If E is PS and dE is PM then dU is PL"
    "If E is PS and dE is PL then dU is PV"
    "If E is PM and dE is NL then dU is NS"
    "If E is PM and dE is NM then dU is ZR"
    "If E is PM and dE is NS then dU is PS"
    "If E is PM and dE is ZR then dU is PM"
    "If E is PM and dE is PS then dU is PL"
    "If E is PM and dE is PM then dU is PV"
    "If E is PM and dE is PL then dU is PV"
    "If E is PL and dE is NL then dU is ZR"
    "If E is PL and dE is NM then dU is PS"
    "If E is PL and dE is NS then dU is PM"
    "If E is PL and dE is ZR then dU is PL"
    "If E is PL and dE is PS then dU is PV"
    "If E is PL and dE is PM then dU is PV"
    "If E is PL and dE is PL then dU is PV"
];

fis = addRule(fis, rules);

fis.DefuzzMethod = 'centroid'; % Center of Sums (COS)

fis.ImpMethod = 'prod'; % Use product for implication

% Save the FIS to a .fis
writeFIS(fis, 'FuzzyController.fis');

disp('Fuzzy Controller has been saved as FZ_PI_Controller.fis');

FuzzyController = readfis('FuzzyController.fis');
save('FuzzyController','FuzzyController')

%% Plot Section
% Plot membership functions for input 'E'
figure;
plotmf(fis, 'input', 1);
title('Membership Functions of Input E');

% Plot membership functions for input 'dE'
figure;
plotmf(fis, 'input', 2);
title('Membership Functions of Input dE');

% Plot membership functions for output 'dU'
figure; 
plotmf(fis, 'output', 1);
title('Membership Functions of Output dU');

%% Results
% Plot the surface view of the FIS
figure;
gensurf(fis); % Generate a surface plot for the FIS
title('Fuzzy Inference System Surface View');
xlabel('Input E');
ylabel('Input dE');
zlabel('Output dU');

%% Plot 2D grid of the rules
% Define the fuzzy sets and corresponding indices for the grid
E_labels = {'NL', 'NM', 'NS', 'ZR', 'PS', 'PM', 'PL'};
dE_labels = {'NL', 'NM', 'NS', 'ZR', 'PS', 'PM', 'PL'};
dU_labels = {'NV', 'NL', 'NM', 'NS', 'ZR', 'PS', 'PM', 'PL', 'PV'};

% Create a matrix for the grid representing rules
rule_matrix = [
    5 6 7 8 9 9 9;  % PL
    4 5 6 7 8 9 9;  % PM
    3 4 5 6 7 8 9;  % PS
    2 3 4 5 6 7 8;  % ZR
    1 2 3 4 5 6 7;  % NS
    1 1 2 3 4 5 6;  % NM
    1 1 1 2 3 4 5;  % NL
];

% Create a figure
figure;
imagesc(rule_matrix);  % Display the rule matrix as an image
colormap(jet(9));      % Use a colormap with 9 colors

% Add labels and title
set(gca, 'XTick', 1:length(E_labels), 'XTickLabel', E_labels); % X-axis labels
set(gca, 'YTick', 1:length(dE_labels), 'YTickLabel', flip(dE_labels)); % Flipped Y-axis labels
xlabel('Error (E)');
ylabel('Change of Error (dE)');
title('Fuzzy Control Rules Visualization');

% Add colorbar with output labels
c = colorbar;
c.Ticks = 1:9;
c.TickLabels = dU_labels;

% Add grid lines
grid on;
axis equal;

%% Evaluation
% Example input values
input_values = [-0.5, 0.5]; % Example inputs [E, dE]

% Evaluate FIS
output = evalfis(fis, input_values);

% Display the output
disp(['Output for E = ' num2str(input_values(1)) ' and dE = ' num2str(input_values(2)) ': dU = ' num2str(output)]);

%% Create input function for scenario 2
% % Define time and signal values for the step signal (from the previous image)
% time_step = [0 5 10 15];  % Time points (in seconds)
% signal_step = [50 20 40 40];  % Corresponding signal values at each time point
% 
% % Create a timeseries object for the step signal
% a_step = timeseries(signal_step, time_step);
% 
% % Create a Dataset object and assign the step timeseries to it
% Step = Simulink.SimulationData.Dataset;
% Step = Step.addElement(a_step, 'a');  % Name the step timeseries 'a'
% 
% % Define time and signal values for the ramp signal (from the new image)
% time_ramp = [0 5 10 20];  % Time points (in seconds)
% signal_ramp = [0.4 50 50 0];  % Corresponding signal values (rad/sec)
% 
% % Create a timeseries object for the ramp signal
% b_ramp = timeseries(signal_ramp, time_ramp);
% 
% % Create a Dataset object and assign the ramp timeseries to it
% Ramp = Simulink.SimulationData.Dataset;
% Ramp = Ramp.addElement(b_ramp, 'b');  % Name the ramp timeseries 'b'
% 
% % Save both Dataset objects (Step and Ramp) in a .mat file
% save('signals_scenario_2.mat', 'Step', 'Ramp');


