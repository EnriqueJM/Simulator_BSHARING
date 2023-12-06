function outputZonification(param, MyCity, nameDir)
%OUTPUTZONIFICATION ver 1.1 - 2022.01.15
%   Export zonification as a shapefile.
%
% INPUTS:
%   - param.OutputShape -> Name of the exported shapefile.
%   - MyCity.servArea -> Service area shapefile.
%   - nameDir -> Route of the directory where the shapefile will be saved.


%% Empty zonification with ID numbers (.JPG)
%
SArea = MyCity.servArea;
vZones = MyCity.vFreeFloatZones;
% Get ID zone list and centroid coordinates.
X = zeros(numel(vZones),1);
Y = X;
ID = X;
for i=1:numel(vZones)
    X(i) = vZones{i}.X;
    Y(i) = vZones{i}.Y;
    ID(i) = vZones{i}.ID;
end
% Generate figure
figure('Visible','off');
hold on;
mapshow(SArea);
scatter(X,Y,5,'red','filled');
dx = 0.1;
dy = 0.1;
ID = string(ID);
text(X+dx, Y+dy, ID, 'FontSize', 6);
hold off
% Title and axis
title('Zonification', 'Interpreter','none');
xlabel('X UTM Coordinate [m]')
ylabel('Y UTM Coordinate [m]')
% Print figure to jpg file
filename = [nameDir 'Zonification.jpg'];
saveas(gcf,filename);
close(gcf);


%% Shapefile Output
% (Only if custom-created)
if param.ServiceArea == 0
        
    % Read reference shape file
    mainDir = getExecutableFolder();
    S=shaperead([mainDir '/Data/Aux_inputs/shape_ref.shp']);

    % Generate structure for exporting shape file
    for ielem = 1:numel(MyCity.servArea)
        %
        S(ielem).Geometry = S(1).Geometry;
        S(ielem).CODE = S(1).CODE;
        S(ielem).NAME = S(1).NAME;
        S(ielem).TYPENO = S(1).TYPENO;
        %
        S(ielem).X = MyCity.servArea(ielem).X;
        S(ielem).Y = MyCity.servArea(ielem).Y;
        S(ielem).NO = MyCity.servArea(ielem).NO;
        S(ielem).BoundingBox = MyCity.servArea(ielem).BoundingBox;
        %
        S(ielem).SB_PRK = MyCity.servArea(ielem).SB_PRK;
    end

    % Saving
    [status, ~, ~] = mkdir(nameDir,'custom_shp');
    if status == 0
        error('Error: Output folder could not be created');
    end
    shapewrite(S,[nameDir 'custom_shp/' param.OutputShape]);
end



end

