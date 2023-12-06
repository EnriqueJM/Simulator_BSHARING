function outputStations(param, MyCity, nameDir)
%OUTPUTSTATIONS - ver 2.0 (2022.01.16)
%   Export stations (imported+generated) on an excel spreadsheet.
%
% INPUTS:
%   - param.OutputStationFile -> Name of the exported excel file.
%   - MyCity.servArea -> Service area shapefile.
%   - MyCity.vStations -> Array of stations.
%   - nameDir -> Route of the directory where the shapefile will be saved.


%% Load inputs
SArea = MyCity.servArea;
vStations = MyCity.vStations;
filename = param.OutputStationFile;

%% Output Excel spreadsheet with stations used during the simulation
data = {'ID','Name','X','Y','Z','Cap','e-Chargers'};
%
for i=1:numel(vStations)
    %
    data(end+1,:) = {vStations{i}.ID, vStations{i}.Name, ...
        vStations{i}.X, vStations{i}.Y, vStations{i}.Z, ...
        vStations{i}.capacity, vStations{i}.numChargers};
end
%
writecell(data, [nameDir '/' filename]);


%% Station map with ID numbers (.JPG)
%
% Get ID zone list and centroid coordinates.
X = zeros(numel(vStations),1);
Y = X;
ID = X;
for i=1:numel(vStations)
    X(i) = vStations{i}.X;
    Y(i) = vStations{i}.Y;
    ID(i) = vStations{i}.ID;
%     if isempty(vStations{i}.Name)
%         ID(i) = num2str(vStations{i}.ID);
%     else
%         ID(i) = string(char(vStations{i}.Name));
%     end
end
% Generate figure
figure('Visible','off');
hold on;
mapshow(SArea, 'EdgeColor', 'none') 
scatter(X,Y,6,'red','filled');
dx = 0.4;
dy = 0.4;
ID = string(ID);
text(X+dx, Y+dy, ID, 'FontSize', 7);
hold off
% Title and axis
title('Stations', 'Interpreter','none');
xlabel('X UTM Coordinate [m]')
ylabel('Y UTM Coordinate [m]')
% Print figure to jpg file
filename = [nameDir 'Stations.jpg'];
saveas(gcf,filename);
close(gcf);
end

