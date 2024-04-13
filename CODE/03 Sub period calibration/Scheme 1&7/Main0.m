clc;clear;close; % Clear command window, workspace and close all figures
load ('..\..\00 Data\Select.mat') % Load Select.mat file
load ('..\..\00 Data\Data.mat') % Load Data.mat file
load ('..\..\00 Data\Cluster.mat') % Load Cluster.mat file
load ('..\..\00 Data\Cluster_Veri.mat') % Load Cluster_Veri.mat file
load '..\..\00 Data\nums.mat'

%% initialization
% fieldnames = fieldnames(Cluster); % Get field names of Cluster structure
fieldnames = nums; % Get field names of Cluster structure
WindowSize = 15; % Set window size to 15
length_day = 5113; % Set length of day to 5113 (warm up + calibration)

%% Loop through each field name, run calibration scheme
for fieldn = 1:50
    num = fieldnames{fieldn}; % Get current field name
    clustn = size(Cluster.(num).centers,1); % Get number of clusters for current field name
    Main1_Data_units; % Run Main1_Data_units script
    folder_name = fullfile('..', '..', '00 Data', 'Scheme1',num); % Create folder path for current field name
    if ~exist(folder_name, 'dir') 
        mkdir(folder_name) 
    end
     Main2_0_Calibration;
    for imain0 = 1:clustn % Loop through each cluster
        % Main1_Data_units;
        newstr = num2str(imain0); % Convert cluster number to string
        instruction = ['run Main2_' newstr '_Calibration.m']; % Create instruction to run Main2 script for current cluster number
        eval(instruction) % Evaluate instruction to run script
    end
end