function hymod_nse = HYMOD1(parameters)
global hymod
    [Qobs,Qsim] = Hymod(parameters);
    hymod_nse = NSE(Qobs(hymod.date.ID_cali{1}),Qsim(hymod.date.ID_cali{1}));
end