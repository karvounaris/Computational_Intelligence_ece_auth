% Function to calculate the NMSE metric
% (Formula given in the instructions pdf file)
%% Author: Kyparissis Kyparissis 
%         ( University ID: 10346 )

function NMSE_ans = NMSE(y_hat, y)
    NMSE_ans = 1 - R2(y_hat, y);
end

