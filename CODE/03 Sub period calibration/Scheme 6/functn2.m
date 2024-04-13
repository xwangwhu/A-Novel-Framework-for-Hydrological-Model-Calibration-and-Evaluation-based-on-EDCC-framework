function functionvalue=functn2(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = 0.5.*NSE(QOBS(hymod.date.ID_cali{3}),Qt(hymod.date.ID_cali{3}))+0.5.*LNSE(QOBS(hymod.date.ID_cali{3}),Qt(hymod.date.ID_cali{3}));
%     functionvalue = NSE(QOBS(hymod.date.ID_cali{3}),Qt(hymod.date.ID_cali{3}));
end