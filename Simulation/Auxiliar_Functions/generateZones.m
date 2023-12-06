function [S] = generateZones(Perim, param)
% GENERATEZONES - ver. 1.1 (2022.01.13)
% Function to generate zones as structured quad mesh.
% (Does not export results)
%
xmin = min(Perim(1,:)) - 0.2*param.Wmax; xmax = max(Perim(1,:)) + 0.2*param.Wmax; % Slightly increase the service area for zonification
ymin = min(Perim(2,:)) - 0.2*param.Wmax; ymax = max(Perim(2,:)) + 0.2*param.Wmax;
%
nelem_x = ceil((xmax-xmin)/param.Wmax);
nelem_y = ceil((ymax-ymin)/param.Wmax);
nelem = nelem_x * nelem_y;
%
npoin_x = nelem_x + 1;
npoin_y = nelem_y + 1;
npoin = npoin_x * npoin_y;
%
T = zeros(nelem, 4);    % Connectivity matrix (nodes per element)
X = zeros(npoin,1);     % X coordinate
Y = zeros(npoin,1);     % Y coordinate
%
% Generate coordinates X, Y
for j=1:npoin_y
    for i=1:npoin_x
        X(npoin_x*(j-1)+i) = xmin + (i-1)*param.Wmax;
        Y(npoin_x*(j-1)+i) = ymin + (j-1)*param.Wmax;
    end
end
%
% Generate connectivity matrix T
for j=1:nelem_y
    for i=1:nelem_x
        T(nelem_x*(j-1)+i,:) = [npoin_x*(j-1)+i (npoin_x*j)+i (npoin_x*j)+(i+1) npoin_x*(j-1)+(i+1)];
    end
end
%
% Find nodes inside the polygon (boundary)
XB = Perim(1,:);
YB = Perim(2,:);
%
in = inpolygon(X,Y,XB,YB);
list_el = [];
for ielem=1:nelem
    if sum(in(T(ielem,:))) < 4  % Look for elements to exclude with at least one node outside the polygon
        list_el(end+1) = ielem;
    end
end
T(list_el,:) = [];
nelem = size(T,1);

% DISPLAY OF RESULTING ZONIFICATION
% if param.verbose
%     %disp('nelem_x'); disp(nelem_x);
%     %disp('nelem_y'); disp(nelem_y);
%     disp('nzones'); disp(nelem);
%     %disp('npoin_x'); disp(npoin_x);
%     %disp('npoin_y'); disp(npoin_y);
%     disp('npoin'); disp(npoin);
%     %
%     hold on;
%     patch('Faces',T,'Vertices',[X, Y],'FaceColor','none');
% end

% Read reference shape file
mainDir = getExecutableFolder();
S=shaperead([mainDir '/Data/Aux_inputs/shape_ref.shp']);

% Generate structure for exporting shape file
for ielem = 1:size(T,1)

    % Node coordinates in element
    X_aux = [X(T(ielem,:)); X(T(ielem,1))]; % Add initial point at the end to close the polygon
    Y_aux = [Y(T(ielem,:)); Y(T(ielem,1))];
    %
    S(ielem).Geometry = S(1).Geometry;
    S(ielem).CODE = S(1).CODE;
    S(ielem).NAME = S(1).NAME;
    S(ielem).TYPENO = S(1).TYPENO;
    %
    S(ielem).X = X_aux;
    S(ielem).Y = Y_aux;
    S(ielem).NO = ielem;
    S(ielem).BoundingBox = [min(X_aux), min(Y_aux); max(X_aux), max(Y_aux)];
    %
    S(ielem).SB_PRK = param.percParking;
end

% Save shape file
% shapewrite(S,param.OutputShape);
%