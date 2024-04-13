function functionvalue=functn0(parameters)

weight = [0.343701354 0.173798288 0.099804516 0.148521675 0.234174167];

global hymod
[QOBS,Qt]     = Hymod(parameters);
rmse = RMSE(QOBS(hymod.date.ID_cali{1}),Qt(hymod.date.ID_cali{1}));

w_rmse = weight.*rmse;
functionvalue = sum(w_rmse);

end