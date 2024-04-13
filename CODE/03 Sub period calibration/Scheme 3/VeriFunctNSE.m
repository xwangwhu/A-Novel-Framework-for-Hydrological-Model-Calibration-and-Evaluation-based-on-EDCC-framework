function functionvalue=VeriFunctNSE(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = NSE(QOBS(hymod.date.ID_veri{1}),Qt(hymod.date.ID_veri{1}));
end