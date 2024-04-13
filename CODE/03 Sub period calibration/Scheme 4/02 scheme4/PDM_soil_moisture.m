function PDM_soil_moisture(modelDay)
global hymod
% Storage contents at begining
Cbeg = hymod.parameters.Cpar.*(1.0 - (1.0-hymod.states.XHuz(modelDay)./hymod.parameters.Huz).^(1.0+hymod.parameters.B));
% Compute overflow from soil moisture storage element
OV2 = max(0.0,(hymod.fluxes.effPrecip(modelDay) + hymod.states.XHuz(modelDay) - hymod.parameters.Huz));
% Remaining net rainfall
PPinf = hymod.fluxes.effPrecip(modelDay) - OV2;
% New actual height in the soil moisture storage element
Hint = min(hymod.parameters.Huz, hymod.states.XHuz(modelDay) + PPinf);
% New storage content
Cint = hymod.parameters.Cpar.*(1.0-(1.0-Hint./hymod.parameters.Huz).^(1.0+hymod.parameters.B));
% Additional effective rainfall produced by overflow from stores smaller than Cmax
OV1 = max(0.0, (PPinf + Cbeg - Cint));
% Compute total overflow from soil moisture storage element
hymod.fluxes.OV(modelDay) = OV1 + OV2;
% Compute actual evapotranspiration
hymod.fluxes.AE(modelDay) = min(Cint,(Cint/hymod.parameters.Cpar).*hymod.fluxes.PE(modelDay).*hymod.parameters.Kv);
% Storage contents and height after ET occurs
hymod.states.XCuz(modelDay) = max(0.0,(Cint - hymod.fluxes.AE(modelDay)));
hymod.states.XHuz(modelDay) = hymod.parameters.Huz.*(1.0-(1.0-hymod.states.XCuz(modelDay)./hymod.parameters.Cpar).^(1.0/(1.0+hymod.parameters.B)));