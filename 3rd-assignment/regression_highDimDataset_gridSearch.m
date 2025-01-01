% Author: Panagiotis Karvounaris
% University ID: 10193

close all;
clear;
clc;

if exist('regression_highDimDataset_gridSearch_logs.txt', 'file')
    delete('regression_highDimDataset_gridSearch_logs.txt');
end
feature('HotLinks', 0);
diary regression_highDimDataset_gridSearch_logs.txt

%% Import dataset
dataset = importdata('superconduct.csv');
datasetTarget = dataset(:, end);

% Dataset split 60-20-20
[trainData, validationData, testData] = split_scale(dataset, 1);
trainTargetData = trainData(:, end);
validationTargetData = validationData(:, end);
testTargetData = testData(:, end);

%%      Grid Search Algorithm
% (Following the instructions pdf steps)
% Variable initilization
% Running tests to see which of the following values gives the smaller MSE.
numOfFeatures = [4 6 8 10];

clusterRadius = [0.25 0.5 0.75 1];

% Number of disjoint subsamples / folds
numOfFolds = 5;

ifThenRules_teamMethod = 'SubtractiveClustering'; %  We have to cluster input data using subtractive clustering 

% Features selection using either the ReliefF algorithm with k nearest neighbors
numOfNearestNeighbors = 10;
[importanceIndexes, importanceWeights] = relieff(dataset(:, 1:end-1), datasetTarget, numOfNearestNeighbors, 'method', 'regression');

% Initialize matrixes to hold MSEs and rule numbers
grid_MSEs = zeros(length(numOfFeatures), length(clusterRadius));
grid_numOfRules = zeros(length(numOfFeatures), length(clusterRadius));
% Run for every permutation of feature, fold and cluster radius
for i = numOfFeatures
    temp_train = [trainData(:, importanceIndexes(1:i)) trainTargetData];
    temp_test = [testData(:, importanceIndexes(1:i)) testTargetData];    
    for j = clusterRadius

        % Define a random partition on the dataset
        % We use this to define training and test sets for cross-validation
        cvObj = cvpartition(temp_train(:, end), 'KFold', numOfFolds);

        cvMSE = zeros(1, numOfFolds);
        for k = 1:numOfFolds
            % Extract the test indices for cross-validation
            cv_trainData = temp_train(training(cvObj, k), :);
            cv_trainTargetData = cv_trainData(:, end);
            cv_val = temp_train(test(cvObj, k), :);

            fisOptions = genfisOptions(ifThenRules_teamMethod, 'ClusterInfluenceRange', j);
            initFis = genfis(cv_trainData(:, 1:end-1), cv_trainTargetData, fisOptions);
            % Check if valid rules
            if (size(initFis.Rules, 2) < 2)
                fprintf("Number of rules less than 2...\n");

                continue;
            end

            % FIS Options
            ANFISoptions = anfisOptions;
            ANFISoptions.InitialFIS = initFis;
            ANFISoptions.ValidationData = cv_val;  
            ANFISoptions.EpochNumber = 100;
            % ANFIS (Train of model)
            [~, ~, ~, fis, ~] = anfis(cv_trainData, ANFISoptions);

            % Calculate the trained model's output
            y_hat = evalfis(fis, temp_test(:, 1:end-1));

            % Save the Mean Squared Error
            cvMSE(:, k) = mse(y_hat, testTargetData);
        end

        % Calcute mean MSE to get a MSE number for every pair for feature number and cluster radius
        % (We use find to find the indexes of the variables)
        grid_MSEs(find(numOfFeatures == i), find(clusterRadius == j)) = mean(cvMSE(1, :));
        grid_numOfRules(find(numOfFeatures == i), find(clusterRadius == j)) = size(fis.Rules, 2);

    end
end

% save('regression_highDimDataset_gridSearch_Variables');
% load('regression_highDimDataset_gridSearch_Variables');

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

diary off % Turn off file logging (Uncomment to use)