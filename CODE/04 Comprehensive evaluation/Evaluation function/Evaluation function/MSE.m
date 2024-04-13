% Mean square error
function mse = MSE(Qobs, Qsim)
    n = length(Qobs);
    mse = sum((Qobs - Qsim).^2) / n;
end