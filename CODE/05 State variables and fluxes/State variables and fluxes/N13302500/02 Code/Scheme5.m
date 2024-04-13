% fluxes and states of scheme5
function [fluxes_scheme5,states_scheme5] = Scheme5(num,Data,Date,Cluster,Cluster_Veri)

% reset work path
cd  ..\..\..\'03 Sub period calibration'\'05 参数突变'\

%% Prepare data

WindowSize = 15; % Set window size to 15
warm_up = 365-WindowSize+1+1; 
length_day = 5113; % Set length of day to 5113 (warm up + calibration)
results = table;
clustn = size(Cluster.(num).centers,1); % Get number of clusters for current field name

%% Run model with scheme3
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
%% Calibration period
    % 到对应路径下获取参数组
    % Qsimi, 在整个序列上运行对应参数组
    for i = 1:clustn
    load(['..' filesep '..' filesep '00 Data' filesep 'Scheme1' filesep num2str(num) filesep 'SCEUA' num2str(i) '.mat'])
    [Qobs, temp] = Hymod(SCEUA.bestx);
    eval(['Qsim' num2str(i) '=temp;']);
    eval(['fluxes_scheme5_' num2str(i) ' = [hymod.fluxes.AE,hymod.fluxes.OV,hymod.fluxes.Qq,hymod.fluxes.Qs,temp,Qobs];']);
    eval(['states_scheme5_' num2str(i) ' = [hymod.states.XHuz,hymod.states.XCuz,hymod.states.Xq,hymod.states.Xs];']);
    eval(['Qsim' num2str(i) '=' 'Qsim' num2str(i) '(WindowSize:length_day,:);']);
    eval(['fluxes_scheme5_' num2str(i) ' = fluxes_scheme5_' num2str(i) '(WindowSize:length_day,:);']);
    eval(['states_scheme5_' num2str(i) ' = states_scheme5_' num2str(i) '(WindowSize:length_day,:);']);
    end
    clear i

    % 在验证期上运行Hymod1
    clearvars hymod
    global hymod
    hymod.data.precip   = DATA(:,1);               % Mean areal precipitation (mm)
    hymod.data.evap     = DATA(:,2);               % Climatic potential evaporation (mm)
    hymod.data.flow     = DATA(:,3);               % Streamflow discharge (mm)
    hymod.data.avgTemp  = DATA(:,4);               % Daily average temprature (℃)
    hymod.date.nDays    = length(hymod.data.flow);
    hymod.date.year     = Date.year(1:end);
    hymod.date.day      = Date.day(1:end);
    % 到对应路径下获取参数组
    % Qsimi, 在整个序列上运行对应参数组
    for i = 1:clustn
    load(['..' filesep '..' filesep '00 Data' filesep 'Scheme5' filesep num2str(num) filesep 'SCEUA' num2str(i) '.mat'])
    paras(i,:) = SCEUA.bestx;
    end
    clear i

    % Qsim_cali, 计算验证期的模拟流量过程线
    [~,Qsim_veri] = Hymod1(paras);
    fluxes_scheme5_veri =  [hymod.fluxes.AE,hymod.fluxes.OV,hymod.fluxes.Qq,hymod.fluxes.Qs,temp,Qobs];
    states_scheme5_veri = [hymod.states.XHuz,hymod.states.XCuz,hymod.states.Xq,hymod.states.Xs];
    Qsim_veri = Qsim_veri(hymod.date.ID_veri{1},:);
    fluxes_scheme5_veri = fluxes_scheme5_veri(hymod.date.ID_veri{1},:);
    states_scheme5_veri = states_scheme5_veri(hymod.date.ID_veri{1},:);

    % Qsim_cali, 拼接得到率定期的模拟流量过程线
    hymod.date = ID(num,WindowSize,length_day,Cluster,Cluster_Veri);
    for i=1:clustn
        eval(['Qsim(hymod.date.ID_cali{',num2str(i),'+1},:)=Qsim',num2str(i),'(hymod.date.ID_cali{',num2str(i),'+1},:);']);
        eval(['fluxes_scheme5(hymod.date.ID_cali{',num2str(i),'+1},:)=fluxes_scheme5_',num2str(i),'(hymod.date.ID_cali{',num2str(i),'+1},:);']);
        eval(['states_scheme5(hymod.date.ID_cali{',num2str(i),'+1},:)=states_scheme5_',num2str(i),'(hymod.date.ID_cali{',num2str(i),'+1},:);']);
    end

    % merge data of cali and veri
    fluxes_scheme5 = [fluxes_scheme5;fluxes_scheme5_veri];
    states_scheme5 = [states_scheme5;states_scheme5_veri];

    cd ..\..\'05 Results analysis of different calibration schemes'\'02 Code'\