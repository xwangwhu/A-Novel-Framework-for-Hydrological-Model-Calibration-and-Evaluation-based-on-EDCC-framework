 function calculateHamonPE(modelDay)   
    global hymod 
    hymod.fluxes.PE(modelDay) = hymod.data.evap(modelDay);
