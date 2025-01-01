% Author: Panagiotis Karvounaris
% University ID: 10193

close all;
clear;
clc;

if exist('classification_simpleDataset_logs.txt', 'file')
    delete('classification_simpleDataset_logs.txt');
end
feature('HotLinks', 0);
diary classification_simpleDataset_logs.txt

% Import dataset
dataset = importdata('haberman.data');

% Dataset split 60-20-20
[trainData, validationData, testData] = split_scale(dataset, 1);
trainTargetData = trainData(:, end);
validationTargetData = validationData(:, end);
testTargetData = testData(:, end);

model_names = {};
%%  ===================== MODELS ==========================
%$  ( Initializing the requested class independent models )
model_names{1} = 'TSK_model_1';
clusterRadius(1) = 0.1;
FISoptions(1) = genfisOptions('SubtractiveClustering');
FISoptions(1).ClusterInfluenceRange = clusterRadius(1);
initialFIS(1) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(1));

model_names{2} = 'TSK_model_2';
clusterRadius(2) = 0.9;
FISoptions(2) = genfisOptions('SubtractiveClustering');
FISoptions(2).ClusterInfluenceRange = clusterRadius(2);
initialFIS(2) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(2));

% FIS Options
ANFISoptions = anfisOptions;
ANFISoptions.ValidationData = validationData;
ANFISoptions.EpochNumber = 100;
for i = 1:length(model_names)
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

    % Learning curve
    figure;
    plot([trainError(:, i) validationError(:, i)]);
    grid on;
    xlabel('Number of Iterations', 'Interpreter', 'latex'); 
    ylabel('Error', 'Interpreter', 'latex');
    legend('Training Error', 'Validation Error', 'Interpreter', 'latex');
    title('\textbf{Learning Curve}', 'Interpreter','latex');
    subtitle(['TSK\_model\_' num2str(i)], 'Interpreter','latex');
    % saveas(gcf,['.\figures\simpleDataset\TSK_model_' num2str(i) '\TSK_model_' num2str(i) '_LearningCurve.png'])

    y_hat(:, i) = evalfis(validationFIS(i), testData(:, 1:end-1));
    y_hat(:, i) = round(y_hat(:, i));
    y_hat(:, i) = min(max(1, y_hat(:, i)), 2);

    % Error matrix
    errorMatrix = confusionmat(testTargetData, y_hat(:, i));
    figure;
    cm = confusionchart(errorMatrix);
    cm.Title = ['Error matrix for TSK\_model\_' num2str(i)];
    % saveas(gcf,['.\figures\simpleDataset\TSK_model_' num2str(i) '\TSK_model_' num2str(i) '_ErrorMatrix.png'])

    % % Calculate the requested metrics    
    OA_ans(i) = OA(errorMatrix);
    PA_ans(:, i) = PA(errorMatrix);
    UA_ans(:, i) = UA(errorMatrix); 
    K_hat_ans(i) = K_hat(errorMatrix);

    numOfModelRules(i) = size(validationFIS(i).Rules, 2);
end

%%  ===================== MODELS ==========================
%%   ( Initializing the requested class dependent models )
model_names{3} = 'TSK_model_3';
clusterRadius(3) = 0.1;
FISoptions(3) = genfisOptions('SubtractiveClustering');
initialFIS(3) = sugfis;

model_names{4} = 'TSK_model_4';
clusterRadius(4) = 0.9;
FISoptions(4) = genfisOptions('SubtractiveClustering');
initialFIS(4) = sugfis;

