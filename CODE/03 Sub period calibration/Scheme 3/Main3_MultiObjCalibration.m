clc; clear; close; % Clear command window, workspace, and close all figures
load ('..\..\00 Data\Select.mat') % Load Select.mat file
load ('..\..\00 Data\Data.mat') % Load Data.mat file
load ('..\..\00 Data\Cluster.mat') % Load Cluster.mat file
load ('..\..\00 Data\Cluster_Veri.mat') % Load Cluster_Veri.mat file

%% initialization
fieldn = {'N13302500', 'N04073500', 'N06192500', 'N08085500'};
WindowSize = 15; % Set window size to 15
length_day = 5113; % Set length of day to 5113 (warm up + calibration)

for i = 1:length(fieldn)
    num = fieldn{i}; % Get current field name
    Main1_Data_units;

    %% Initial settings
    % Number of variables
    nvars = 8;

    % Upper and lower bounds
    parameters = [0 	0.01 	0.01 	0.5 	0.01  0  -5  -5
                  1500 	2 	    0.99 	1 	    1 	  2   5    5
                  10 	    1 	    0.7 	0.5 	0.5   1   0    0];

    bl = parameters(1,:);
    bu = parameters(2,:);
    x0 = parameters(3,:);

    %% Multi-objective optimization

    % Set non-default solver options
    options = optimoptions('gamultiobj','Display','iter','PlotFcn','gaplotpareto','MaxGenerations',25);

    % Solve
    [solution, objectiveValue] = gamultiobj(@FunctionTarget, nvars, [], [], [], [], bl, bu, [], [], options);

    parsave(['../../00 Data/Scheme7/' num '.mat'], solution)
end
