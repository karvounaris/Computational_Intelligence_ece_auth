% Author: Panagiotis Karvounaris
% University ID: 10193

close all;
clear;
clc;

if exist('classification_highDimDataset_optimalVals_logs.txt', 'file')
    delete('classification_highDimDataset_optimalVals_logs.txt');
end
feature('HotLinks', 0);
diary classification_highDimDataset_optimalVals_logs.txt

%% Found using the minima of MSE on the 3D-plot
optimalNumOfFeatures = 10;
optimalclusterRadius = 0.25;
% ---------------------------------------------

% We basically run the script of the grid search one more time,
% but for constant values of number of features and cluster radius
% Import data from grid search session
load('classification_highDimDataset_gridSearch_Variables');

optimalTrainData = [trainData(:, importanceIndexes(1:optimalNumOfFeatures)) trainTargetData];
optimalValidationData = [validationData(:,importanceIndexes(1:optimalNumOfFeatures)) validationTargetData];
optimalTestData = [testData(:, importanceIndexes(:,1:optimalNumOfFeatures)) testTargetData];

% Clustering Per Class
optimalCluster1InputData = optimalTrainData(optimalTrainData(:, end) == 1, :);
[optimalClusterCenters1, optimalSigma1] = subclust(optimalCluster1InputData, j);
optimalCluster2InputData = optimalTrainData(optimalTrainData(:, end) == 2, :);
[optimalClusterCenters2, optimalSigma2] = subclust(optimalCluster2InputData, j);
optimalCluster3InputData = optimalTrainData(optimalTrainData(:, end) == 3, :);
[optimalClusterCenters3, optimalSigma3] = subclust(optimalCluster3InputData, j);
optimalCluster4InputData = optimalTrainData(optimalTrainData(:, end) == 4, :);
[optimalClusterCenters4, optimalSigma4] = subclust(optimalCluster4InputData, j);
optimalCluster5InputData = optimalTrainData(optimalTrainData(:, end) == 5, :);
[optimalClusterCenters5, optimalSigma5] = subclust(optimalCluster5InputData, j);

% The total number of rules will come from all 5 clusters
numOfRules = size(optimalClusterCenters1, 1) + size(optimalClusterCenters2, 1) + size(optimalClusterCenters3, 1) + size(optimalClusterCenters4, 1) + size(optimalClusterCenters5, 1);

optimalInitialFIS = sugfis;

% ------------- INPUT -------------------
for i = 1:size(optimalTrainData, 2) - 1
    % Add Input
    optimalInitialFIS = addInput(optimalInitialFIS, [0, 1], 'Name', sprintf("in%d", i));

    % Add Iput Membership Functions
    for j=1:size(optimalClusterCenters1,1)    
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma1(i) optimalClusterCenters1(j,i)]);
    end
    for j=1:size(optimalClusterCenters2,1)
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma2(i) optimalClusterCenters2(j,i)]);
    end
    for j=1:size(optimalClusterCenters3,1)
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma3(i) optimalClusterCenters3(j,i)]);
    end
    for j=1:size(optimalClusterCenters4,1)
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma4(i) optimalClusterCenters4(j,i)]);
    end
    for j=1:size(optimalClusterCenters5,1)
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma5(i) optimalClusterCenters5(j,i)]);
    end
end

% ------------- OUTPUT -------------
optimalInitialFIS = addOutput(optimalInitialFIS, [0, 1], 'Name', 'out1');

% Add Output Membership Functions 
outputMembershipFunctionType = 'constant' ; % Singleton
optimalParams = [zeros(1,size(optimalClusterCenters1,1)) 0.25*ones(1,size(optimalClusterCenters2,1)) 0.5*ones(1,size(optimalClusterCenters3,1)) 0.75*ones(1,size(optimalClusterCenters4,1)) ones(1,size(optimalClusterCenters5,1))];
for i=1:numOfRules
    optimalInitialFIS = addMF(optimalInitialFIS, 'out1', outputMembershipFunctionType, optimalParams(i));
end

% ----------- RULEBASE -------------
% Add RuleBase
rulesList = zeros(numOfRules, size(optimalTrainData,2));
for i=1:size(rulesList,1)
    rulesList(i,:) = i;
end
rulesList = [rulesList ones(numOfRules,2)];
optimalInitialFIS = addrule(optimalInitialFIS, rulesList);

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
opti_ANFISoptions = anfisOptions;
opti_ANFISoptions.InitialFIS = optimalInitialFIS;
opti_ANFISoptions.EpochNumber = 100;
opti_ANFISoptions.ValidationData = optimalValidationData;
% Train of Model
[optimalTrainedFIS, optimalTrainError, ~, optimalValidationFIS, optimalValidationError] = anfis(optimalTrainData, opti_ANFISoptions);

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

optimal_y_hat = evalfis(optimalValidationFIS, optimalTestData(:, 1:end-1));
optimal_y_hat = round(optimal_y_hat);
% Trim values
optimal_y_hat = max(min(optimal_y_hat, 5), 1);

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

errorMatrix = confusionmat(testTargetData, optimal_y_hat);
figure;
cm = confusionchart(errorMatrix);
% saveas(gcf, '.\figures\highDimDataset\OptimalValuesPlots\afterTrain\ErrorMatrix.png')

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

% Calculate the requested metrics
OA_ans = OA(errorMatrix);
PA_ans = PA(errorMatrix);
UA_ans = UA(errorMatrix); 
K_hat_ans = K_hat(errorMatrix);
% Metrics Result (in matrix form)
disp(array2table(OA_ans, 'VariableNames', {'Optimal values model'}, 'Rownames', {'OA'}));
disp(array2table(PA_ans, 'VariableNames', {'Optimal values model'}, 'Rownames', {'PA(1)', 'PA(2)', 'PA(3)', 'PA(4)', 'PA(5)'}));
disp(array2table(UA_ans, 'VariableNames', {'Optimal values model'}, 'Rownames', {'UA(1)', 'UA(2)', 'UA(3)', 'UA(4)', 'UA(5)'}));
disp(array2table(K_hat_ans, 'VariableNames', {'Optimal values model'}, 'Rownames', {'K_hat'}));

% save('classification_highDimDataset_optimalVals_Variables');
diary off % Turn off file logging