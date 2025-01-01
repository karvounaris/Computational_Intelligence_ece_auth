% Author: Panagiotis Karvounaris
% University ID: 10193

close all;
clear;
clc;

if exist('classification_highDimDataset_gridSearch_logs.txt', 'file')
    delete('classification_highDimDataset_gridSearch_logs.txt');
end
feature('HotLinks', 0);
diary classification_highDimDataset_gridSearch_logs.txt

% Import dataset
dataset = importdata('epileptic_seizure_data.csv').data;
datasetTarget = dataset(:, end);

% Dataset split 60-20-20 and pre-processing
[trainData, validationData, testData] = split_scale(dataset, 1);
trainTargetData = trainData(:, end);
validationTargetData = validationData(:, end);
validationData = max(min(validationData, 1), 0);
testTargetData = testData(:, end);
testData = max(min(testData, 1), 0);

%%      Grid Search Algorithm
% (Following the instructions pdf steps)
% Variable initilization
% Running tests to see which of the following values gives the greater OA.
numOfFeatures = [4 6 8 10];

clusterRadius = [0.25 0.5 0.75 1];

% Number of disjoint subsamples / folds
numOfFolds = 5;

% Features selection using either the ReliefF algorithm with k nearest neighbors
numOfNearestNeighbors = 10;
[importanceIndexes, importanceWeights] = relieff(dataset(:, 1:end-1), datasetTarget, numOfNearestNeighbors, 'method', 'classification');

outputMembershipFunctionType = 'constant' ; % Singleton

grid_OAs = zeros(length(numOfFeatures), length(clusterRadius));
grid_numOfRules = zeros(length(numOfFeatures), length(clusterRadius));
grid_MSEs = zeros(length(numOfFeatures), length(clusterRadius));
for i = numOfFeatures
    temp_train = [trainData(:, importanceIndexes(1:i)) trainTargetData];
    temp_test = [testData(:, importanceIndexes(1:i)) testTargetData];
    for j = clusterRadius
        % Define a random partition on the dataset
        % We use this to define training and test sets for cross-validation
        cvObj = cvpartition(temp_train(:, end), 'KFold', numOfFolds); 

        OAs = zeros(numOfFolds, 1);
        cvMSE = zeros(numOfFolds, 1);
        rulesNum_k = zeros(numOfFolds, 1);
        for k = 1:numOfFolds
            cv_trainData = temp_train(training(cvObj, k), :);
            cv_trainTargetData = cv_trainData(:, end);
            cv_validationData = temp_train(test(cvObj, k), :);

            % Clustering Per Class
            cluster1InputData = temp_train(temp_train(:, end) == 1, :);
            [clusterCenters1, sigma1] = subclust(cluster1InputData, j);
            cluster2InputData = temp_train(temp_train(:, end) == 2, :);
            [clusterCenters2, sigma2] = subclust(cluster2InputData, j);
            cluster3InputData = temp_train(temp_train(:, end) == 3, :);
            [clusterCenters3, sigma3] = subclust(cluster3InputData, j);
            cluster4InputData = temp_train(temp_train(:, end) == 4, :);
            [clusterCenters4, sigma4] = subclust(cluster4InputData, j);
            cluster5InputData = temp_train(temp_train(:, end) == 5, :);
            [clusterCenters5, sigma5] = subclust(cluster5InputData, j);

            % The total number of rules will come from all 5 clusters
            numOfRules = size(clusterCenters1, 1) + size(clusterCenters2, 1) + size(clusterCenters3, 1) + size(clusterCenters4, 1) + size(clusterCenters5, 1);

            initialFIS = sugfis;

            % ------------- INPUT -------------------
            for n = 1:size(temp_train, 2) - 1
                % Add Input
                initialFIS = addInput(initialFIS, [0, 1], 'Name', sprintf("in%d", n));

                % Add Iput Membership Functions
                for m = 1:size(clusterCenters1, 1)    
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma1(n) clusterCenters1(m, n)]);
                end
                for m = 1:size(clusterCenters2, 1)
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma2(n) clusterCenters2(m, n)]);
                end
                for m = 1:size(clusterCenters3, 1)
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma3(n) clusterCenters3(m, n)]);
                end
                for m = 1:size(clusterCenters4, 1)
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma4(n) clusterCenters4(m, n)]);
                end
                for m = 1:size(clusterCenters5, 1)
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma5(n) clusterCenters5(m, n)]);
                end
            end

            % ------------- OUTPUT -------------
            initialFIS = addOutput(initialFIS, [0, 1], 'Name', 'out1');

            % Add Output Membership Functions 
            params = [zeros(1, size(clusterCenters1, 1)) 0.25*ones(1, size(clusterCenters2, 1)) 0.5*ones(1, size(clusterCenters3, 1)) 0.75*ones(1, size(clusterCenters4, 1)) ones(1, size(clusterCenters5, 1))];
            for n = 1:numOfRules
                initialFIS = addMF(initialFIS, 'out1', outputMembershipFunctionType, params(n));
            end

            % ----------- RULEBASE -------------
            % Add FIS RuleBase
            rulesList = zeros(numOfRules, size(cv_trainData, 2));
            for n = 1:size(rulesList, 1)
                rulesList(n, :) = n;
            end
            rulesList = [rulesList ones(numOfRules, 2)];
            initialFIS = addrule(initialFIS, rulesList);

            % FIS Options
            ANFISoptions = anfisOptions;
            ANFISoptions.InitialFIS = initialFIS;
            ANFISoptions.EpochNumber = 100;
            ANFISoptions.ValidationData = cv_validationData;
            % Train model
            [~, ~, ~, validationFIS, ~] = anfis(cv_trainData, ANFISoptions);

            y_hat = evalfis(validationFIS, temp_test(:, 1:end-1));
            y_hat = round(y_hat);
            % Trim values
            y_hat = max(min(y_hat, 5), 1);

            errorMatrix = confusionmat(temp_test(:, end), y_hat);

            % Save the number of rules
            rulesNum_k(k) = size(validationFIS.Rules, 2);
            % Save the Mean Squared Error
            cvMSE(k) = mse(y_hat, testTargetData);
        end

        % Calcute mean MSE to get a MSE number for every pair for feature number and cluster radius
        % (We use find to find the indexes of the variables)
        grid_numOfRules(find(numOfFeatures == i), find(clusterRadius == j)) = mean(rulesNum_k);
        grid_MSEs(find(numOfFeatures == i), find(clusterRadius == j)) = mean(cvMSE);
    end
