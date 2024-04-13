    clc;close;
    global BESTX BESTF ICALL PX PF hymod CallTimes
    CallTimes = 0;
%---Parameters set  
	% Execute the objective function. Set the upper and lower boundaries, as well as initial parameter set.	
    parameters = [0 	0.01 	0.01 	0.5 	0.01  0  -5  -5
1500 	2 	0.99 	1 	1  2  5  5
10 	1 	0.7 	0.5 	0.5  1  0  0
];

	bl=parameters(1,:);
    bu=parameters(2,:);
    x0=parameters(3,:);
    !copy functn12.m functn.m  
 
%---SCEUA set
    maxn    = 1000;                                                       % The maximum number of function evaluations allowed during optimization
    kstop   = 100;                                                         % The number of past evolution loops and their respective objective value to assess whether the marginal improvement at the current loop (in percentage) is less than pcento
    pcento  = 0.01;                                                       % The percentage change allowed in the past kstop loops below which convergence is assumed to be achieved.
    peps    = 0.001;                                                       % Value of the normalized geometric range of the parameters in the population below which convergence is deemed achieved.
    iseed   = -1;                                                          % The random seed number (for repetetive testing purpose)
    iniflg  = 0;                                                           % The flag for initial parameter array (=1, included it in initial  population; otherwise, not included)
    ngs     = 2;                                                           % The number of complexes (sub-populations), take more than the number of analysed parameters    

%---SCEUA run    
    [bestx,bestf,Parameters,Functions] = sceua(x0,bl,bu,maxn,kstop,pcento,peps,ngs,iseed,iniflg); 
    [Qobs,Qsim] = Hymod(bestx); 
    
%---Evaluation     
    nse  = NSE(Qobs(hymod.date.ID_cali{13}),Qsim(hymod.date.ID_cali{13}));
    lnse = LNSE(Qobs(hymod.date.ID_cali{13}),Qsim(hymod.date.ID_cali{13}));    
 
%---SCEUA variables    
    SCEUA.BESTX = BESTX;
    SCEUA.BESTF = BESTF;
    SCEUA.bestx = bestx;
    SCEUA.ICALL = ICALL;
    SCEUA.parameters = Parameters;
    SCEUA.functions = Functions;
    SCEUA.NSE   = nse;
    SCEUA.LNSE  = lnse;
    SCEUA.CallTimes = CallTimes;

%---clearvars       
    clearvars ans BESTF BESTX bl bu ICALL ID iniflg iseed kstop maxn... 
    nDays ngs parameters pcento peps PF PX x0 bestx lnse nse Qobs Qsim...    
    halfmonth0 halfmonth1 halfmonth2
    close;
    
    
%---save    
folder_name = fullfile('..', '..', '..','00 Data','Scheme1', num);
save(fullfile(folder_name, 'hymod12.mat'), 'hymod');
save(fullfile(folder_name, 'SCEUA12.mat'), 'SCEUA');