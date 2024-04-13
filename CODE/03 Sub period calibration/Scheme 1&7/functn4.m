function functionvalue=functn4(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = 0.5.*NSE(QOBS(hymod.date.ID_cali{5}),Qt(hymod.date.ID_cali{5}))+0.5.*LNSE(QOBS(hymod.date.ID_cali{5}),Qt(hymod.date.ID_cali{5}));
%     functionvalue = NSE(QOBS(hymod.date.ID_cali{5}),Qt(hymod.date.ID_cali{5}));
end