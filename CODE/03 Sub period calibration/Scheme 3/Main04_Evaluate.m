close; clc;
clearvars -except filepath

%% Load data
load '..\..\00 Data\Cluster.mat' % Load Cluster.mat file
load '..\..\00 Data\Cluster_Veri.mat' % Load Cluster_Veri.mat file
load '..\..\00 Data\Data.mat' % Load Data.mat file
load '..\..\00 Data\Date.mat' % Load Date.mat file

fieldn = {'N13302500','N13302500','N13302500','N04073500','N04073500','N04073500','N06192500','N06192500','N06192500','N08085500','N08085500','N08085500'};
WindowSize = 15; % Set window size to 15
warm_up = 365 - WindowSize + 1 + 1; 
length_day = 5113; % Set length of day to 5113 (warm up + calibration)
results = table;

parameterset = [
    776.104992944266	0.579768746740853	0.0546820435372178	0.848631540942129	0.0284148912152823	1.11274538294966	-2.60180845995436	3.52002260497462	295.896207072108	0.868947692544603	0.0703724269725851	0.571813755877506	0.0241597389336210	1.48418847152625	-1.51392730851734	-0.767861648205303	1078.55545902916	1.69604386017140	0.0831361796284840	0.839902711210967	0.0337071368470904	1.18188756530956	-1.75541543189238	1.26986084552441	343.990128275047	0.0802968948903007	0.360413322934482	0.777112362382340	0.261349625346213	0.843010239802570	-0.435703574737762	-1.56490438404914
    850.354391030232	0.669299217974607	0.125445564975745	0.805282067044417	0.0127190623387067	1.17879902365061	-4.03812277617834	2.71256736507868	289.265320425565	0.975224077795373	0.0797418320665317	0.596948727684289	0.0195113889422245	1.59015205332040	-1.92203881540085	-1.59985020038608	1051.50537578715	1.53539297334037	0.136126695850261	0.855331521618771	0.0295108803153912	0.858347173563555	-4.56663650352670	1.69978438390267	357.887689512261	0.0750153462594363	0.533699701973710	0.821622533922286	0.171054148512922	0.821861286105253	0.891506029808978	-0.982258141375844
    815.391328865921	0.660920768070490	0.0859930563276909	0.802423190322341	0.0176772633692713	1.20810420530503	-3.09537039111119	3.74096867184354	290.814809408809	0.979794772575365	0.0618844172258272	0.564807161770104	0.0207399176939762	1.31803489947658	-0.893144484432803	-1.59312822328435	1018.96027084565	1.65422262253380	0.120209462775274	0.800887893423626	0.0298803120714964	1.03560417487107	-3.39775160964412	1.47140724929607	348.116970085645	0.0766130006110398	0.354332224192888	0.805226546610236	0.192199367913066	0.823435721125811	-0.314829131840000	-1.34351841363973
];

for nbasin = 1:12
    tic
    %% Evaluate each basin
    num = fieldn{nbasin};
    clustn = size(Cluster.(num).centers, 1); % Get number of clusters for the current field name
    DATA = [Data.(num).day.P Data.(num).day.PE Data.(num).day.Q Data.(num).day.avgT];
    DATA = cell2mat(DATA);
    DATA = DATA(WindowSize:end, :);

    global hymod
    hymod.data.precip = DATA(:, 1); % Mean areal precipitation (mm)
    hymod.data.evap = DATA(:, 2); % Climatic potential evaporation (mm)
    hymod.data.flow = DATA(:, 3); % Streamflow discharge (mm)
    hymod.data.avgTemp = DATA(:, 4); % Daily average temperature (℃)
    hymod.date.nDays = length(hymod.data.flow);
    hymod.date.year = Date.year(1:end);
    hymod.date.day = Date.day(1:end);

    % Get parameters for the current basin
    basinnum = floor((nbasin - 1) / 3) + 1;
    schemenum = mod((nbasin - 1), 3) + 1;
    para = parameterset(schemenum, (8 * basinnum - 7):8 * basinnum);
    [Qobs, Qsim0] = Hymod(para);

    % Calibration period evaluation metrics
    nse0_cali = NSE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    lnse0_cali = LNSE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    rmse50_cali = RMSE5(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    rmse0_cali = RMSE1(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    mse0_cali = MSE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    msel0_cali = MSEL(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    r20_cali = R2(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    kge0_cali = KGE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));
    mae0_cali = MAE(Qobs(warm_up:length_day), Qsim0(warm_up:length_day));

    % Verification period evaluation metrics
    nse0_veri = NSE(Qobs(length_day + 1:end), Qsim0(length_day + 1:end));
    lnse0_veri = LNSE(Qobs(length_day + 1:end), Qsim0(length_day + 1:end));
    rmse50_veri = RMSE5(Qobs(length_day + 1:end), Qsim0(length_day + 1:end));
    rmse0_veri = RMSE1(Qobs(length_day + 1:end), Qsim0(length_day + 1:end));
    mse0_veri = MSE(Qobs(length_day + 1:end), Qsim0(length_day + 1:end));
    msel0_veri = MSEL(Qobs(length_day + 1:end), Qsim0(length_day + 1:end));
    r20_veri = R2(Qobs(length_day + 1:end), Qsim0(length_day + 1:end));
    kge0_veri = KGE(Qobs(length_day + 1:end), Qsim0(length_day + 1:end));
    mae0_veri = MAE(Qobs(length_day + 1:end), Qsim0(length_day + 1:end));
    
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

writetable(results, '../../00 Data/04 Evaluation.xlsx', 'Sheet', 'Scheme1');
