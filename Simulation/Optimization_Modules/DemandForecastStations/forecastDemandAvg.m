function [vStationsOut, vZonesOut] = forecastDemandAvg(vStations, vZones, ...
                    vServArea, vRepoTeams, OD, param)...
% FORECASTDEMAND - ver 1.3 (2024.06.01)
%   Forecast the demand and creates vectors of total accumulated returns
%   and request on all time steps for each station and zone.
%   INPUTS:
%   - vStations -> {Array Nx1} Array of station class objects. From an
%                      excel file with the list of possible stations.              
%   - vZones -> {Array Mx1} Array of FF_zone class objects.
%   - vServArea -> {Array Mx1} Array of structs with the geometry of zones.
%   - TotalCarsSB -> Total number of cars on stations.
%   - TotalCarsSB -> Total number of cars on streets.
%   - OD - {Array 24x1} Array with hourly demand matrices (sparse).
%   - Wmax -> Maximum walking distance.
%   - TotalTime -> Total number of time steps.
%   OUTPUTS:
%   - vStationsOut -> {Array NStationsx1} Array of station class objects.
%   - vZonesOut -> {Array Mx1} Array of FF_zone class objects.
%
% ver 1.1
%   Remove percParking as an input, now included in the struct with the
%   geometry of zones.
% ver 1.2
%   Add expected task movements.
% ver 1.3
%   param as input.

%%% Parameters

TotalCarsSB = param.TotalCarsSB;
TotalCarsFF = param.TotalCarsFF;
TotalTime = param.TotalTime;
Wmax = param.Wmax;
disrp = param.forecast_disruption;

% Number of zones and stations
NZones = numel(vZones);
NStations = numel(vStations);

%%% Calculation of expected demand and parking fraction on street/station.
% Initialization of variables.
coverage = zeros(NZones,1);
pct_ff_dmd = zeros(NZones,1);
pct_sb_dmd = zeros(NZones,1);
pct_ff_prk = zeros(NZones,1);
pct_sb_prk = zeros(NZones,1);

    for i=1:NZones
        % Area fraction covered by stations. (max 1)
        coverage(i) = min(1, vZones{i}.numStations*(Wmax^2)/vZones{i}.zoneArea);

        % Estimated fraction of demand on street. (max 1)
        pct_ff_dmd(i) = 1 - TotalCarsSB/(TotalCarsSB+TotalCarsFF)*coverage(i);
        % Estimated fraction of demand per station. (max 1)
        if vZones{i}.numStations > 0
            pct_sb_dmd(i) = (1-pct_ff_dmd(i))/vZones{i}.numStations;
        end

        % Estimated fraction of parking on street. (max 1) 
        pct_ff_prk(i) = 1 - vServArea(i).SB_PRK*coverage(i);
        % Estimated fraction of parking per station. (max 1)
        if vZones{i}.numStations > 0
            pct_sb_prk(i) = (1-pct_ff_dmd(i))/vZones{i}.numStations;
        end   
    end

%%% Accumulated returns and requests for all time steps.
% (Note that on t=0, accumulated demand is zero.)

    rnd = random('unif',max([-1,-disrp]),disrp,[numel(vStations),2]);     % RANDOM ERROR
    
    for t=2:TotalTime+1

        OD_h = OD(ceil((t-1)/60)).Matrix;

        % Forecast on zones.
        for i=1:NZones
            vZones{i}.accRequests(t) = vZones{i}.accRequests(t-1)...
                + pct_ff_dmd(i) * sum(OD_h(i,:)) /60;

            vZones{i}.accReturns(t) = vZones{i}.accReturns(t-1)...
                + pct_ff_prk(i) * sum(OD_h(:,i)) /60;
        end

        % Forecast on stations.
        for i=1:NStations

            idx = vStations{i}.zoneID;
            vStations{i}.accRequests(t) = vStations{i}.accRequests(t-1)...
                + pct_sb_dmd(idx) * sum(OD_h(idx,:) *(1+rnd(i,1))) /60;

            vStations{i}.accReturns(t) = vStations{i}.accReturns(t-1)...
                + pct_sb_prk(idx) * sum(OD_h(:,idx) *(1+rnd(i,2))) /60;
        end
    end

%%% Add team tasks.
    for iteam=1:numel(vRepoTeams)
        if vRepoTeams{iteam}.status(1)==1 && numel(vRepoTeams{iteam}.taskList)>0
            istat = vRepoTeams{iteam}.taskList(1);
            t_end = vRepoTeams{iteam}.taskTime(1);
            y_end = vRepoTeams{iteam}.taskMovements(1);

            if t_end<=numel(vStations{istat}.accRequests)
                if y_end<0
                    vStations{istat}.accRequests(t_end:end) = ...
                        vStations{istat}.accRequests(t_end:end) - y_end;
                else
                    vStations{istat}.accReturns(t_end:end) = ...
                        vStations{istat}.accReturns(t_end:end) + y_end;
                end
            end
        end  
    end

% Storing results
for istat=1:numel(vStations)
    vStations{istat}.predRequests = vStations{istat}.accRequests;
    vStations{istat}.predReturns = vStations{istat}.accReturns;
end  
vZonesOut = vZones;
vStationsOut = vStations;


end

