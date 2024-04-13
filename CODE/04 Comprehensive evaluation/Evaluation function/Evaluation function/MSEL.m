% mean square error of log discharge
function msel = MSEL(Qobs, Qsim)
    n = length(Qobs);
    msel = sum((log10(Qobs + 1) - log10(Qsim + 1)).^2) / n;
end