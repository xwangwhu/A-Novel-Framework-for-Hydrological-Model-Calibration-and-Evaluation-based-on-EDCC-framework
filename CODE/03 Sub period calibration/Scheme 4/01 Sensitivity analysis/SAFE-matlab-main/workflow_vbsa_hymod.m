% This script provides an application example of Variance Based Sensitivity
% Analysis (VBSA)
%
% METHODS
%
% We use two well established variance-based sensitivity indices: 
% - the first-order sensitivity index (or 'main effects')
% - the total-order sensitivity index (or 'total effects')
% (see help of 'vbsa_indices' for more details and references)
%
% MODEL AND STUDY AREA
%
% The model under study is the rainfall-runoff model Hymod
% (see help of function hymod_sim.m for more details) 
% applied to the Leaf catchment in Mississipi, USA
% (see header of file LeafCatch.txt for more details).
% The inputs subject to SA are the 5 model parameters, and the scalar 
% output for SA is (one or multiple) performance metric.
%
% INDEX
%
% Steps:
% 1. Add paths to required directories
% 2. Load data, set-up the Hymod model and define input ranges
% 3. Compute first-order (main effects) and total-order (total effects)
%    variance-based indices.
% 4: Example of how to repeat computions after adding up new 
%    input/output samples.
% 5. Example of how to compute indices when dealing with multiple outputs. 

% This script prepared by Francesca Pianosi and Fanny Sarrazin
% University of Bristol, 2014
% mail to: francesca.pianosi@bristol.ac.uk

%% Step 1: set paths
clc;clear;close; % Clear command window, workspace and close all figures
load ('..\..\..\..\00 Data\Select.mat') % Load Select.mat file
load ('..\..\..\..\00 Data\Data.mat') % Load Data.mat file
load ('..\..\..\..\00 Data\Cluster.mat') % Load Cluster.mat file
load ('..\..\..\..\00 Data\Cluster_Veri.mat') % Load Cluster_Veri.mat file

% initialization
WindowSize = 15; % Set window size to 15
length_day = 5113; % Set length of day to 5113 (warm up + calibration)

% field name
fieldn = {'N13302500','N04073500','N08085500','N06192500'};

for i = 1:length(fieldn)
    
my_dir = pwd ; % use the 'pwd' command if you have already setup the Matlab
% current directory to the SAFE directory. Otherwise, you may define
% 'my_dir' manually by giving the path to the SAFE directory, e.g.:
% my_dir = '/Users/francescapianosi/Documents/safe_R1.0';

% Set current directory to 'my_dir' and add path to sub-folders:
cd(my_dir)
addpath(genpath(my_dir))

    num = fieldn{i}; % Get current field name
    Main1_Data_units; % Run Main1_Data_units script

    output_folder = sprintf('..\\..\\..\\..\\00 Data\\Scheme3\\SA\\%s', num); % Set output folder path
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end



%% Step 2: setup the model and define input ranges


% Load data:
% % load -ascii LeafCatch.txt
% % rain = LeafCatch(1:365,1)   ;
% % evap = LeafCatch(1:365,2)   ;
% % flow = LeafCatch(1:365,3)   ;


% Define input distribution and ranges:
M  = 5 ; % number of uncertain parameters [ Sm beta alfa Rs Rf ]
DistrFun  = 'unif'  ; % Parameter distribution
DistrPar  = { [ 0 1500 ]; [ 0 2 ]; [ 0 1 ]; [ 0 1] ; [ 0 1 ] } ; % Parameter ranges

%% Step 3: Compute first-order and total-order variance-based indices

myfun = 'HYMOD1' ;
% warmup = 30 ; % lenght of model warmup period (days)
% (sensitivity indices will not be computed for the warmup period)

% Sample parameter space using the resampling strategy proposed by 
% (Saltelli, 2008; for reference and more details, see help of functions
% vbsa_resampling and vbsa_indices) 
SampStrategy = 'lhs' ;
N = 3000 ; % Base sample size.
% Comment: the base sample size N is not the actual number of input 
% samples that will be evaluated. In fact, because of the resampling
% strategy, the total number of model evaluations to compute the two
% variance-based indices is equal to N*(M+2) 
X = AAT_sampling(SampStrategy,M,DistrFun,DistrPar,2*N);
[ XA, XB, XC ] = vbsa_resampling(X) ;

% Run the model and compute selected model output at sampled parameter
% sets:
YA = model_execution(myfun,XA) ; % size (N,1)
YB = model_execution(myfun,XB) ; % size (N,1)
YC = model_execution(myfun,XC) ; % size (N*M,1)

% Compute main (first-order) and total effects:
[ Si, STi ] = vbsa_indices(YA,YB,YC);

% Plot results:
X_Labels = {'Huz','B','alpha','Kq','Ks'} ;
figure % plot main and total separately
subplot(121); boxplot1(Si,X_Labels,'main effects')
subplot(122); boxplot1(STi,X_Labels,'total effects')
saveas(gcf, fullfile(output_folder, 'main_and_total_separately.png')); % Save figure

