function functionvalue=functn0(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = 0.5.*NSE(QOBS(hymod.date.ID_cali{1}),Qt(hymod.date.ID_cali{1}))+0.5.*LNSE(QOBS(hymod.date.ID_cali{1}),Qt(hymod.date.ID_cali{1}));
end