outputMembershipFunctionType = 'constant' ; % Singleton
for i = 3:length(model_names)
    % Clustering Per Class
    cluster1InputData = trainData(trainTargetData == 1, :);
    [clusterCenters1, sigma1] = subclust(cluster1InputData, clusterRadius(i));
    numOfClusterCenters1 = size(clusterCenters1, 1);
    cluster2InputData = trainData(trainTargetData == 2, :);
    [clusterCenters2, sigma2] = subclust(cluster2InputData, clusterRadius(i));
    numOfClusterCenters2 = size(clusterCenters2, 1);
    
    % The total number of rules will come from both clusters
    numOfRules = numOfClusterCenters1 + numOfClusterCenters2;
    
    % ------------- INPUT -------------------
    for j = 1:size(trainData, 2) - 1
        % Add Input
        initialFIS(i) = addInput(initialFIS(i), [0,1], 'Name', sprintf("in%d", j));

        % Add Iput Membership Functions
        for k=1:size(clusterCenters1, 1)    
            initialFIS(i) = addMF(initialFIS(i), sprintf("in%d", j), 'gaussmf', [sigma1(j) clusterCenters1(k, j)]);
        end
        for k=1:size(clusterCenters2, 1)
            initialFIS(i) = addMF(initialFIS(i), sprintf("in%d", j), 'gaussmf', [sigma2(j) clusterCenters2(k, j)]);
        end
    end

    % ------------- OUTPUT -------------
    % Add Output
    initialFIS(i) = addOutput(initialFIS(i), [0, 1], 'Name', 'out1');

    % Add Output Membership Functions 
    params = [zeros(1, size(clusterCenters1, 1)) ones(1, size(clusterCenters2, 1))];
    for j = 1:numOfRules
        initialFIS(i) = addMF(initialFIS(i), 'out1', outputMembershipFunctionType, params(j));
    end

    % ----------- RULEBASE -------------
    % Add FIS RuleBase
    rulesList = zeros(numOfRules, size(trainData, 2));
    for j = 1:size(rulesList, 1)
        rulesList(j, :) = j;
    end
    rulesList = [rulesList ones(numOfRules, 2)];
    initialFIS(i) = addrule(initialFIS(i), rulesList);

    % FIS Options
    ANFISoptions = anfisOptions;
    ANFISoptions.ValidationData = validationData;
    ANFISoptions.EpochNumber = 100;
    ANFISoptions.InitialFIS = initialFIS(i);
    % Train model
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

    % Learning curve
    figure;
    plot([trainError(:, i) validationError(:, i)]);
    grid on;
    xlabel('Number of Iterations', 'Interpreter', 'latex'); 
    ylabel('Error', 'Interpreter', 'latex');
    legend('Training Error', 'Validation Error', 'Interpreter', 'latex');
    title('\textbf{Learning Curve}', 'Interpreter','latex');
    subtitle(['TSK\_model\_' num2str(i)], 'Interpreter','latex');
    % saveas(gcf,['.\figures\simpleDataset\TSK_model_' num2str(i) '\TSK_model_' num2str(i) '_LearningCurve.png'])

    y_hat(:, i) = evalfis(validationFIS(i), testData(:, 1:end-1));
    y_hat(:, i) = round(y_hat(:, i));
    % Trim values
    y_hat(:, i) = min(max(1, y_hat(:, i)), 2);

    % Error matrix
    errorMatrix = confusionmat(testTargetData, y_hat(:, i));
    figure;
    cm = confusionchart(errorMatrix);
    cm.Title = ['Error matrix for TSK\_model\_' num2str(i)];
    % saveas(gcf,['.\figures\simpleDataset\TSK_model_' num2str(i) '\TSK_model_' num2str(i) '_ErrorMatrix.png'])

    % % Calculate the requested metrics  
    OA_ans(i) = OA(errorMatrix);
    PA_ans(:, i) = PA(errorMatrix);
    UA_ans(:, i) = UA(errorMatrix); 
    K_hat_ans(i) = K_hat(errorMatrix);
    numOfModelRules(i) = size(validationFIS(i).Rules, 2);
end

disp(array2table(OA_ans, 'VariableNames', model_names, 'Rownames', {'OA'}));
disp(array2table(PA_ans, 'VariableNames', model_names, 'Rownames', {'PA(1)', 'PA(2)'}));
disp(array2table(UA_ans, 'VariableNames', model_names, 'Rownames', {'UA(1)', 'UA(2)'}));
disp(array2table(K_hat_ans, 'VariableNames', model_names, 'Rownames', {'K_hat'}));
disp(array2table(numOfModelRules, 'VariableNames', model_names, 'Rownames', {'Number of Rules'}));

diary off % Turn off file logging
save('classification_simpleDataset_Variables')
