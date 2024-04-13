close;clc;clear;
clearvars -global;

%% Load data
load ..\..\'00 Data'\Cluster.mat
load ..\..\'00 Data'\Cluster_Veri.mat
load ..\..\'00 Data'\Data.mat
load ..\..\'00 Data'\Date.mat

fieldn = fieldnames(Cluster);
WindowSize = 15; % Set window size to 15
warm_up = 365-WindowSize+1+1;
length_day = 5113; % Set length of day to 5113 (warm up + calibration)

names = {'N13302500','N04073500','N06192500','N08085500'};
nse_basin = [];
for i_names = 1:4
    num = names{i_names};
    clustn = size(Cluster.(num).centers,1); % Get number of clusters for current field name
    DATA = [Data.(num).day.P Data.(num).day.PE Data.(num).day.Q Data.(num).day.avgT];
    DATA = cell2mat(DATA);
    DATA = DATA(WindowSize:end,:);

    global hymod
    hymod.data.precip   = DATA(:,1);               % Mean areal precipitation (mm)
    hymod.data.evap     = DATA(:,2);               % Climatic potential evaporation (mm)
    hymod.data.flow     = DATA(:,3);               % Streamflow discharge (mm)
    hymod.data.avgTemp  = DATA(:,4);               % Daily average temprature (℃)
    hymod.date.nDays    = length(hymod.data.flow);
    hymod.date.year     = Date.year(1:end);
    hymod.date.day      = Date.day(1:end);

    % 到对应路径下获取参数组
    % Qsim, 运行方案1结果
    load(['..' filesep '..' filesep  '00 Data' filesep 'Scheme1' filesep num2str(num) filesep 'SCEUA0.mat'])
    [Qobs,Qsim0] = Hymod(SCEUA.bestx);

    % Qsimi, 在整个序列上运行对应参数组
    sub_nse = [];
    for i = 1:clustn
        load(['..' filesep '..' filesep '00 Data' filesep 'Scheme1' filesep num2str(num) filesep 'SCEUA' num2str(i) '.mat'])
        [Qobs, temp] = Hymod(SCEUA.bestx);
        eval(['Qsim' num2str(i) '=temp;']);

        % split sequence of each subperiod, Qsub_simi
        eval(['Qsub_sim' num2str(i) '= Qsim' num2str(i) '(Cluster.' num '.index' num2str(i) ');']);
        %Qsub_obsi
        eval(['Qsub_obs' num2str(i) '= Qobs(Cluster.' num '.index' num2str(i) ');']);

        % evaluation metrics of calibration periods of sub period
        % Calculate NSE and LNSE for this subperiod
        eval(['nse = NSE(Qsub_obs' num2str(i) ', Qsub_sim' num2str(i) ');']);
        eval(['lnse = LNSE(Qsub_obs' num2str(i) ', Qsub_sim' num2str(i) ');']);
        sub_nse = [sub_nse,nse];
    end
    clear i
    nse_basin = [nse_basin;sub_nse];
end
