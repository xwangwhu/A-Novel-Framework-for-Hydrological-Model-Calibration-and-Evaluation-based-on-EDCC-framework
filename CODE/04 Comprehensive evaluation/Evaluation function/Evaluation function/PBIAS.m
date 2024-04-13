% Percent bias
function pbias = PBIAS(Qobs, Qsim)
    pbias = 100 * sum(Qsim - Qobs) / sum(Qobs);
end