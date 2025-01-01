% Author: Panagiotis Karvounaris
% University ID: 10193

close all;
clear;
clc;

% System 25/((s+0.1)*(s+10))
Gp = zpk([], [-0.1, -10], 25)

% PI Controller
Gc = zpk(-0.4, 0, 2)

% We use trial and error and the requirements tool of controlSystemDesigner()
controlSystemDesigner(Gp, Gc);
% save controlSystemDesignerVariables.mat

% Create the controller with the tuned values
Gc = zpk(-0.3293, 0, 1.5659)

openLoopSystem = Gp * Gc
closedLoopSystem = feedback(openLoopSystem, 1, -1)

% Root locus plot
figure;
rlocus(openLoopSystem);

% Step response plot
figure;
step(closedLoopSystem);

% Calculate the Ki and Kp values of the controller
Kp = 1.5659;
Gc_zero = -0.3293;
Ki = -Kp*Gc_zero;

fprintf("\nKp = %g \t Ki = %g\n", Kp, Ki);

