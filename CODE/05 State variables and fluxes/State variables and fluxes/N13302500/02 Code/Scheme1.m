% fluxes and states of scheme1
function [fluxes_scheme1,states_scheme1] = Scheme1(num,Data,Date)
% reset work path
cd  ..\..\..\'03 Sub period calibration'\'01 recommend scheme'\

%% Prepare data

WindowSize = 15; % Set window size to 15
% warm_up = 365-WindowSize+1+1; 
% length_day = 5113; % Set length of day to 5113 (warm up + calibration)
% results = table;

%% Run model with scheme1
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

    load(['..' filesep '..' filesep  '00 Data' filesep 'Scheme1' filesep num2str(num) filesep 'SCEUA0.mat'])
    [Qobs,Qsim0] = Hymod(SCEUA.bestx);
    fluxes_scheme1 = [hymod.fluxes.AE,hymod.fluxes.OV,hymod.fluxes.Qq,hymod.fluxes.Qs,Qsim0,Qobs];
    states_scheme1 = [hymod.states.XHuz,hymod.states.XCuz,hymod.states.Xq,hymod.states.Xs];

    cd ..\..\'05 Results analysis of different calibration schemes'\'02 Code'\
end

