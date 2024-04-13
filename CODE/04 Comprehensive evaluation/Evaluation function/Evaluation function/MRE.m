% Mean relative error
function mre = MRE(Qobs, Qsim)
    n = length(Qobs);
    mre = sum(abs((Qobs - Qsim) ./ Qobs)) / n;
end