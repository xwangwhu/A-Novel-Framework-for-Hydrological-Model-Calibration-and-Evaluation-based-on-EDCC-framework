% Log root mean square error
function lrmse = LRMSE(Qobs, Qsim)
    n = length(Qobs);
    lrmse = sqrt(sum((log(Qobs + 1) - log(Qsim + 1)).^2) / n);
end