close; clc;
clearvars -except filepath

%% Load data
load '..\..\00 Data\Cluster.mat'
load '..\..\00 Data\Cluster_Veri.mat'
load '..\..\00 Data\Data.mat'
load '..\..\00 Data\Date.mat'

fieldn = {'N13302500','N04073500','N06192500','N08085500'};
WindowSize = 15; % Set window size to 15
warm_up = 365 - WindowSize + 1 + 1; 
length_day = 5113; % Set length of day to 5113 (warm up + calibration)
results = table;

for nbasin = 1:length(fieldn)
    tic
    %% Evaluate each basin
    % Prepare data, run the model
    num = fieldn{nbasin};
    clustn = size(Cluster.(num).centers,1); % Get number of clusters for the current field name
    DATA = [Data.(num).day.P Data.(num).day.PE Data.(num).day.Q Data.(num).day.avgT];
    DATA = cell2mat(DATA);
    DATA = DATA(WindowSize:end,:);

    global hymod
    hymod.data.precip = DATA(:,1); % Mean areal precipitation (mm)
    hymod.data.evap = DATA(:,2); % Climatic potential evaporation (mm)
    hymod.data.flow = DATA(:,3); % Streamflow discharge (mm)
    hymod.data.avgTemp = DATA(:,4); % Daily average temperature (℃)
    hymod.date.nDays = length(hymod.data.flow);
    hymod.date.year = Date.year(1:end);
    hymod.date.day = Date.day(1:end);

    % Qsimi, run on the entire sequence for the corresponding parameter group
    for i = 1:clustn
        load(['..\..\00 Data\Scheme1\' num2str(num) '\SCEUA' num2str(i) '.mat'])
        [Qobs, temp] = Hymod(SCEUA.bestx);
        eval(['Qsim' num2str(i) '=temp;']);
    end
    clear i

    % Qsim_cali, concatenate to obtain simulated flow process during calibration period
    date = ID(num, WindowSize, length_day, Cluster, Cluster_Veri);
    fields = fieldnames(date);
    for j = 1:numel(fields)
        hymod.date.(fields{j}) = date.(fields{j});
    end
    Qsim_Cali = zeros(length(hymod.date.ID_cali{1}) + warm_up - 1, 1);
    for i = 1:clustn
        eval(['Qsim_Cali(hymod.date.ID_cali{' num2str(i) '+1})=Qsim' num2str(i) '(hymod.date.ID_cali{' num2str(i) '+1});']);
    end
    Qsim_Cali = Qsim_Cali(warm_up:end,:);
    % Calibration period evaluation
    nse_cali = NSE(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    lnse_cali = LNSE(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    rmse5_cali = RMSE5(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    rmse_cali = RMSE1(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    mse_cali = MSE(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    msel_cali = MSEL(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    r2_cali = R2(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    kge_cali = KGE(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    mae_cali = MAE(Qobs(hymod.date.ID_cali{1}), Qsim_Cali);
    clear i

    % Obtain parameter groups from the corresponding path
    % Qsimi, run the corresponding parameter group on the entire sequence
    for i = 1:clustn
        load(['..\..\00 Data\Scheme5\' num2str(num) '\SCEUA' num2str(i) '.mat'])
        paras(i,:) = SCEUA.bestx;
    end
    clear i

    % Qsim_cali, calculate the simulated flow process during verification period
    [Qobs_veri, Qsim_veri] = Hymod1(paras);
    obs_eva = Qobs_veri(hymod.date.ID_veri{1});
    sim_eva = Qsim_veri(hymod.date.ID_veri{1});
    nse_veri = NSE(obs_eva, sim_eva);
    lnse_veri = LNSE(obs_eva, sim_eva);
    rmse5_veri = RMSE5(obs_eva, sim_eva);
    rmse_veri = RMSE1(obs_eva, sim_eva);
    mse_veri = MSE(obs_eva, sim_eva);
    msel_veri = MSEL(obs_eva, sim_eva);
    r2_veri = R2(obs_eva, sim_eva);
    kge_veri = KGE(obs_eva, sim_eva);
    mae_veri = MAE(obs_eva, sim_eva);

    basin_results = table;
    basin_results.Basin = num;
    basin_results.NSE0_Cali = nse_cali;
    basin_results.LNSE0_Cali = lnse_cali;
    basin_results.RMSE50_Cali = rmse5_cali;
    basin_results.RMSE0_Cali = rmse_cali;
    basin_results.MSE0_Cali = mse_cali;
    basin_results.MSEL0_Cali = msel_cali;
    basin_results.R20_Cali = r2_cali;
    basin_results.KGE0_Cali = kge_cali;
    basin_results.MAE0_Cali = mae_cali;

    basin_results.NSE0_Veri = nse_veri;
    basin_results.LNSE0_Veri = lnse_veri;
    basin_results.RMSE50_Veri = rmse5_veri;
    basin_results.RMSE0_Veri = rmse_veri;
    basin_results.MSE0_Veri = mse_veri;
    basin_results.MSEL0_Veri = msel_veri;
    basin_results.R20_Veri = r2_veri;
    basin_results.KGE0_Veri = kge_veri;
    basin_results.MAE0_Veri = mae_veri;
    results = [results; basin_results];
    toc
end
writetable(results, '..\..\00 Data\04 Evaluation.xlsx', 'Sheet', 'Scheme5');
