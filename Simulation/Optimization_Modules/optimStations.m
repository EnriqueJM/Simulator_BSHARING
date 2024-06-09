function [vStationsOut, vZonesOut] = optimStations(NStations, vStationsList,...
                    vZones, vServArea, OD, param)
% OPTIMSTATIONS - ver 1.2 (2022.01.26)
%   Selects the optimum station locations for the simulation. The total
%   number of stations and a candidate list are the main inputs.
%   Three different cases are considered:
%       - Select the first stations in the list.
%       - Select all stations in the list and create new ones on empty
%         zones. (No complete coverage.)
%       - Select all stations in the list and create new ones. (Complete
%         coverage.)
%   INPUTS:
%   - NStations -> Total number of stations in the system.
%   - vStationslist -> {Array Nx1} Array of station class objects. From an
%                      excel file with the list of possible stations.              
%   - vZones -> {Array Mx1} Array of FF_zone class objects.
%   - vServArea -> {Array Mx1} Array of structs with the geometry of zones.
%   - TotalCarsSB -> Total number of cars on stations.
%   - TotalCarsSB -> Total number of cars on streets.
%   - OD - {Array 24x1} Array with hourly demand matrices (sparse).
%   - Wmax -> Maximum walking distance.
%   - TotalTime -> Total number of time steps.
%   - default_cap -> Default capacity for created stations.
%   - default_char -> Default number of chargers for created stations.
%   OUTPUTS:
%   - vStationsOut -> {Array NStationsx1} Array of station class objects.
%   - vZonesOut -> {Array Mx1} Array of FF_zone class objects.
%
% ver 1.1
%   Remove percParking as an input, now included in the struct with the
%   geometry of zones.
% ver 1.2
%   Include default values as inputs.

% Parameters
TotalCarsSB = param.TotalCarsSB;
TotalCarsFF = param.TotalCarsFF;
Wmax = param.Wmax;
TotalTime = param.TotalTime;
default_cap = param.defaultCapacity;
default_char = param.defaultChargers;

% Number of zones and stations in the excel candidate list.
NZonesTotal = numel(vZones);
NList = numel(vStationsList);

% Empty zone search.
fun1 = @(x) vZones{x}.numStations == 0;
idx_ZonesEmpty = find(arrayfun(fun1, 1:NZonesTotal));
NZonesEmpty = length(idx_ZonesEmpty);

% Aggregation of 24h for all O/D demand pairs
M_od_tot = sparse(NZonesTotal,NZonesTotal);
for i=1:24
    M_od_tot = M_od_tot + OD(i).Matrix;
end

%% OPTIMIZATION: 3 POSSIBLE CASES
if NStations <= NList
    %%% Enough stations in the cnandidate list.
    % - The first are selected.
    vStationsOut = vStationsList(1:NStations);
    
    % The unselected stations are subtracted from the zone parameters.
    for i=(NStations+1):NList
        idx = vStationsList{i}.zoneID;
        vZones{idx}.numStations = vZones{idx}.numStations -1;  
    end
       
