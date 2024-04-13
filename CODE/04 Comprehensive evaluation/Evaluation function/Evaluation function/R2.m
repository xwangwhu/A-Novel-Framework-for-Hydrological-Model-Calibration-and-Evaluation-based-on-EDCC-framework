% coefficient of determination
function r2 = R2(Qobs, Qsim)
    mean_Qobs = mean(Qobs);
    SS_tot = sum((Qobs - mean_Qobs).^2);
    SS_res = sum((Qobs - Qsim).^2);
    r2 = 1 - SS_res / SS_tot;
end
