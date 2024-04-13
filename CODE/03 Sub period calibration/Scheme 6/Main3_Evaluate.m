close; clc; clear;
clearvars -global;

%% Load data
load('../../00 Data/Cluster.mat');
load('../../00 Data/Cluster_Veri.mat');
load('../../00 Data/Data.mat');
load('../../00 Data/Date.mat');

fieldn = {'N12027500','N03331500','N06192500','N11532500','N05582000','N13302500'};
WindowSize = 15; % Set window size to 15
warm_up = 365-WindowSize+1+1; 
length_day = 5113; % Set length of day to 5113 (warm up + calibration)
results = table;

for nbasin = 1:length(fieldn)
    tic
    %% Evaluate each basin
    % Prepare data, run model
    num = fieldn{nbasin};
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

    % Qsimi, run corresponding parameter set on the entire sequence
    for i = 1:clustn
        load(['../../00 Data/Scheme1/' num2str(num) '/SCEUA' num2str(i) '.mat'])
        [Qobs, temp] = Hymod(SCEUA.bestx);
        eval(['Qsim' num2str(i) '=temp;']);
    end

    % Qsim_cali, concatenate to obtain simulated flow hydrograph for calibration period
    date = ID(num,WindowSize,length_day,Cluster,Cluster_Veri);
    fields = fieldnames(date);
    for j = 1:numel(fields)
        hymod.date.(fields{j}) = date.(fields{j});
    end
    Qsim_Cali = zeros(length(hymod.date.ID_cali{1})+warm_up-1,1);
    for i=1:clustn
        eval(['Qsim_Cali(hymod.date.ID_cali{',num2str(i),'+1})=Qsim',num2str(i),'(hymod.date.ID_cali{',num2str(i),'+1});']);
    end
    Qsim_Cali = Qsim_Cali(warm_up:end,:);
    % Calibration period evaluation
    nse_cali  = NSE(Qobs(hymod.date.ID_cali{1}),Qsim_Cali);
    lnse_cali = LNSE(Qobs(hymod.date.ID_cali{1}),Qsim_Cali);
    rmse_cali = RMSE(Qobs(hymod.date.ID_cali{1}),Qsim_Cali);

    % Get parameter set from corresponding path
    % Qsimi, run corresponding parameter set on the entire sequence
    for i = 1:clustn
        load(['../../00 Data/Scheme5/' num2str(num) '/SCEUA' num2str(i) '.mat'])
        paras(i,:) = SCEUA.bestx;
    end

    % Qsim_cali, compute simulated flow hydrograph for verification period
    [Qobs_veri,Qsim_veri] = Hymod1(paras);
    obs_eva = Qobs_veri(hymod.date.ID_veri{1});
    sim_eva = Qsim_veri(hymod.date.ID_veri{1});
    nse_veri  = NSE(obs_eva,sim_eva);
    lnse_veri = LNSE(obs_eva,sim_eva);
    rmse_veri = RMSE(obs_eva,sim_eva);

    basin_results = table;
    basin_results.Basin = num;
    basin_results.NSE0_Cali = nse_cali;
    basin_results.LNSE0_Cali = lnse_cali;
    basin_results.RMSE0_Cali = rmse_cali;
    basin_results.NSE0_Veri = nse_veri;
    basin_results.LNSE0_Veri = lnse_veri;
    basin_results.RMSE0_Veri = rmse_veri;
    results = [results; basin_results];
    toc
end
writetable(results, '../../00 Data/Scheme5_Result.xlsx');
