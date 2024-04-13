function functionvalue=functn8(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = 0.5.*NSE(QOBS(hymod.date.ID_cali{9}),Qt(hymod.date.ID_cali{9}))+0.5.*LNSE(QOBS(hymod.date.ID_cali{9}),Qt(hymod.date.ID_cali{9}));
%     functionvalue = NSE(QOBS(hymod.date.ID_cali{8}),Qt(hymod.date.ID_cali{8}));
end