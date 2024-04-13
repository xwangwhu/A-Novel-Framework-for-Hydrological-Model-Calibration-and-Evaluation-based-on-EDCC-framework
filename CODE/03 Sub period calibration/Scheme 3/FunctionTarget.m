function fval = FunctionTarget(parameters)
    fval(1) = FunctNSE(parameters);
    fval(2) = FunctLNSE(parameters);
end
