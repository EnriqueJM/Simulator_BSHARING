function [vStationsOut, param] = readDistribution(vStations, param, SBvFF)
%READDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here

%%% Step 1: Read the initial distribution from the excel file.
disp('Reading the Initial Distribution of vehicles file.');
try
    [data, text] = xlsread(param.IniDistributionFile);
    text(1,:) = [];                                            % Remove first row of titles
catch
    error(['Error when reading file: ' param.InputStationFile]);
end



%%% Step 2: Check each station and add as many vehicles as indicated in the
%%% excel file.

tot_vehicles = 0;

% Loop for all stations.
for istat=1:numel(vStations)
    idx_stat = vStations{istat}.ID;
    
    idx_file = find(data(:,1)==idx_stat);
    
    vStations{istat}.optCars(1) = data(idx_file,2);
    
    tot_vehicles = tot_vehicles + data(idx_file,2);
    %
end

% Change the total number of vehicles to the set by 
if SBvFF == 'SB'
    param.TotalCarsSB = tot_vehicles;
elseif SBvFF == 'FF'
    param.TotalCarsFF = tot_vehicles;
end

vStationsOut = vStations;


end

