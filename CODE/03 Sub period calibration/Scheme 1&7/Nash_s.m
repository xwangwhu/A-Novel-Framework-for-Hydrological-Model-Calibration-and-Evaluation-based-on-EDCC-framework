function Qout = Nash_s(K,N,Qin,modelDay) % Qout, Flow out of series of reservoirs
global hymod
% Initialization    
OO = zeros(N,1);

% Loop through reservoirs
for Res = 1:N

    OO(Res) = K.*hymod.states.Xs(modelDay,Res);
    hymod.states.Xs(modelDay,Res)  = hymod.states.Xs(modelDay,Res) - OO(Res);

    if Res==1
        hymod.states.Xs(modelDay,Res) = hymod.states.Xs(modelDay,Res) + Qin; 
    else
        hymod.states.Xs(modelDay,Res) = hymod.states.Xs(modelDay,Res) + OO(Res-1);
    end
end

% The outflow from the cascade is the outflow from the last reservoir
Qout = OO(N);                     % Flow out of series of reservoirs
clear OO;

