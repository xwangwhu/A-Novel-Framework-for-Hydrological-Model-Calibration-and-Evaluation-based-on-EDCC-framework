function functionvalue=functn5(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = 0.5.*NSE(QOBS(hymod.date.ID_cali{6}),Qt(hymod.date.ID_cali{6}))+0.5.*LNSE(QOBS(hymod.date.ID_cali{6}),Qt(hymod.date.ID_cali{6}));
%     functionvalue = NSE(QOBS(hymod.date.ID_cali{6}),Qt(hymod.date.ID_cali{6}));
end