% Function to calculate the NDEI metric
% (Formula given in the instructions pdf file)
%% Author: Kyparissis Kyparissis 
%         ( University ID: 10346 )

function NDEI_ans = NDEI(y_hat, y)
    NDEI_ans = sqrt(NMSE(y_hat, y));
end

