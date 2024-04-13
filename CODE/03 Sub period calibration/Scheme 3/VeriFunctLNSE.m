function functionvalue=VeriFunctLNSE(parameters)
    global hymod
    [QOBS,Qt]    = Hymod(parameters);      
    functionvalue = LNSE(QOBS(hymod.date.ID_veri{1}),Qt(hymod.date.ID_veri{1}));
end