function functionvalue=FunctLNSE(parameters)
    global hymod
    [QOBS,Qt]    = Hymod(parameters);      
    functionvalue = LNSE(QOBS(hymod.date.ID_cali{1}),Qt(hymod.date.ID_cali{1}));
end