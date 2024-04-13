function functionvalue=FunctNSE(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = NSE(QOBS(hymod.date.ID_cali{1}),Qt(hymod.date.ID_cali{1}));
end