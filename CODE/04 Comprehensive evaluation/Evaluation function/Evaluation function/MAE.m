% Mean absolute error
function mae = MAE(Qobs, Qsim)
    n = length(Qobs);
    mae = sum(abs(Qobs - Qsim)) / n;
end