elseif (NStations > NList) && (NStations-NList <= NZonesEmpty)
    %%% Not enough stations in the list, but enough empty zones.
    % - All candidate stations in the list are included.
    % - The potential station imbalance is estimated for each empty zone.
    % - The most favorable ones are selected. (Maximize FF->SB trips.)
    % - Generated stations are located on zone centroids.
    disp('Creating additional stations.');
    
    % Expected fraction of demand generation and attraction if the station
    % is set on each one of the empty zones.
    pct_sb_dmd = zeros(NZonesEmpty,1);
    pct_sb_prk = zeros(NZonesEmpty,1);
    for i=1:NZonesEmpty
        idx = idx_ZonesEmpty(i);
        % Fraction of area covered by the stations. (max 1)
        coverage = min(1, (Wmax^2)/vZones{idx}.zoneArea);
        % Estimated fraction of demand on stations. (max 1)
        pct_sb_dmd(i) = TotalCarsSB/(TotalCarsSB+TotalCarsFF)*coverage;
        % Estimated fraction of parking on stations.  
        pct_sb_prk(i) = vServArea(idx).SB_PRK*coverage;
    end

    % Expected total requests and returns per zone.
    req = sum(M_od_tot(idx_ZonesEmpty),2);
    ret = sum(M_od_tot(idx_ZonesEmpty),1)';
    
    % Cost function: returns at the stations - requests at the station.
    cost = ret .* pct_sb_prk - req .* pct_sb_dmd;
    
    % The most favourable to balance SB->FF trips are selected.
    [~,k] = maxk(cost, NStations-NList);
    idx_Best = idx_ZonesEmpty(k);
    
    % Station creation
    vNewStations = cell(1,NStations-NList);
    for i=1:(NStations-NList)
        % Nuevo objeto Station, situada en la zona correspondiente y con
        % posición en el centroide.
        aux = Station();
        
        ID = 10000+i;
        X = vZones{idx_Best(i)}.X;
        Y = vZones{idx_Best(i)}.Y;
        Z = vZones{idx_Best(i)}.Z;
        
        initializeStation_manual(ID, X, Y, Z, TotalTime, aux);
      
        aux.zoneID = idx_Best(i);
        aux.capacity = default_cap;
        aux.numChargers = default_char;
        
        vNewStations{i} = aux;
        
        % Update the number of stations in the zone.
        vZones{idx_Best(i)}.numStations = vZones{idx_Best(i)}.numStations +1;
        
    end
    
    vStationsOut = [vStationsList, vNewStations];
    
else
    %%% More than one station per zone.
    % - All candidate stations in the list are included.
    % - Stations are set one by one in the zone with less station density.
    % - That forces to include at least one station on each zone. (Zones
    %   with no stations have zero density, which is minimum by default.)
    % - Generated stations are located in an internal random point.
    disp('Creating additional stations.');
    
    fun1 = @(x) vZones{x}.numStations;
    fun2 = @(x) vZones{x}.zoneArea;
    density = arrayfun(fun1, 1:NZonesTotal)./arrayfun(fun2, 1:NZonesTotal);
    
    % Creates a station in the zone with less density.
    vNewStations = cell(1,NStations-NList);
    for i=1:(NStations-NList)
        
        % Identify zone with less density of stations.
        [~,idx] = min(density);
        
        % Boundary nodes of zone
        XX = vServArea(idx).X;
        YY = vServArea(idx).Y;
        
        % New Station object in that zone with random internal location.
        aux = Station();
        
        ID = 10000+i;
        [X, Y] = randPointInZone(XX, YY);
        Z = vZones{idx}.Z;
        
        initializeStation_manual(ID, X, Y, Z, TotalTime, aux);
      
        aux.zoneID = idx;
        aux.capacity = default_cap;
        aux.numChargers = default_char;
        
        vNewStations{i} = aux;
        
        % Update the number of stations in the zone and density.
        vZones{idx}.numStations = vZones{idx}.numStations +1;
        density(idx) = vZones{idx}.numStations/vZones{idx}.zoneArea;
        
    end
    
    vStationsOut = [vStationsList, vNewStations];  
end

%% Generate list of stations inside every zone
for i=1:size(vStationsOut,2)
    zone = vStationsOut{i}.zoneID;
    %
    vZones{zone}.listStations(end+1) = i;
end

%% Generate list of stations in neighbor zones
for i=1:size(vZones,2)
    neig = vServArea(i).Neighbors;
    for l=1:size(neig,2)
        vZones{i}.listStations_neig = [vZones{i}.listStations_neig, vZones{neig(l)}.listStations]; % Stations in neighbor zones
    end
    vZones{i}.numStations_neig = size(vZones{i}.listStations_neig,2);
end

vZonesOut = vZones;

end

