close; clc;
clearvars -except filepath

%% Load data
load ..\..\..\00 Data\Cluster.mat
load ..\..\..\00 Data\Cluster_Veri.mat
load ..\..\..\00 Data\Data.mat
load ..\..\..\00 Data\Date.mat

%% Initialization
WindowSize = 15; % Set window size to 15
length_day = 5113; % Set length of day to 5113 (warm up + calibration)
warm_up = 365 - WindowSize + 1 + 1; 
results = table;

%% Evaluate each basin
fieldn = {'N13302500', 'N04073500', 'N06192500', 'N08085500'};

for i = 1:length(fieldn)
    tic
    num = fieldn{i}; % Get current field name
    
    % Prepare data and run the model
    clustn = size(Cluster.(num).centers,1); % Get number of clusters for current field name
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

    % Obtain parameter sets from the corresponding path
    % Qsim, get results
    load(['../../../../../00 Data/Scheme3/' num2str(num) '/SCEUA0.mat'])
    date = ID(num, WindowSize, length_day, Cluster, Cluster_Veri);
    fields = fieldnames(date);
    for j = 1:numel(fields)
        hymod.date.(fields{j}) = date.(fields{j});
    end
    if strcmp(num, 'N12027500')
        [Qobs, Qsim0] = Hymod_Ks(SCEUA.bestx);
    elseif strcmp(num, 'N11532500')
        [Qobs, Qsim0] = Hymod_alpha(SCEUA.bestx);
    else
        [Qobs, Qsim0] = Hymod_Huz(SCEUA.bestx);
    end
    
    % Evaluation metrics
    nse0_cali = NSE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    lnse0_cali = LNSE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    rmse50_cali = RMSE5(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    rmse0_cali = RMSE1(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    mse0_cali = MSE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    msel0_cali = MSEL(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    r20_cali = R2(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    kge0_cali = KGE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    mae0_cali = MAE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));

    nse0_veri = NSE(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    lnse0_veri = LNSE(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    rmse50_veri = RMSE5(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    rmse0_veri = RMSE1(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    mse0_veri = MSE(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    msel0_veri = MSEL(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    r20_veri = R2(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    kge0_veri = KGE(Qobs(length_day+1:end), Qsim0(length_day+1:end));
    mae0_veri = MAE(Qobs(length_day+1:end), Qsim0(length_day+1:end));

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

    basin_results.NSE0_Veri = nse0_veri;
    basin_results.LNSE0_Veri = lnse0_veri;
    basin_results.RMSE50_Veri = rmse50_veri;
    basin_results.RMSE0_Veri = rmse0_veri;
    basin_results.MSE0_Veri = mse0_veri;
    basin_results.MSEL0_Veri = msel0_veri;
    basin_results.R20_Veri = r20_veri;
    basin_results.KGE0_Veri = kge0_veri;
    basin_results.MAE0_Veri = mae0_veri;

    results = [results; basin_results];
    toc
end

writetable(results, '../../../00 Data/04 Evaluation.xlsx', Sheet='Scheme3');
