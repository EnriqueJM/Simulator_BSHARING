function outputIniDistribution(vStations, t, nameDir)
%OUTPUTINIDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here

data = {'ID','Initial vehicles'};
%
for i=1:numel(vStations)
    %
    data(end+1,:) = {vStations{i}.ID, vStations{i}.optCars(1)};
end
%
writecell(data, [nameDir '/' t '_initial_distribution_SB.xlsx']);


end

