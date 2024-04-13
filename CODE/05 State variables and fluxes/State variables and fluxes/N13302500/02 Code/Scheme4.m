% fluxes and states of Scheme4
function [fluxes_scheme4,states_scheme4] = Scheme4(num,Data,Date,Cluster,Cluster_Veri)

% reset work path
cd  ..\..\..\'03 Sub period calibration'\'04 高维空间'\

%% Prepare data

WindowSize = 15; % Set window size to 15
warm_up = 365-WindowSize+1+1; 
length_day = 5113; % Set length of day to 5113 (warm up + calibration)
results = table;

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

    % 到对应路径下获取参数组
    % Qsim, 运行得到结果
    load(['..' filesep '..' filesep '00 Data' filesep 'Scheme4' filesep num2str(num) filesep 'SCEUA0.mat'])
    date = ID(num,WindowSize,length_day,Cluster,Cluster_Veri);
    fields = fieldnames(date);
    for j = 1:numel(fields)
        hymod.date.(fields{j}) = date.(fields{j});
    end
    [Qobs,Qsim0] = Hymod(SCEUA.bestx);
    fluxes_scheme4 = [hymod.fluxes.AE,hymod.fluxes.OV,hymod.fluxes.Qq,hymod.fluxes.Qs,Qsim0,Qobs];
    states_scheme4 = [hymod.states.XHuz,hymod.states.XCuz,hymod.states.Xq,hymod.states.Xs];
    cd ..\..\'05 Results analysis of different calibration schemes'\'02 Code'\
