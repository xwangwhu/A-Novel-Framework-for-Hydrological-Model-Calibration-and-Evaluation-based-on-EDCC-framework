close;
clc;
clear;
clearvars -global;

%% Load data
load '..\..\00 Data\Cluster.mat'
load '..\..\00 Data\Cluster_Veri.mat'
load '..\..\00 Data\Data.mat'
load '..\..\00 Data\Date.mat'

fieldn = fieldnames(Cluster);
WindowSize = 15; % Set window size to 15
warm_up = 365 - WindowSize + 1 + 1; 
length_day = 5113; % Set length of day to 5113 (warm up + calibration)
results = table;

for nbasin = 1:length(fieldn)
    tic
    %% Evaluate each basin
    % Prepare data and run the model
    num = fieldn{nbasin};
    clustn = size(Cluster.(num).centers,1); % Get number of clusters for the current field name
    DATA = [Data.(num).day.P Data.(num).day.PE Data.(num).day.Q Data.(num).day.avgT];
    DATA = cell2mat(DATA);
    DATA = DATA(WindowSize:end,:);

    global hymod
    hymod.data.precip   = DATA(:,1); % Mean areal precipitation (mm)
    hymod.data.evap     = DATA(:,2); % Climatic potential evaporation (mm)
    hymod.data.flow     = DATA(:,3); % Streamflow discharge (mm)
    hymod.data.avgTemp  = DATA(:,4); % Daily average temperature (℃)
    hymod.date.nDays    = length(hymod.data.flow);
    hymod.date.year     = Date.year(1:end);
    hymod.date.day      = Date.day(1:end);

    % Get parameter sets at the corresponding path
    % Qsim, results of running scheme 1
    load(['..\..\00 Data\Scheme1\' num2str(num) '\SCEUA0.mat'])
    [Qobs, Qsim0] = Hymod(SCEUA.bestx);
    % Evaluation indices for scheme 1
    nse0_cali = NSE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    lnse0_cali = LNSE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    rmse0_cali = RMSE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    nse0_veri = NSE(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    lnse0_veri = LNSE(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    rmse0_veri = RMSE(Qobs(length_day+1:end), Qsim0(length_day+1:end));

    % Qsimi, running corresponding parameter set on the entire sequence
    for i = 1:clustn
        load(['..\..\00 Data\Scheme1\' num2str(num) '\SCEUA' num2str(i) '.mat'])
        [Qobs, temp] = Hymod(SCEUA.bestx);
        eval(['Qsim' num2str(i) '=temp;']);
    end

    % Qsim_Cali, concatenating to obtain simulated flow series during the calibration period
    hymod = ID(num, WindowSize, length_day, Cluster, Cluster_Veri);
    Qsim_Cali = zeros(length(hymod.date.ID_cali{1})+warm_up-1, 1);
    for i = 1:clustn
        eval(['Qsim_Cali(hymod.date.ID_cali{' num2str(i) '+1})=Qsim' num2str(i) '(hymod.date.ID_cali{' num2str(i) '+1});']);
    end
    Qsim_Cali = Qsim_Cali(warm_up:end,:);
    % Calibration period evaluation
    nse_cali = NSE(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    lnse_cali = LNSE(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    rmse_cali = RMSE(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);

    % Qsim_Veri, concatenating to obtain simulated flow series during the verification period
    Qsim_Veri = zeros(length(hymod.date.ID{1}), 1);
    for i = 1:clustn
        eval(['Qsim_Veri(hymod.date.ID_veri{' num2str(i) '+1})=Qsim' num2str(i) '(hymod.date.ID_veri{' num2str(i) '+1});']);
    end
    Qsim_Veri = Qsim_Veri(length_day-WindowSize+1+1:end);
    % Verification period evaluation
    nse_veri = NSE(Qobs(hymod.date.ID_veri{1}), Qsim_Veri);
    lnse_veri = LNSE(Qobs(hymod.date.ID_veri{1}), Qsim_Veri);
    rmse_veri = RMSE(Qobs(hymod.date.ID_veri{1}), Qsim_Veri);

    % Qsim, concatenating to obtain simulated flow series for the entire sequence
    for i = 1:clustn
        eval(['Qsim(hymod.date.ID{' num2str(i) '+1})=Qsim' num2str(i) '(hymod.date.ID{' num2str(i) '+1});']);
    end
    Qsim = Qsim';
    
    % Write the evaluation results to a table
    basin_results = table;
    basin_results.Basin = num;
    basin_results.NSE0_Cali = nse0_cali;
    basin_results.LNSE0_Cali = lnse0_cali;
    basin_results.RMSE0_Cali = rmse0_cali;
    basin_results.NSE_Cali = nse_cali;
    basin_results.LNSE_Cali = lnse_cali;
    basin_results.RMSE_Cali = rmse_cali;
    basin_results.NSE0_Veri = nse0_veri;
    basin_results.LNSE0_Veri = lnse0_veri;
    basin_results.RMSE0_Veri = rmse0_veri;
    basin_results.NSE_Veri = nse_veri;
    basin_results.LNSE_Veri = lnse_veri;
    basin_results.RMSE_Veri = rmse_veri;

    results = [results; basin_results];
    toc
end
writetable(results, '..\..\00 Data\Scheme1_Result.xlsx',Sheet='Overall Result');
