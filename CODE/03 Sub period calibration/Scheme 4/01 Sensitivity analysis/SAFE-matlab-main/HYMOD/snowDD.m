function Qout = snowDD(modelDay) %  effective precip after freezing/melting
global hymod

% If temperature is lower than threshold, precip is all snow
if hymod.data.avgTemp(modelDay) < hymod.parameters.Tth
    hymod.fluxes.snow(modelDay) = hymod.data.precip(modelDay);
    Qout = 0.0;
else % Otherwise, there is no snow and it's all rain
    hymod.fluxes.snow(modelDay) = 0.0;
    Qout = hymod.data.precip(modelDay);
end

% Add to the snow storage for this day
hymod.states.snow_store(modelDay) = hymod.states.snow_store(modelDay)+hymod.fluxes.snow(modelDay);

% Snow melt occurs if we are above the base temperature (either a fraction of the store, or the whole thing)

if hymod.data.avgTemp(modelDay) > hymod.parameters.Tb
    hymod.fluxes.melt(modelDay) = min(hymod.parameters.DDF.*(hymod.data.avgTemp(modelDay)-hymod.parameters.Tb), hymod.states.snow_store(modelDay));
    % Otherwise, snowmelt is zero
else
    hymod.fluxes.melt(modelDay) = 0.0;
end

% Update the snow storage depending on melt
hymod.states.snow_store(modelDay) = hymod.states.snow_store(modelDay)-hymod.fluxes.melt(modelDay);
if hymod.states.snow_store(modelDay) < 0.0
    hymod.states.snow_store(modelDay) = 0.0;
end
% Qout is any rain + snow melt
Qout =Qout+hymod.fluxes.melt(modelDay);