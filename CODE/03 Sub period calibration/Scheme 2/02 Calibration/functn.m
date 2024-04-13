function functionvalue=functn0(parameters)

weight = [0.27081127	0.159974655	0.078428693	0.23990804	0.250877342];

global hymod
[QOBS,Qt]     = Hymod(parameters);
rmse = RMSE(QOBS(hymod.date.ID_cali{1}),Qt(hymod.date.ID_cali{1}));

w_rmse = weight.*rmse;
functionvalue = sum(w_rmse);

end