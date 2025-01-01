% Function to calculate the R2 metric
% (Formula given in the instructions pdf file)
%% Author: Kyparissis Kyparissis 
%         ( University ID: 10346 )

function R2_ans = R2(y_hat, y)
    R2_ans = 1-sum((y - y_hat).^2)/sum((y - mean(y)).^2);
end

