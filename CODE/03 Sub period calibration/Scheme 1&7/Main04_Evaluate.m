close;
clc;
clearvars -except filepath

%% Load data
load(fullfile('..', '..', '00 Data', 'Cluster.mat'));
load(fullfile('..', '..', '00 Data', 'Cluster_Veri.mat'));
load(fullfile('..', '..', '00 Data', 'Data.mat'));
load(fullfile('..', '..', '00 Data', 'Date.mat'));

% Define the basins
fieldn = {'N13302500', 'N04073500', 'N06192500', 'N08085500'};
WindowSize = 15; % Set window size to 15
warm_up = 365 - WindowSize + 2; % Adjusted warm-up period
length_day = 5113; % Set length of day to 5113 (warm up + calibration)
results = table;

for nbasin = 1:length(fieldn)
    tic
    %% Evaluate each basin
    % Prepare data and run the model
    num = fieldn{nbasin};
    clustn = size(Cluster.(num).centers, 1); % Get number of clusters for the current basin
    DATA = [Data.(num).day.P Data.(num).day.PE Data.(num).day.Q Data.(num).day.avgT];
    DATA = cell2mat(DATA);
    DATA = DATA(WindowSize:end, :);

    global hymod
    hymod.data.precip = DATA(:,1); % Mean areal precipitation (mm)
    hymod.data.evap = DATA(:,2); % Climatic potential evaporation (mm)
    hymod.data.flow = DATA(:,3); % Streamflow discharge (mm)
    hymod.data.avgTemp = DATA(:,4); % Daily average temperature (°C)
    hymod.date.nDays = length(hymod.data.flow);
    hymod.date.year = Date.year;
    hymod.date.day = Date.day;

    % Load parameter set for the corresponding basin
    load(fullfile('..', '..', '00 Data', 'Scheme1', num, 'SCEUA0.mat'));
    [Qobs, Qsim0] = Hymod(SCEUA.bestx);

    % Evaluate Scheme1's performance
    [nse0_cali, lnse0_cali, rmse50_cali, rmse0_cali, mse0_cali, msel0_cali, r20_cali, kge0_cali, mae0_cali] = EvaluatePerformance(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));

    [nse0_veri, lnse0_veri, rmse50_veri, rmse0_veri, mse0_veri, msel0_veri, r20_veri, kge0_veri, mae0_veri] = EvaluatePerformance(Qobs(length_day+1:end), Qsim0(length_day+1:end));

    % Load and evaluate other parameter sets
    for i = 1:clustn
        load(fullfile('..', '..', '00 Data', 'Scheme1', num, ['SCEUA', num2str(i), '.mat']));
        [Qobs, temp] = Hymod(SCEUA.bestx);
        eval(['[nse', num2str(i), ', lnse', num2str(i), ', rmse50_', num2str(i), ', rmse_', num2str(i), ', mse_', num2str(i), ', msel_', num2str(i), ', r2_', num2str(i), ', kge_', num2str(i), ', mae_', num2str(i), '] = EvaluatePerformance(Qobs, temp);']);
    end

    % Concatenate simulated flow for calibration
    hymod = ID(num, WindowSize, length_day, Cluster, Cluster_Veri);
    Qsim_Cali = ConcatenateFlow(Qsim, hymod.date.ID_cali{1}, warm_up);

    % Evaluate calibration period
    [nse_cali, lnse_cali, rmse5_cali, rmse_cali, mse_cali, msel_cali, r2_cali, kge_cali, mae_cali] = EvaluatePerformance(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);

    % Concatenate simulated flow for verification
    Qsim_Veri = ConcatenateFlow(Qsim, hymod.date.ID_veri{1}, length_day-WindowSize+2);

    % Evaluate verification period
    [nse_veri, lnse_veri, rmse5_veri, rmse_veri, mse_veri, msel_veri, r2_veri, kge_veri, mae_veri] = EvaluatePerformance(Qobs(hymod.date.ID_veri{1}), Qsim_Veri);

    % Write the evaluation results to a table
    basin_results = table;
    basin_results.Basin = num;
    basin_results.NSE0_Cali = nse0_cali;
    basin_results.LNSE0_Cali = lnse0_cali;
    basin_results.RMSE50_Cali = rmse50_cali;
    basin_results.RMSE0_Cali = rmse0_cali;
    basin_results.MSE0_Cali = mse0_cali;
    basin_results.MSEL0_Cali = msel0_cali;
    basin_results.R20_Cali = r20_cali;
    basin_results.KGE0_Cali = kge0_cali;
    basin_results.MAE0_Cali = mae0_cali;

    basin_results.NSE_Cali = nse_cali;
    basin_results.LNSE_Cali = lnse_cali;
    basin_results.RMSE5_Cali = rmse5_cali;
    basin_results.RMSE_Cali = rmse_cali;
    basin_results.MSE_Cali = mse_cali;
    basin_results.MSEL_Cali = msel_cali;
    basin_results.R2_Cali = r2_cali;
    basin_results.KGE_Cali = kge_cali;
    basin_results.MAE_Cali = mae_cali;

    basin_results.NSE0_Veri = nse0_veri;
    basin_results.LNSE0_Veri = lnse0_veri;
    basin_results.RMSE50_Veri = rmse50_veri;
    basin_results.RMSE0_Veri = rmse0_veri;
    basin_results.MSE0_Veri = mse0_veri;
    basin_results.MSEL0_Veri = msel0_veri;
    basin_results.R20_Veri = r20_veri;
    basin_results.KGE0_Veri = kge0_veri;
    basin_results.MAE0_Veri = mae0_veri;

    basin_results.NSE_Veri = nse_veri;
    basin_results.LNSE_Veri = lnse_veri;
    basin_results.RMSE5_Veri = rmse5_veri;
    basin_results.RMSE_Veri = rmse_veri;
    basin_results.MSE_Veri = mse_veri;
    basin_results.MSEL_Veri = msel_veri;
    basin_results.R2_Veri = r2_veri;
    basin_results.KGE_Veri = kge_veri;
    basin_results.MAE_Veri = mae_veri;

    results = [results; basin_results];
    toc
end

writetable(results, fullfile('..', '..', '00 Data', '04 Evaluation.xlsx'), 'Sheet', 'Scheme1');

%% Helper functions

function [nse, lnse, rmse50, rmse, mse, msel, r2, kge, mae] = EvaluatePerformance(Qobs, Qsim)
    % Evaluate model performance using various metrics
    nse = NSE(Qobs, Qsim);
    lnse = LNSE(Qobs, Qsim);
    rmse50 = RMSE5(Qobs, Qsim);
    rmse = RMSE1(Qobs, Qsim);
    mse = MSE(Qobs, Qsim);
    msel = MSEL(Qobs, Qsim);
    r2 = R2(Qobs, Qsim);
    kge = KGE(Qobs, Qsim);
    mae = MAE(Qobs, Qsim);
end

function Qsim_concat = ConcatenateFlow(Qsim, date_indices, start_index)
    % Concatenate simulated flow for the specified date indices
    Qsim_concat = zeros(length(date_indices) + start_index - 1, 1);
    for i = 1:length(Qsim)
        Qsim_concat(date_indices{i} + start_index - 1) = Qsim{i};
    end
    Qsim_concat = Qsim_concat(start_index:end);
end