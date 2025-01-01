% Function to calculate the Overall Accuracy metric
% (Formula given in the instructions pdf file)
%% Author: Kyparissis Kyparissis 
%         ( University ID: 10346 )

function OA_ans = OA(errorMatrix)
    % Check if the input matrix is a valid confusion matrix
    if size(errorMatrix, 1) ~= size(errorMatrix, 2)
        error('Input matrix is not a valid confusion matrix.');
    end
    OA_ans = trace(errorMatrix) / sum(errorMatrix, "all");
end

