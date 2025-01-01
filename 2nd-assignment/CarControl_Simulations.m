% Author: Panagiotis Karvounaris
% University ID: 10193

close all;
clear;
clc;

%% Variables declaration
% Initial position
x_init = 4.1;
y_init = 0.3;
% Car velocity
velocity = 0.05;
% Initial velocity angle (in degrees)
theta_deg = [0 -45 -90];
% Obstacle Bounds
obstacleBounds = [[5 5 6 6 7 7 10 10];
                  [0 1 1 2 2 3 3 0]];
% Destination coordinates
x_final = 10;
y_final = 3.2;
% Final point error tolerance
errorTolerance = 0.03;
% Set bounds for runtime (prevent infinite loops)
x_bounds = [-1 (x_final + 0.3)];
y_bounds = [-1 (y_final + 0.3)];

%% (Controller with initial membership functions)
carFLC = readfis("carFLC.fis");
showrule(carFLC)

%% ==============================================
for i = 1:length(theta_deg)
    fprintf("For initial veloctiy angle = %d [deg]\n", theta_deg(i))

    % Initialize variables
    % x, y vectors to hold car's path
    x = x_init;
    y = y_init;
    theta = theta_deg(i);

    finalPointError = pdist([[x_final y_final];[x_init y_init]]);
    while(finalPointError > errorTolerance) % If near final destination, stop
        % Get sensor distances from obstacle
        [dh, dv] = getSensorDistances(x(end), y(end));
        if (isnan(dh) || isnan(dv))
            fprintf("Car hit at the obstacle!\n\n");
            break;
        end

        % Find new points using velocity's new angle
        x_new = x(end) + cosd(theta)*velocity;
        y_new = y(end) + sind(theta)*velocity;

        % Update car's path
        x = [x x_new];
        y = [y y_new];

        % Use FLC to calculate dtheta
        dtheta = evalfis(carFLC, [dv, dh, theta]);

        % Calculate new velocity's angle
        theta = theta + dtheta;

        % Check if car hit the obstacle
        if (x(end) < x_bounds(1) || x(end) > x_bounds(2) || y(end) < y_bounds(1) || y(end) > y_bounds(2))
            fprintf("OUT OF BOUNDS. Runtime stopped...\n");
            break;
        end

        % Update final point error for check
        finalPointError = pdist([[x_final y_final];[x(end) y(end)]]);
    end

    % Plot the simulation enviroment
    figure;
    hold on;
    plot(polyshape(obstacleBounds(1,:), obstacleBounds(2,:)), 'FaceColor', '#808080')   % Bounds plot
    scatter(x_init, y_init, '*', 'MarkerFaceColor','b', 'LineWidth', 1.5)               % Initial point
    scatter(x_final, y_final, '*', 'MarkerFaceColor','r', 'LineWidth', 1.5)             % Destination
    plot(x, y, 'b', "LineWidth", 1, 'LineStyle', '--');                                 % Car path
    xlim([0 10])
    ylim([0 4])
    legend("Obstacle", "Initial Position", "Desired Position", "Car's Path", 'Location', 'northwest')
    title("Car Control Simulation (with given MFs)", 'Interpreter','latex')
    subtitle(sprintf("Initial velocity angle: $ \\theta_{%d} = %d ^{\\circ}$", i, theta_deg(i)), 'Interpreter','latex')

    fprintf("===========\n")
end

%% (Controller with modified membership functions)
carFLC_modified = readfis("carFLC_modified.fis");
fprintf("\n\n>>   Use of FLC with modified MFs.\n")
%% ==============================================
for i = 1:length(theta_deg)
    fprintf("For initial veloctiy angle = %d [deg]\n", theta_deg(i))

    % Initialize variables
    % x, y vectors to hold car's path
    x = x_init;
    y = y_init;
    theta = theta_deg(i);

    finalPointError = pdist([[x_final y_final];[x_init y_init]]);
    while(finalPointError > errorTolerance) % If near final destination, stop
        % Get sensor distances from obstacle
        [dh, dv] = getSensorDistances(x(end), y(end));
        if(isnan(dh) || isnan(dv))
            fprintf("Car hit at the obstacle!\n\n");
            break;
        end

        % Find new points using velocity's new angle
        x_new = x(end) + cosd(theta)*velocity;
        y_new = y(end) + sind(theta)*velocity;

        % Update car's path
        x = [x x_new];
        y = [y y_new];

        % Use FLC to calculate dtheta
        dtheta = evalfis(carFLC_modified, [dv, dh, theta]);

        % Calculate new velocity's angle
        theta = theta + dtheta;

        % Check if car hit the obstacle
        if ((x(end) < x_bounds(1) || x(end) > x_bounds(2)) || (y(end) < y_bounds(1) || y(end) > y_bounds(2)))
            fprintf("OUT OF BOUNDS. Runtime stopped...\n");
            break;
        end

        % Update final point error for check
        finalPointError = pdist([[x_final y_final];[x(end) y(end)]]);
    end
    
    fprintf("Final point error = %f [m]\n", finalPointError)

    % Plot the simulation enviroment
    figure;
    hold on;
    plot(polyshape(obstacleBounds(1,:), obstacleBounds(2,:)), 'FaceColor', '#808080')   % Bounds plot
    scatter(x_init, y_init, '*', 'MarkerFaceColor','b', 'LineWidth', 1.5)               % Initial point
    scatter(x_final, y_final, '*', 'MarkerFaceColor','r', 'LineWidth', 1.5)             % Destination
    plot(x, y, 'b', "LineWidth", 1, 'LineStyle', '--');                                 % Car path
    xlim([0 10])
    ylim([0 4])
    legend("Obstacle", "Initial Position", "Desired Position", "Car's Path", 'Location', 'northwest')
    title("Car Control Simulation (with \textbf{modified} MFs)", 'Interpreter','latex')
    subtitle(sprintf("Initial velocity angle: $ \\theta_{%d} = %d ^{\\circ}$", i, theta_deg(i)), 'Interpreter','latex')

    fprintf("===========\n")
end