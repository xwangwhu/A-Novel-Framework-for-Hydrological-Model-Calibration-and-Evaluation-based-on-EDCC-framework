    clc;close;
    global BESTX BESTF ICALL PX PF hymod

%---Parameters set
	% Execute the objective function. Set the upper and lower boundaries, as well as initial parameter set.	
    nclust = length(hymod.date.ID)-1;
    para =  [10 	0.01 	0.01 	0.5 	0.01
        1000 	1.99 	0.99 	1 	0.5
        500 	1.5 	0.5 	0.75 	0.25];
    parameters = repmat(para, 1, nclust);

	bl=parameters(1,:);
    bu=parameters(2,:);
    x0=parameters(3,:);
    !copy functn0.m functn.m  
 
%---SCEUA set
    maxn    = 1000;                                                       % The maximum number of function evaluations allowed during optimization
    kstop   = 50;                                                         % The number of past evolution loops and their respective objective value to assess whether the marginal improvement at the current loop (in percentage) is less than pcento
    pcento  = 0.01;                                                       % The percentage change allowed in the past kstop loops below which convergence is assumed to be achieved.
    peps    = 0.001;                                                       % Value of the normalized geometric range of the parameters in the population below which convergence is deemed achieved.
    iseed   = -1;                                                          % The random seed number (for repetetive testing purpose)
    iniflg  = 0;                                                           % The flag for initial parameter array (=1, included it in initial  population; otherwise, not included)
    ngs     = 2;                                                           % The number of complexes (sub-populations), take more than the number of analysed parameters    

%---SCEUA run    
    [bestx] = sceua(x0,bl,bu,maxn,kstop,pcento,peps,ngs,iseed,iniflg); 
    [Qobs,Qsim] = Hymod(bestx); 
    
%---Evaluation     
    nse  = NSE(Qobs(hymod.date.ID_cali{1}),Qsim(hymod.date.ID_cali{1}));
    lnse = LNSE(Qobs(hymod.date.ID_cali{1}),Qsim(hymod.date.ID_cali{1}));    
 
%---SCEUA variables    
    SCEUA.BESTX = BESTX;
    SCEUA.BESTF = BESTF;
    SCEUA.bestx = bestx;
    SCEUA.ICALL = ICALL;
    SCEUA.PX    = PX;
    SCEUA.PF    = PF;
    SCEUA.NSE   = nse;
    SCEUA.LNSE  = lnse;
    
%---clearvars       
    clearvars ans BESTF BESTX bl bu ICALL ID iniflg iseed kstop maxn... 
    nDays ngs parameters pcento peps PF PX x0 bestx lnse nse Qobs Qsim...    
    halfmonth0 halfmonth1 halfmonth2
    close;
    
%---save    
folder_name = fullfile('..', '..','00 Data','Scheme4', num);
save(fullfile(folder_name, 'hymod0.mat'), 'hymod');
save(fullfile(folder_name, 'SCEUA0.mat'), 'SCEUA');