end


% save('classification_highDimDataset_gridSearch_Variables');
% load('classification_highDimDataset_gridSearch_Variables');

%% Plot of MSE = f(numOfRules)
figure;
grid on;
% We reshape matrixes to row vectors (we put rows next  to each other) to plot correctly.
scatter(reshape(grid_numOfRules, 1, []), reshape(grid_MSEs, 1, []), 'red', 'filled');
[minVal, minIndex] = min(grid_MSEs, [], 'all');
[minRow, minCol] = ind2sub(size(grid_MSEs), minIndex);
yline(minVal, 'LineStyle', '--', 'Label', 'MSE Minimum value', 'LabelHorizontalAlignment', 'center')
xline(grid_numOfRules(minRow, minCol), 'LineStyle', '--', 'Label', ['MSE Minima = ' num2str(grid_numOfRules(minRow, minCol))], 'LabelHorizontalAlignment', 'left')
xlabel('Number of Rules', 'Interpreter', 'latex');
ylabel('MSE', 'Interpreter', 'latex');
% saveas(gcf, '.\figures\highDimDataset\MSE-numOfRules_plot.png');

%% Plotting to find the minima of MSE
figure;
[numOfFeatures_Xgrid, clusterRadius_Ygrid] = meshgrid(numOfFeatures, clusterRadius);
surf(numOfFeatures_Xgrid, clusterRadius_Ygrid, grid_MSEs');
xlabel('Number of Features', 'Interpreter', 'latex');
ylabel('Cluster Radius', 'Interpreter', 'latex');
zlabel('MSE', 'Interpreter', 'latex');
% saveas(gcf, '.\figures\highDimDataset\MSE-numOfFeatures-clustRad_3Dplot.png');

diary off % Turn off file logging
