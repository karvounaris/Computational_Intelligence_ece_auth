% Author: Panagiotis Karvounaris
% University ID: 10193

close all;
clear;
clc;

if exist('regression_highDimDataset_optimalVals_logs.txt', 'file')
    delete('regression_highDimDataset_optimalVals_logs.txt');
end
feature('HotLinks', 0);
diary regression_highDimDataset_optimalVals_logs.txt

%% Found using the minima of MSE on the 3D-plot
optimalNumOfFeatures = 6;
optimalclusterRadius = 0.25;
% ---------------------------------------------

% We basically run the script of the grid search one more time,
% but for constant values of number of features and cluster radius
% Import data from grid search session
load('regression_highDimDataset_gridSearch_Variables');
optimalTrainData = [trainData(:, importanceIndexes(1:optimalNumOfFeatures)) trainTargetData];
optimalValidationData = [validationData(:, importanceIndexes(1:optimalNumOfFeatures)) validationTargetData];
optimalTestData = [testData(:, importanceIndexes(1:optimalNumOfFeatures)) testTargetData];

ifThenRules_teamMethod = 'SubtractiveClustering'; %  We have to cluster input data using subtractive clustering 
optimalFISoptions = genfisOptions(ifThenRules_teamMethod, 'ClusterInfluenceRange', optimalclusterRadius);
optimalInitialFIS = genfis(optimalTrainData(:, 1:end-1), trainTargetData, optimalFISoptions);

%% Plotting
% Plot Membership Functions (BEFORE TRAIN PROCESS)
numberOfInputs = length(optimalInitialFIS.input);
for i = 1:numberOfInputs
    figure;
    plotmf(optimalInitialFIS, 'input', i);
    xlabel(['Input ' num2str(i)], 'Interpreter', 'latex')
    ylabel('Degree of Membership', 'Interpreter', 'latex')
    title(['Input ' int2str(i)], 'Interpreter', 'latex');
    subtitle('Before train process', 'Interpreter','latex');
    % saveas(gcf,['.\figures\highDimDataset\optimalValuesPlots\beforeTrain\input_' num2str(i) '.png'])
end

% FIS Options
opt_ANFISoptions = anfisOptions;
opt_ANFISoptions.InitialFIS = optimalInitialFIS;
opt_ANFISoptions.ValidationData = optimalValidationData;
opt_ANFISoptions.EpochNumber = 100;
% ANFIS (Train of model)
[optimalTrainedFIS, optimalTrainError, ~, optimalValidationFIS, optimalValidationError] = anfis(optimalTrainData, opt_ANFISoptions);

% Plot Membership Functions (AFTER TRAIN PROCESS)
numberOfInputs_trained = length(optimalTrainedFIS.input);
for i = 1:numberOfInputs_trained
    figure;
    plotmf(optimalTrainedFIS, 'input', i);
    xlabel(['Input ' num2str(i)], 'Interpreter', 'latex')
    ylabel('Degree of Membership', 'Interpreter', 'latex')
    title(['Input ' int2str(i)], 'Interpreter', 'latex');
    subtitle('After train process', 'Interpreter','latex');
    % saveas(gcf, ['.\figures\highDimDataset\optimalValuesPlots\afterTrain\input_' num2str(i) '.png'])
end

% Learning Curve
figure;
grid on;
plot([optimalTrainError, optimalValidationError]); 
legend('Training Error', 'Validation Error');
xlabel('Number of Iterations', 'Interpreter', 'latex'); 
ylabel('Error', 'Interpreter', 'latex');
legend('Training Error', 'Validation Error', 'Interpreter', 'latex');
title('\textbf{Learning Curve}', 'Interpreter','latex');
% saveas(gcf, '.\figures\highDimDataset\optimalValuesPlots\afterTrain\learningCurve.png')

% Plot prediction error (and prediction and real values separately)
optimal_y_hat = evalfis(optimalValidationFIS, optimalTestData(:, 1:end-1));
predictionError = optimal_y_hat - testTargetData;
% Real data values
figure;
scatter(1:length(testTargetData), testTargetData, 'Color', 'blue');
grid on;
xlabel('Input', 'Interpreter', 'latex'); 
ylabel('Real Data', 'Interpreter', 'latex');
% saveas(gcf, '.\figures\highDimDataset\optimalValuesPlots\afterTrain\realDataPlot.png')

% Predicted data values
figure;
scatter(1:length(optimal_y_hat), optimal_y_hat, 'Color', 'cyan');
grid on;
xlabel('Input', 'Interpreter', 'latex'); 
ylabel('Predicted Data', 'Interpreter', 'latex');
% saveas(gcf, '.\figures\highDimDataset\optimalValuesPlots\afterTrain\predictedDataPlot.png')

% Prediction error
figure;
plot(predictionError);
grid on;
title('\textbf{Prediction Error}', 'Interpreter','latex');
xlabel('Input', 'Interpreter', 'latex'); 
ylabel('Error', 'Interpreter', 'latex');
% saveas(gcf, '.\figures\highDimDataset\optimalValuesPlots\afterTrain\predictionError.png')

% Calculate the requested metrics
metrics_names = {'MSE', 'RMSE', 'NMSE', 'NDEI', 'R2'};
metrics = zeros(length(metrics_names), 1);
metrics(1) = mse(optimal_y_hat, testTargetData);
metrics(2) = RMSE(optimal_y_hat, testTargetData);
metrics(3) = NMSE(optimal_y_hat, testTargetData); 
metrics(4) = NDEI(optimal_y_hat, testTargetData); 
metrics(5) = R2(optimal_y_hat, testTargetData); 

% Metrics Result (in matrix form)
disp(array2table(metrics, 'VariableNames', {'Optimal Model'}, 'Rownames', metrics_names));

save('regression_highDimDataset_optimalVals_Variables');
diary off % Turn off file logging