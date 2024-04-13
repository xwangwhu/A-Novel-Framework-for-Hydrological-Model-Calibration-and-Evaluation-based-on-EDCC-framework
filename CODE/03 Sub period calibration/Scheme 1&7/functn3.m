function functionvalue=functn3(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = 0.5.*NSE(QOBS(hymod.date.ID_cali{4}),Qt(hymod.date.ID_cali{4}))+0.5.*LNSE(QOBS(hymod.date.ID_cali{4}),Qt(hymod.date.ID_cali{4}));
%     functionvalue = NSE(QOBS(hymod.date.ID_cali{4}),Qt(hymod.date.ID_cali{4}));
end