figure % plot both in one plot:
boxplot2([Si; STi],X_Labels)
legend('main effects','total effects')% add legend
saveas(gcf, fullfile(output_folder, 'main_and_total_together.png')); % Save figure
% % Plot results:
% X_Labels = {'Huz','B','alpha','Kq','Ks'} ;
% figure % plot main and total separately
% subplot(121); boxplot1(Si,X_Labels,'main effects')
% subplot(122); boxplot1(STi,X_Labels,'total effects')
% figure % plot both in one plot:
% boxplot2([Si; STi],X_Labels)
% legend('main effects','total effects')% add legend

% Check the model output distribution (if multi-modal or highly skewed, the
% variance-based approach may not be adequate):
Y = [ YA; YC ] ;
figure; plot_cdf(Y,'NSE')
figure; plot_pdf(Y,'NSE');

% Compute confidence bounds:
Nboot = 500 ;
[ Si, STi, Si_sd, STi_sd, Si_lb, STi_lb, Si_ub, STi_ub ] = vbsa_indices(YA,YB,YC,Nboot);
% Plot:
figure % plot main and total separately
subplot(121); boxplot1(Si,X_Labels,'main effects',Si_lb,Si_ub)
subplot(122); boxplot1(STi,X_Labels,'total effects',STi_lb,STi_ub)
figure % plot both in one plot:
boxplot2([Si; STi],X_Labels,[ Si_lb; STi_lb ],[ Si_ub; STi_ub ])
legend('main effects','total effects')

% Analyze convergence of sensitivity indices:
NN = [N/10:N/10:N] ;
[ Sic, STic ] = vbsa_convergence([YA;YB;YC],M,NN);
figure
subplot(121); plot_convergence(Sic,NN*(M+2),[],[],[],'model evals','main effect',X_Labels)
subplot(122); plot_convergence(STic,NN*(M+2),[],[],[],'model evals','total effect',X_Labels);
% With confidence bounds:
[ Sic, STic, Si_sdc, STi_sdc, Si_lbc, STi_lbc, Si_ubc, STi_ubc  ] = vbsa_convergence([YA;YB;YC],M,NN,Nboot);
figure
subplot(121); plot_convergence(Sic,NN*(M+2),Si_lbc,Si_ubc,[],'model evals','main effect',X_Labels)
subplot(122); plot_convergence(STic,NN*(M+2),STi_lbc,STi_ubc,[],'model evals','total effect',X_Labels);
saveas(gcf, fullfile(output_folder, 'convergence_with_confidence_bounds.png')); % Save figure

% Save variables
save(fullfile(output_folder, 'vbsa_indices.mat'), 'Si', 'STi', 'Si_sd', 'STi_sd', 'Si_lb', 'STi_lb', 'Si_ub', 'STi_ub');
close all
end
% system('shutdown -s');
% %% Step 4: Adding up new samples
% 
% N2 = 500 ; % increase of base sample size
% % (that means: N2*(M+2) new samples that will need to be evaluated)
% 
% Xext = AAT_sampling_extend(X,DistrFun,DistrPar,2*(N+N2)) ; % extended sample 
% % (it includes the already evaluated samples 'X' and the new ones
% Xnew = Xext(2*N+1:end,:) ; % extract the new input samples that need to be evaluated
% % Resampling strategy:
% [ XA2, XB2,XC2 ] = vbsa_resampling(Xnew);
% % Evaluate model against new samples:
% YA2 =model_execution(myfun,XA2,rain,evap,flow,warmup); % should have size (N2,1)
% YB2 =model_execution(myfun,XB2,rain,evap,flow,warmup); % should have size (N2,1)
% YC2 =model_execution(myfun,XC2,rain,evap,flow,warmup); % should have size (N2*M,1)
% 
% % Put new and old results toghether:
% YAn = [ YA; YA2 ] ; % should have size (N+N2,1)
% YBn = [ YB; YB2 ] ; % should have size (N+N2,1)
% YCn = [ reshape(YC,N,M); reshape(YC2,N2,M) ] ; % should have size (N+N2,M)
% YCn = YCn(:); % should have size ((N+N2)*M,1)
% 
% % Recompute indices:
% Nboot = 500 ;
% [ Sin, STin, Si_sdn, STi_sdn, Si_lbn, STi_lbn, Si_ubn, STi_ubn ] = vbsa_indices(YAn,YBn,YCn,Nboot);
% 
% figure
% subplot(121)
% boxplot2([Si; STi],X_Labels,[ Si_lb; STi_lb ],[ Si_ub; STi_ub ]); title([ num2str(N*(M+2)) ' model eval.'])
% subplot(122)
% boxplot2([Sin; STin],X_Labels,[ Si_lbn; STi_lbn ],[ Si_ubn; STi_ubn ]); title([ num2str((N+N2)*(M+2)) ' model eval.'])
% legend('main effects','total effects')