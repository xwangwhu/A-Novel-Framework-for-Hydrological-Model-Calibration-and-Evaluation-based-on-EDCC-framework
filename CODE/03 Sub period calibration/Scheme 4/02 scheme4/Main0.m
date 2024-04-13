clc;clear;close; % Clear command window, workspace and close all figures
load ('..\..\..\00 Data\Select.mat') % Load Select.mat file
load ('..\..\..\00 Data\Data.mat') % Load Data.mat file
load ('..\..\..\00 Data\Cluster.mat') % Load Cluster.mat file
load ('..\..\..\00 Data\Cluster_Veri.mat') % Load Cluster_Veri.mat file
%% initialization
WindowSize = 15; % Set window size to 15
length_day = 5113; % Set length of day to 5113 (warm up + calibration)

%% Loop through each field name, run calibration scheme
fieldn = {	'N04073500' 'N06192500' 'N05280000' 'N13302500'};

for nbasin = 1:length(fieldn)
    num = fieldn{nbasin}; % Get current field name
    Main1_Data_units; % Run Main1_Data_units script
    folder_name = fullfile('..', '..','..', '00 Data','Scheme3', num); % Create folder path for current field name
    if ~exist(folder_name, 'dir') 
        mkdir(folder_name) 
    end
    Main2_Calibration_Huz;
end
