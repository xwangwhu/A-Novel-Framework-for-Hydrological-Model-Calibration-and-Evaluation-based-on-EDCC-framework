clc; clear; close; % Clear command window, workspace and close all figures
load ('..\..\00 Data\Data.mat') % Load Data.mat file
load ('..\..\00 Data\Cluster.mat') % Load Cluster.mat file
load ('..\..\00 Data\Cluster_Veri.mat') % Load Cluster_Veri.mat file
load ..\..\'00 Data'\Date.mat
%% initialization
fieldn = {'N13302500', 'N04073500', 'N06192500', 'N08085500'};
WindowSize = 15; % Set window size to 15
length_day = 5113; % Set length of day to 5113 (warm up + calibration)

for i = 1:length(fieldn)
    num = fieldn{i}; % Get current field name

    %% Calculate corresponding NSE and LNSE
    % Load parameters obtained from multi-objective calculation
    mat_file = fullfile('..', '..', '00 Data', 'Scheme7', [num '.mat']);
    load(mat_file);

    % Prepare data and labels
    clustn = size(Cluster.(num).centers,1); % Get number of clusters for current field name
    DATA = [Data.(num).day.P Data.(num).day.PE Data.(num).day.Q Data.(num).day.avgT];
    DATA = cell2mat(DATA);
    DATA = DATA(WindowSize:end,:);

    global hymod
    hymod.data.precip   = DATA(:,1);               % Mean areal precipitation (mm)
    hymod.data.evap     = DATA(:,2);               % Climatic potential evaporation (mm)
    hymod.data.flow     = DATA(:,3);               % Streamflow discharge (mm)
    hymod.data.avgTemp  = DATA(:,4);               % Daily average temperature (℃)
    hymod.date.nDays    = length(hymod.data.flow);
    hymod.date.year     = Date.year(1:end);
    hymod.date.day      = Date.day(1:end);
    date = ID(num,WindowSize,length_day,Cluster,Cluster_Veri);
    % Labels
    fields = fieldnames(date);
    for j = 1:numel(fields)
        hymod.date.(fields{j}) = date.(fields{j});
    end

    % Calculate corresponding objective functions
    global hymod
    ObjFunctionNSE = arrayfun(@(x) FunctNSE(solution(x,:)),1:size(solution,1));
    ObjFunctionLNSE = arrayfun(@(x) FunctLNSE(solution(x,:)),1:size(solution,1));

    VeriFunctionNSE = arrayfun(@(x) VeriFunctNSE(solution(x,:)),1:size(solution,1));
    VeriFunctionLNSE = arrayfun(@(x) VeriFunctLNSE(solution(x,:)),1:size(solution,1));

    clearvars -except ObjFunctionNSE ObjFunctionLNSE VeriFunctionNSE VeriFunctionLNSE num i Data Date length_day fieldn Cluster Cluster_Veri WindowSize

    %% Plot
    % X-axis is NSE, Y-axis is LNSE
    scatter(ObjFunctionNSE, ObjFunctionLNSE, 10, [0 0 0.5]);
    % scatter(VeriFunctionNSE, VeriFunctionLNSE, 10, [0 0 0.5]);
    set(groot,'defaultAxesTickLabelInterpreter','tex')
    set(groot,'defaultTextInterpreter','tex')
    xlabel('\fontname{Times New Roman} 1-NSE');
    ylabel('\fontname{Times New Roman} 1-LNSE');
    title('\fontname{Times New Roman} Pareto optional front');
    grid on
    set(gca,'FontSize',10)
    legend('Optimal solution')

    % Save the plot
    img_file = fullfile('..', '..', '00 Data', 'Scheme7',[num '.png']);
    print('-r600', '-dpng', img_file)
    close all

    A = [ObjFunctionNSE; ObjFunctionLNSE; VeriFunctionNSE; VeriFunctionLNSE];
end
