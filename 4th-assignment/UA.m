% Function to calculate the User Accuracy metric
% (Formula given in the instructions pdf file)
%% Author: Kyparissis Kyparissis 
%         ( University ID: 10346 )

function UA_ans = UA(errorMatrix)
    % Check if the input matrix is a valid confusion matrix
    if size(errorMatrix, 1) ~= size(errorMatrix, 2)
        error('Input matrix is not a valid confusion matrix.');
    end

    numClasses = size(errorMatrix, 1);
    UA_ans = zeros(numClasses, 1);

    for i = 1:numClasses
        UA_ans(i) = errorMatrix(i, i) / sum(errorMatrix(i, :));
    end
end

