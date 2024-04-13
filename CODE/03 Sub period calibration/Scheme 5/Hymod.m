function [Qobs,Qsim]=Hymod(parameters)   

% Copyright (C) 2010-2013 Jon Herman, Josh Kollat, and others.
% 
% Hymod is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% Hymod is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public License
% along with Hymod.  If not, see <http://www.gnu.org/licenses/>.

global hymod CallTimes
nclust = length(hymod.date.ID)-1;
%---hymod_parameters
    % Assign parameter values for this run
    % Rate constants Ks and Kq should be specified in units of time-1, 0 < Ks < Kq < 1   
    P = zeros(nclust, 5);
    for i = 1:nclust
        P(i,1) = parameters(5*(i-1)+1); % Maximum height of soil moisture accounting tank - Range [0, 1000]
        P(i,2) = parameters(5*(i-1)+2); % Scaled distribution function shape parameter - Range [0, 2]
        P(i,3) = parameters(5*(i-1)+3); % Quick/slow split parameter - Range [0, 0.99]
        P(i,4) = parameters(5*(i-1)+4); % Quickflow routing tanks' rate parameter - Range [0, 0.99]
        P(i,5) = parameters(5*(i-1)+5); % Slowflow routing tank's rate parameter - Range [0, 0.99]
%         % Snow parameters (degree-day model)
%         P(i,6) = parameters(5*(i-1)+6);      % Degree day factor                               - Range [ 0, 2]
%         P(i,7) = parameters(5*(i-1)+7);      % Temperature threshold                           - Range [-5, 5]
%         P(i,8) = parameters(5*(i-1)+8);       % Base temperature to calculate melt              - Range [-5, 5]
    end

    for i=1:nclust
        para.Huz(hymod.date.ID{i+1})=P(i,1);      % Maximum height of soil moisture accounting tank - Range [0, 1000]
        para.B(hymod.date.ID{i+1})=P(i,2);        % Scaled distribution function shape parameter    - Range [0,    2]
        para.alpha(hymod.date.ID{i+1})=P(i,3);    % Quick/slow split parameter                      - Range [0, 0.99]
        para.Kq(hymod.date.ID{i+1})=P(i,4);       % Quickflow routing tanks' rate parameter         - Range [0, 0.99]
        para.Ks(hymod.date.ID{i+1})=P(i,5);       % Slowflow routing tank's rate parameter          - Range [0, 0.99]
        para.DDF(hymod.date.ID{i+1})=1;
        para.Tth(hymod.date.ID{i+1})=0;
        para.Tb(hymod.date.ID{i+1})=0;
    end

    
%---Initialization  
        nDays=hymod.date.nDays;
        hymod.parameters.Nq = 3;
%-------Initialize hymod states 
        hymod.states.XHuz=zeros(nDays,1);        % Model computed upper zone soil moisture tank state height
        hymod.states.XCuz=zeros(nDays,1);        % Model computed upper zone soil moisture tank state contents
        hymod.states.Xq=zeros(nDays,3);          % Model computed quickflow tank states contents
        hymod.states.Xs=zeros(nDays,1);          % Model computed slowflow tank state contents
        hymod.states.snow_store=zeros(nDays,1);  % State of snow reservoir
    
%-------Initialize hymod_fluxes
        hymod.fluxes.effPrecip=zeros(nDays,1);   % Effective rain entering the SMA model (melt+precip if using snow model)
        hymod.fluxes.AE=zeros(nDays,1);          % Model computed actual evapotranspiration flux
        hymod.fluxes.OV=zeros(nDays,1);          % Model computed precipitation excess flux
        hymod.fluxes.Qq=zeros(nDays,1);          % Model computed quickflow flux
        hymod.fluxes.Qs=zeros(nDays,1);          % Model computed slowflow flux
        hymod.fluxes.Q=zeros(nDays,1);           % Model computed total streamflow flux
        hymod.fluxes.snow=zeros(nDays,1);        % Daily snow
        hymod.fluxes.melt=zeros(nDays,1);        % Snow melt
        hymod.fluxes.PE=zeros(nDays,1);          % Potential ET (Hamon)

%---Run Model for Simulation Period
        % Time period
        % Calculate the Hamon Potential Evaporation for the time series
        %  calculateHamonPE(nDays);
        hymod.fluxes.PE=hymod.data.evap;

    for modelDay=1:nDays 
        hymod.parameters.Huz=para.Huz(modelDay);      % Maximum height of soil moisture accounting tank - Range [0, 1000]
        hymod.parameters.B=para.B(modelDay);        % Scaled distribution function shape parameter    - Range [0,    2]
        hymod.parameters.alpha=para.alpha(modelDay);    % Quick/slow split parameter                      - Range [0, 0.99]
        hymod.parameters.Kq=para.Kq(modelDay);       % Quickflow routing tanks' rate parameter         - Range [0, 0.99]
        hymod.parameters.Ks=para.Ks(modelDay);       % Slowflow routing tank's rate parameter          - Range [0, 0.99]
        hymod.parameters.DDF=para.DDF(modelDay);
        hymod.parameters.Tth=para.Tth(modelDay);
        hymod.parameters.Tb=para.Tb(modelDay);
        % Given/calculated parameters
        hymod.parameters.Kv=1.0;                 % Vegetation adjustment to PE                     - Range [0.1,  2]
        hymod.parameters.Cpar=hymod.parameters.Huz/(1.0+hymod.parameters.B);       % Maximum combined contents of all stores (calculated from Huz and B)

        % Run snow model to find effective precip for this timestep     
        hymod.fluxes.effPrecip(modelDay) = snowDD(modelDay);
        % Run Pdm soil moisture accounting including evapotranspiration
        PDM_soil_moisture(modelDay);
        % Run Nash Cascade routing of quickflow component
        new_quickflow = hymod.parameters.alpha .* hymod.fluxes.OV(modelDay);
        hymod.fluxes.Qq(modelDay) = Nash_q(hymod.parameters.Kq, hymod.parameters.Nq, new_quickflow,modelDay);     
        % Run Nash Cascade routing of slowflow component
        new_slowflow = (1.0-hymod.parameters.alpha).* hymod.fluxes.OV(modelDay);
        hymod.fluxes.Qs(modelDay) = Nash_s(hymod.parameters.Ks, 1, new_slowflow,modelDay);     
        % Set the intial states of the next time step to those of the current time step
        if modelDay < nDays        
            hymod.states.XHuz(modelDay+1) = hymod.states.XHuz(modelDay);
            hymod.states.Xs(modelDay+1)   = hymod.states.Xs(modelDay);
            hymod.states.snow_store(modelDay+1) = hymod.states.snow_store(modelDay);
            for m=1:hymod.parameters.Nq
                hymod.states.Xq(modelDay+1,m) =hymod.states.Xq(modelDay,m);
            end
        end
        hymod.fluxes.Q(modelDay) = hymod.fluxes.Qq(modelDay) + hymod.fluxes.Qs(modelDay);  
    end
    Qsim = hymod.fluxes.Q;
    Qobs = hymod.data.flow;
    CallTimes = CallTimes+1;
end
