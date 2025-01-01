% Function to calculate the RMSE metric
% (Formula given in the instructions pdf file)
%% Author: Kyparissis Kyparissis 
%         ( University ID: 10346 )

function RMSE_ans = RMSE(y_hat, y)
    RMSE_ans = sqrt(mse(y_hat, y));
end

