% prepare data for plot
close;clc;clear;
clearvars -global;

%% Load data
load ..\..\..\'00 Data'\Cluster.mat
load ..\..\..\'00 Data'\Cluster_Veri.mat
load ..\..\..\'00 Data'\Data.mat
load ..\..\..\'00 Data'\Date.mat

% fieldn = fieldnames(Cluster);
% WindowSize = 15; % Set window size to 15
% warm_up = 365-WindowSize+1+1;
% length_day = 5113; % Set length of day to 5113 (warm up + calibration)
% results = table;


Num_select = {'N04073500'};
% for i = 1:length(Num_select)

    %% setting segments
    num = Num_select{1};
    [seg_cali,seg_veri,seg_whole,segs_whole] = Segments_whole(num,Cluster,Cluster_Veri);

    %% fluxes and states of scheme1
    [fluxes_scheme1,states_scheme1] = Scheme1(num,Data,Date);

    %% fluxes and states of scheme2
    [fluxes_scheme2,states_scheme2] = Scheme2(num,Data,Date);

    %% fluxes and states of scheme3
    [fluxes_scheme3,states_scheme3] = Scheme3(num,Data,Date,Cluster,Cluster_Veri);

    %% fluxes and states of scheme4
    [fluxes_scheme4,states_scheme4] = Scheme4(num,Data,Date,Cluster,Cluster_Veri);
    fluxes_scheme4 = real(fluxes_scheme4);
    states_scheme4 = real(states_scheme4);
    %% fluxes and states of scheme5
    [fluxes_scheme5,states_scheme5] = Scheme5(num,Data,Date,Cluster,Cluster_Veri);

    %% fluxes and states of scheme6
    [fluxes_scheme6,states_scheme6,fluxes_scheme6_1,states_scheme6_1,fluxes_scheme6_2,states_scheme6_2,fluxes_scheme6_3,states_scheme6_3,fluxes_scheme6_4,states_scheme6_4,fluxes_scheme6_5,states_scheme6_5] = Scheme6(num,Data,Date,Cluster,Cluster_Veri);

    %% Write to table
    number = 1:6926;
    number = num2cell(number');
    title_fluxes = {'num'	'AE'	'OV'	'Qq'	'Qs'	'Qsim'	'Qobs'};
    title_state_variables = {'num'	'XHuz'	'XCuz'	'Xq1'	'Xq2'	'Xq3'	'Xs'};
    title1 = cell(6927,7);
    title1(1,:) = title_fluxes;
    title1(2:length(number)+1,1) = number;
    title2 = cell(6927,7);
    title2(1,:) = title_state_variables;
    title2(2:length(number)+1,1) = number;


    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme1','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme2','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme3','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme4','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme5','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme6-1','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme6-2','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme6-3','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme6-4','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme6-5','A1')
    xlswrite('..\01 Data\03 fluxes.xlsx',title1,'scheme6-6','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme1','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme2','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme3','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme4','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme5','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme6-1','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme6-2','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme6-3','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme6-4','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme6-5','A1')
    xlswrite('..\01 Data\02 State variables.xlsx',title2,'scheme6-6','A1')




    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme1,'scheme1','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme2,'scheme2','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme3,'scheme3','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme4,'scheme4','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme5,'scheme5','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme6_1,'scheme6-1','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme6_2,'scheme6-2','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme6_3,'scheme6-3','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme6_4,'scheme6-4','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme6_5,'scheme6-5','B2')
    xlswrite('..\01 Data\03 fluxes.xlsx',fluxes_scheme6,'scheme6-6','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme1,'scheme1','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme2,'scheme2','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme3,'scheme3','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme4,'scheme4','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme5,'scheme5','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme6_1,'scheme6-1','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme6_2,'scheme6-2','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme6_3,'scheme6-3','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme6_4,'scheme6-4','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme6_5,'scheme6-5','B2')
    xlswrite('..\01 Data\02 State variables.xlsx',states_scheme6,'scheme6-6','B2')

% end