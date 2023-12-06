function estimateODMatrices(param,objCity)
%ESTIMATEODMATRICES - ver.1.0 (2022.01.12)
%   Estimates OD matrices from aggregated demand values.

%% INITIALIZATION OF VARIABLES
% Calculate Fi_t, Fi_q
Fi_t = param.ImbalanceAvg /(2*param.areaRet);
Fi_q = - param.ImbalanceAvg /(2*param.areaReq);

% Initialize parameter arrays
X_i = zeros(numel(objCity.vFreeFloatZones),1);
Y_i = zeros(numel(objCity.vFreeFloatZones),1);
area_i = zeros(numel(objCity.vFreeFloatZones),1);
dist_i = zeros(numel(objCity.vFreeFloatZones),1);
ret_i = zeros(numel(objCity.vFreeFloatZones),1);
req_i = zeros(numel(objCity.vFreeFloatZones),1);
Disc_Rq_Rt = zeros(numel(objCity.vFreeFloatZones),1);


%% AREAS AND DISTANCES TO IMBALANCE FOCUS
%%% Calculate total area and distance of each zone centroid
%   to the imbalance focus.
%
% Array of centroids and areas
for i=1:numel(objCity.vFreeFloatZones)
    % Zone centroid coordinates
    X_i(i) = objCity.vFreeFloatZones{i}.X;
    Y_i(i) = objCity.vFreeFloatZones{i}.Y;
    % Zone area
    area_i(i) = objCity.vFreeFloatZones{i}.zoneArea;
end
% Global area
areaTot = sum(area_i);

%%% Calculate distances to the imbalance focus/axis.
switch param.ImbalancePattern
    case 'flat'
        % Imbalance centre coordinates.
        % (Auxiliary: centroid of service area.)
        X_c = sum(X_i)/numel(X_i);
        Y_c = sum(Y_i)/numel(Y_i);
        % Distances
        d_rad = param.ImbDirection*(pi/180);
        dist_i = - sin(d_rad) * (X_i - X_c)...
           - cos(d_rad) * (Y_i - Y_c);
    case 'radial'
        % Imbalance centre coordinates.
        param.ImbCentre = str2num(param.ImbCentre);
        X_c = param.ImbCentre(1);
        Y_c = param.ImbCentre(2);
        % Distances
        dist_i = param.ImbDirection * ...
            sqrt((X_i-X_c).^2 + (Y_i-Y_c).^2);
end

%%% Check zones belonging to Rt or Rq subareas.
% Number of Rt and Rq zones.
N_Rq = round(param.areaReq * objCity.numFreeFloatZones);
N_Rt = min([round(param.areaRet * objCity.numFreeFloatZones), ...
    objCity.numFreeFloatZones - N_Rq]);

% The zones with highest positive distance belong to Rq.
[dist_Rq,idx_Rq] = maxk(dist_i,N_Rq);
Area_Rq = sum(area_i(idx_Rq));
Disc_Rq_Rt(idx_Rq) = -1;

% The zones with lowest positive distance (or highest
% negative) belong to Rt.
[dist_Rt,idx_Rt] = mink(dist_i,N_Rt);
Area_Rt = sum(area_i(idx_Rt));
Disc_Rq_Rt(idx_Rt) = 1;

%%% Correct distances.
dist_Corrector = 0;
% Rq zones. Select the minimum distance one.
[d,~] = min(dist_Rq);
dist_Corrector = dist_Corrector + d;
% Rt zones. Select the maximum distance one.
[d,~] = max(dist_Rt);
dist_Corrector = dist_Corrector + d;
% Balanced zones. Select all.
aux_dist_i = dist_i;
aux_dist_i(idx_Rq)=0;
aux_dist_i(idx_Rt)=0;
dist_Corrector = dist_Corrector + sum(nonzeros(aux_dist_i));
dist_Corrector = dist_Corrector/(numel(nonzeros(aux_dist_i))+2);
% Distance correction.
dist_i = dist_i - dist_Corrector;
dist_Rt = dist_Rt - dist_Corrector;
dist_Rt_avg = sum(dist_Rt)/N_Rt;
dist_Rq = dist_Rq - dist_Corrector;
dist_Rq_avg = sum(dist_Rq)/N_Rq;


%% BUILD MATRICES
% Initialize OD matrix struct
objCity.OD = struct();

%%% Spatial distribution
% Calculate total requests and returns per zone.
for i=1:numel(objCity.vFreeFloatZones)
    

    if Disc_Rq_Rt(i) == 1
        % Belongs to Rt
        % Fi_t>0
        req_i(i) = param.TotalTripsDay * ...
            objCity.vFreeFloatZones{i}.zoneArea/areaTot * ...
            (1 - (Fi_t/2) * dist_i(i)/dist_Rt_avg);

        ret_i(i) = param.TotalTripsDay * ...
            objCity.vFreeFloatZones{i}.zoneArea/areaTot * ...
            (1 + (Fi_t/2) * dist_i(i)/dist_Rt_avg);

    elseif Disc_Rq_Rt(i) == -1
        % Belongs to Rq
        % Fi_t <0
        req_i(i) = param.TotalTripsDay * ...
            objCity.vFreeFloatZones{i}.zoneArea/areaTot * ...
            (1 - (Fi_q/2) * dist_i(i)/dist_Rq_avg);

        ret_i(i) = param.TotalTripsDay * ...
            objCity.vFreeFloatZones{i}.zoneArea/areaTot * ...
            (1 + (Fi_q/2) * dist_i(i)/dist_Rq_avg);
    else
        req_i(i) = param.TotalTripsDay * ...
            objCity.vFreeFloatZones{i}.zoneArea/areaTot;
        ret_i(i) = req_i(i);
    end
end

%%% Time distribution
param.TimeWeight = str2num(param.TimeWeight);
param.TimeReDemand = param.TotalTime/numel(param.TimeWeight);
TotalWeight = sum(param.TimeWeight);

% Demand weight
for k=1:numel(param.TimeWeight)
    n=zeros(numel(objCity.vFreeFloatZones));
    for i=1:numel(objCity.vFreeFloatZones)  
        for j=1:numel(objCity.vFreeFloatZones)
            n(i,j) = param.TimeWeight(k)/TotalWeight *...
                req_i(i) * ret_i(j)/param.TotalTripsDay;
        end
    end
    objCity.OD(k).Matrix = sparse(n);
end                

%%% Trip distance distribution

end

