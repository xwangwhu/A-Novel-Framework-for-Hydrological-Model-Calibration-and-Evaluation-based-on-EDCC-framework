% fluxes and states of Scheme6
function [fluxes_scheme6,states_scheme6,fluxes_scheme6_1,states_scheme6_1,fluxes_scheme6_2,states_scheme6_2,fluxes_scheme6_3,states_scheme6_3,fluxes_scheme6_4,states_scheme6_4,fluxes_scheme6_5,states_scheme6_5] = Scheme6(num,Data,Date,Cluster,Cluster_Veri)

% reset work path
cd  ..\..\..\'03 Sub period calibration'\'01 recommend scheme'\

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
    eval(['fluxes_scheme6_' num2str(i) ' = [hymod.fluxes.AE,hymod.fluxes.OV,hymod.fluxes.Qq,hymod.fluxes.Qs,temp,Qobs];']);
    eval(['states_scheme6_' num2str(i) ' = [hymod.states.XHuz,hymod.states.XCuz,hymod.states.Xq,hymod.states.Xs];']);
%     eval(['Qsim' num2str(i) '=' 'Qsim' num2str(i) '(WindowSize:length_day,:);']);
%     eval(['fluxes_scheme6_' num2str(i) ' = fluxes_scheme6_' num2str(i) '(WindowSize:length_day,:);']);
%     eval(['states_scheme6_' num2str(i) ' = states_scheme6_' num2str(i) '(WindowSize:length_day,:);']);
    end
    clear i

    % Qsim_cali, 拼接得到率定期的模拟流量过程线
    hymod = ID(num,WindowSize,length_day,Cluster,Cluster_Veri);
    for i=1:clustn
        eval(['Qsim(hymod.date.ID{',num2str(i),'+1},:)=Qsim',num2str(i),'(hymod.date.ID{',num2str(i),'+1},:);']);
        eval(['fluxes_scheme6(hymod.date.ID{',num2str(i),'+1},:)=fluxes_scheme6_',num2str(i),'(hymod.date.ID{',num2str(i),'+1},:);']);
        eval(['states_scheme6(hymod.date.ID{',num2str(i),'+1},:)=states_scheme6_',num2str(i),'(hymod.date.ID{',num2str(i),'+1},:);']);
    end
    path = ['..\..\05 Results analysis of different calibration schemes\', num, '\02 Code'];
    cd (path)