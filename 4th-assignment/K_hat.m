% Function to calculate the K_hat metric
% (Formula given in the instructions pdf file)
%% Author: Kyparissis Kyparissis 
%         ( University ID: 10346 )

function K_hat_ans = K_hat(errorMatrix)
    % Check if the input matrix is a valid confusion matrix
    if size(errorMatrix, 1) ~= size(errorMatrix, 2)
        error('Input matrix is not a valid confusion matrix.');
    end

    numClasses = size(errorMatrix, 1);

    % Calculate observed agreement (Po)
    observedAgreement = sum(diag(errorMatrix)) / sum(errorMatrix(:));

    % Calculate expected agreement by chance (Pe)
    expectedAgreement = 0;
    for i = 1:numClasses
        rowSum = sum(errorMatrix(i, :));
        colSum = sum(errorMatrix(:, i));
        expectedAgreement = expectedAgreement + (rowSum * colSum);
    end
    expectedAgreement = expectedAgreement / sum(errorMatrix(:))^2;

    % Calculate K_hat
    K_hat_ans = (observedAgreement - expectedAgreement) / (1 - expectedAgreement);
end

