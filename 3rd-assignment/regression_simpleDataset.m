% Author: Panagiotis Karvounaris
% University ID: 10193

close all;
clear;
clc;

if exist('regression_simpleDataset_logs.txt', 'file')
    delete('regression_simpleDataset_logs.txt');
end
feature('HotLinks', 0);
diary regression_simpleDataset_logs.txt

% Import dataset
dataset = importdata('airfoil_self_noise.dat');

% Dataset split 60-20-20
[trainData, validationData, testData] = split_scale(dataset, 1);
trainTargetData = trainData(:, end);
validationTargetData = validationData(:, end);
testTargetData = testData(:, end);

model_names = {};
%%  ============ MODELS =================
%   ( Initializing the requested models )
model_names{1} = 'TSK_model_1';
FISoptions(1) = genfisOptions('GridPartition'); % We want the fuzzy rule base to contain 1 rule for each input MF combination.
FISoptions(1).InputMembershipFunctionType = 'gbellmf';  % For bell-shaped MFS
FISoptions(1).NumMembershipFunctions = 2;
FISoptions(1).OutputMembershipFunctionType = 'constant'; % Singleton
initialFIS(1) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(1));

model_names{2} = 'TSK_model_2';
FISoptions(2) = genfisOptions('GridPartition'); % We want the fuzzy rule base to contain 1 rule for each input MF combination.
FISoptions(2).InputMembershipFunctionType = 'gbellmf'; % For bell-shaped MFS
FISoptions(2).NumMembershipFunctions = 3;
FISoptions(2).OutputMembershipFunctionType = 'constant'; % Singleton
initialFIS(2) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(2));

model_names{3} = 'TSK_model_3';
FISoptions(3) = genfisOptions('GridPartition'); % We want the fuzzy rule base to contain 1 rule for each input MF combination.
FISoptions(3).InputMembershipFunctionType = 'gbellmf'; % For bell-shaped MFS
FISoptions(3).NumMembershipFunctions = 2;
FISoptions(3).OutputMembershipFunctionType = 'linear'; % Polynomial
initialFIS(3) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(3));

model_names{4} = 'TSK_model_4';
FISoptions(4) = genfisOptions('GridPartition'); % We want the fuzzy rule base to contain 1 rule for each input MF combination.
FISoptions(4).InputMembershipFunctionType = 'gbellmf'; % For bell-shaped MFS
FISoptions(4).NumMembershipFunctions = 3;
FISoptions(4).OutputMembershipFunctionType = 'linear'; % Polynomial
initialFIS(4) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(4));
%  ====================================
numOfModels = length(initialFIS);

metrics_names = {'MSE', 'RMSE', 'NMSE', 'NDEI', 'R2'};
metrics = nan(length(metrics_names), numOfModels);

% FIS Options
ANFISoptions = anfisOptions;
ANFISoptions.ValidationData = validationData;
ANFISoptions.EpochNumber = 100;
for i = 1:numOfModels
    % ANFIS (Train of model)
    ANFISoptions.InitialFIS = initialFIS(i);
    [~, trainError(:, i), ~, validationFIS(i), validationError(:, i)] = anfis(trainData, ANFISoptions);

    % Input's membership functions (1)
    for j = 1:size(trainData, 2) - 1
        figure;
        plotmf(validationFIS(i), 'input', j);
        xlabel(['Input ' num2str(j)], 'Interpreter', 'latex')
        ylabel('Degree of Membership', 'Interpreter', 'latex')
        title(['Input ' int2str(j)], 'Interpreter', 'latex');
        subtitle(['TSK\_model\_' num2str(i)], 'Interpreter','latex');
        % saveas(gcf,['.\figures\simpleDataset\TSK_model_' num2str(i) '\TSK_model_' num2str(i) '_input_' num2str(j) '.png'])
    end

    % Learning curve (2)
    figure;
    plot([trainError(:, i) validationError(:, i)]);
    grid on;
    xlabel('Number of Iterations', 'Interpreter', 'latex'); 
    ylabel('Error', 'Interpreter', 'latex');
    legend('Training Error', 'Validation Error', 'Interpreter', 'latex');
    title('\textbf{Learning Curve}', 'Interpreter','latex');
    subtitle(['TSK\_model\_' num2str(i)], 'Interpreter','latex');
    % saveas(gcf,['.\figures\simpleDataset\TSK_model_' num2str(i) '\TSK_model_' num2str(i) '_LearningCurve.png'])

    % Prediction Error (3)
    y_hat(:, i) = evalfis(validationFIS(i), testData(:, 1:end-1));
    predictionError(:, i) = y_hat(:, i) - testTargetData;
    figure;
    plot(predictionError(:, i)); 
    grid on;
    xlabel('Input', 'Interpreter', 'latex'); 
    ylabel('Error', 'Interpreter', 'latex');
    title('\textbf{Prediction Error}', 'Interpreter','latex');
    subtitle(['TSK\_model\_' num2str(i)], 'Interpreter','latex');
    % saveas(gcf,['.\figures\simpleDataset\TSK_model_' num2str(i) '\TSK_model_' num2str(i) '_PredictionError.png'])

    % Calculate the requested metrics (4)    
    metrics(1, i) = mse(y_hat(:, i), testTargetData);
    metrics(2, i) = RMSE(y_hat(:, i), testTargetData);
    metrics(3, i) = NMSE(y_hat(:, i), testTargetData); 
    metrics(4, i) = NDEI(y_hat(:, i), testTargetData); 
    metrics(5, i) = R2(y_hat(:, i), testTargetData);    
end

% Metrics Result (in matrix form)
disp(array2table(metrics, 'VariableNames', model_names, 'Rownames', metrics_names));

diary off % Turn off file logging
% save('regression_simpleDataset_Variables')