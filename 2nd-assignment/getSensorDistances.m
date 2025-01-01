% This function returns the horizontal and vertical distances of a
% point/car with coordinates (x, y) from an polyshape obstacle with edges:
% obstacleBounds = [[5 5 6 6 7 7 10 10];
%                   [0 1 1 2 2 3 3 0]];
% INPUT:    x:  x-coordinate of the car/point
%           y:  y-coordinate of the car/point
% OUTPUT:   dh: horizontal distance of the car from the obstacle
%           dv: vertical distance of the car from the obstacle

function [dh, dv] = getSensorDistances(x, y)
    % Check if given position is inside the obstacle
    if ((x > 5 && y < 1) || (x > 6 && y < 2 && y > 1) || (x > 7 && y > 2 && y < 3))
        dh = NaN;
        dv = NaN;

        return;
    end

    % Calcuate distances from bound
    if (x > 7)
       dh = 1;
       dv = y - 3; 
    elseif (x > 6)
        dv = y - 2;
        if (y > 3)
            dh = 1;
        else
            dh = 7 - x;
        end
    elseif (x > 5)
        dv = y - 1;
        if (y > 3)
            dh = 1;
        elseif (y > 2)
            dh = 7 - x;
        else 
            dh = 6 - x;
        end
    else
        dv = y;
        if (y > 3)
            dh = 1;
        elseif (y > 2)
            dh = 7 - x;
        elseif (y > 1)
            dh = 6 - x;
        else
            dh = 5 - x;
        end
    end
    
    % Project distances into [0, 1]
    dh = min(1, dh);
    dv = min(1, dv);

end

