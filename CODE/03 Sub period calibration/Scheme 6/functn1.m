function functionvalue=functn1(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = 0.5.*NSE(QOBS(hymod.date.ID_cali{2}),Qt(hymod.date.ID_cali{2}))+0.5.*LNSE(QOBS(hymod.date.ID_cali{2}),Qt(hymod.date.ID_cali{2}));
%     functionvalue = NSE(QOBS(hymod.date.ID_cali{2}),Qt(hymod.date.ID_cali{2}));
end