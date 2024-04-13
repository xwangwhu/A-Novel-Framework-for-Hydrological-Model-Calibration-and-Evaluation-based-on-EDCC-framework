function functionvalue=functn7(parameters)
    global hymod
    [QOBS,Qt]     = Hymod(parameters);      
    functionvalue = 0.5.*NSE(QOBS(hymod.date.ID_cali{8}),Qt(hymod.date.ID_cali{8}))+0.5.*LNSE(QOBS(hymod.date.ID_cali{8}),Qt(hymod.date.ID_cali{8}));
%     functionvalue = NSE(QOBS(hymod.date.ID_cali{8}),Qt(hymod.date.ID_cali{8}));
end