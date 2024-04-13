function functionvalue=functn6(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = 0.5.*NSE(QOBS(hymod.date.ID_cali{7}),Qt(hymod.date.ID_cali{7}))+0.5.*LNSE(QOBS(hymod.date.ID_cali{7}),Qt(hymod.date.ID_cali{7}));
%     functionvalue = NSE(QOBS(hymod.date.ID_cali{7}),Qt(hymod.date.ID_cali{7}));
end