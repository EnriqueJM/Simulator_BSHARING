function [outDmdParam] = calculateImbalanceParam(param, MyCity, t, fldrname)
%CALCULATEIMBALANCEPARAM - ver. 1.0 (2022.01.07)
%   Detailed explanation goes here
%
%   INPUTS:
%   - matOD -> OD matrix           
%   - vZones -> Array of FF_zone class objects.
%
%   OUTPUTS:
%   - vRepoTeamsOut -> Array of repositioning teams objects.
%   - param -> Struct of parameters. Includes:
%               - lambda_max -> Maximum potential demand density.
%               -  -> Average trip distance.
%               -  -> Fraction of service area where requests>returns.
%               -  -> Fraction of service area where requests<returns.
%               - Fi_tot -> Fraction of imbalanced demand.
%               - CV_t -> Coefficient of temporal variation.
%               - CV_s -> Coefficient of satial variation.
%               - dist_qt -> Temporal standard deviation.

%% Inicialization of variables
SArea = MyCity.servArea;
matOD = MyCity.OD;
vZones = MyCity.vFreeFloatZones;
% (Ignore this. Only for using this function for analizing a shortened time
% period. In that case, these parameters must be changed by the first and
% last element of the analyzed interval. But for the simulator, we take
% always the whole cycle of 24h.)
fst = 1;
lst = numel(matOD);
period = (lst - fst + 1); % Includes both

% Number and duration of demand update steps (usually hours) and zones.
num_h = numel(matOD);
num_z = numel(vZones);
time_h = param.TimeReDemand/60;

% Demand matrix, total trips, and density
dmd_mtx_24h = zeros(num_z,num_z,num_h);
dmd_tot = zeros(num_h,1);
dmd_den = zeros(num_h,1);

% Distances and zone areas
dist_mtx = zeros(num_z);
dist_tot = zeros(num_h,1);
dist_avg = zeros(num_h,1);
Area_D = zeros(num_z,1);

% Demand unbalance
ret = zeros(num_h,num_z);
req = zeros(num_h,num_z);
fi = zeros(num_h,num_z);
unb_tot = zeros(num_h,1);


%% DISTANCE AND AREAS
%%% Calculates distance matrix (centroid to centroid), and an array of zone
%   areas.
for i = 1:num_z
    % Array of zone areas
    Area_D(i) = vZones{i}.zoneArea/10^6;
    
    for j = 1:num_z
        %
        X_i = vZones{i}.X;
        Y_i = vZones{i}.Y;
        X_j = vZones{j}.X;
        Y_j = vZones{j}.Y;
        % Distance matrix
        dist_mtx(i,j) = sim_dist(X_i, Y_i, X_j, Y_j);
    end
end
% Total area
R = sum(Area_D);


%% TIME-DEPENDING ATTRIBUTES
%%% Calculates the total demand (requests and returns), demand density,
%   imbalance fraction, and imbalanced areas for each demand update step
%   (duration of each demand matrix).

for h = 1:num_h    
    % Read matrix
    dmd_mtx = matOD(h).Matrix;
    dmd_mtx_24h(:,:,h) = dmd_mtx;
    
    % Total trips and demand density per time step
    dmd_tot(h) = sum(dmd_mtx(:));
    dmd_den(h) = dmd_tot(h)/(R*time_h);
    
    % Calculates total and average trip distance (In meters)
    dist_tot(h) = sum(sum(dist_mtx.*dmd_mtx));
    dist_avg(h) = dist_tot(h)/dmd_tot(h);
    
    % Sums all trips beginning in each zone
    req(h,:) = sum(dmd_mtx,2);
    % Sums all trips ending in each zone
    ret(h,:) = sum(dmd_mtx,1);
        
    % Calculates fi
    fi(h,:) = (ret(h,:)-req(h,:))./(dmd_den(h)*Area_D*time_h)';
    % Calculates gross unbalance
    unb_tot(h) = sum(abs(ret(h,:)-req(h,:)));
        
end


% Select which zones have positive and negative unbalance
neg_unb = fi<0;
pos_unb = fi>0;

% Calculate subregions R_q and R_t
R_q = neg_unb*Area_D;
R_t = pos_unb*Area_D;

% Calculate fraction of unbalanced trips
Fi_q = ((neg_unb.*fi)*Area_D)./R_q;
Fi_t = ((pos_unb.*fi)*Area_D)./R_t;
Fi_tot = ((Fi_t.*R_t)-(Fi_q.*R_q))/R;

% Spatial deviation
spat_coef_dev = std(fi,0,2);


%% DAILY AVERAGE ATTRIBUTES (considers the period t_0 t_end)
% Average demand density
avg_dmd_dens = sum(dmd_den(fst:lst))/period;
% Average trip distance
dist_avg_tot = sum(dist_tot)/sum(dmd_tot);
% Standard temporal deviation
temp_dev = std(dmd_den(fst:lst));
% Average subregion size
avg_Fi_q = sum(Fi_q(fst:lst).*dmd_den(fst:lst).*R_q(fst:lst))...
    /sum(dmd_den(fst:lst).*R_q(fst:lst));
avg_Fi_t = sum(Fi_t(fst:lst).*dmd_den(fst:lst).*R_t(fst:lst))...
    /sum(dmd_den(fst:lst).*R_t(fst:lst));
% Average fraction of unbalanced trips
avg_R_q = sum(R_q(fst:lst).*dmd_den(fst:lst))...
    /(sum(dmd_den(fst:lst)) * R);
avg_R_t = sum(R_t(fst:lst).*dmd_den(fst:lst))...
    /(sum(dmd_den(fst:lst)) * R);
% (Both calculations must result in an equal value. Otherwise, check.)
avg_Fi_tot = (avg_Fi_t * avg_R_t - avg_Fi_q * avg_R_q);
avg_Fi_tot_2 = sum(unb_tot(fst:lst)/(sum(dmd_den(fst:lst))*R));

% Average spatial deviation
avg_spat_dev = sum(spat_coef_dev(fst:lst).*dmd_den(fst:lst))...
    /sum(dmd_den(fst:lst))*avg_dmd_dens;
% Alternative method (not necessarily the same value)
alt_spat_dev = std(reshape(fi(:,fst:lst),[],1))*avg_dmd_dens;


%% CENTROIDS AND DISTANCES BETWEEN R_t AND R_q
%%% Add-on to calculate average daily centroids of R_t and R_q subregion,
%   and the average distance between them. This distance will be used to
%   approximate the line haul distance of repositioning tasks.
%   NOTE: This approximation is only valid on some imbalance patterns but
%   not for all of them (i.e. in radial patterns both centroids will be on
%   the same point).
%
%%% Approximation #1 - Centroid coordinates and calculate distance
% Initialize subregion centroid coordinates (X, Y), and weights
cent_q = zeros(num_h,2);
cent_t = zeros(num_h,2);
weig_q = zeros(num_h,1);
weig_t = zeros(num_h,1);

sum_dist_cent_2 = 0;
sum_dist_cent_2_alt = 0;

% For each zone and hour, add its coordinates if the zone belongs to one or
% another subregion.
for i = 1:num_z 
    % Zone centroid coordinates
    X_i = vZones{i}.X;
    Y_i = vZones{i}.Y;

    for h=1:num_h
        if fi(h,i)<0
            cent_q(h,1) = cent_q(h,1) + X_i;
            cent_q(h,2) = cent_q(h,2) + Y_i;
            weig_q(h) = weig_q(h) + (req(h,i) - ret(h,i));

            sum_dist_cent_2 = sum_dist_cent_2 + sum(dist_mtx(i,:).*neg_unb(h,:))*(req(h,i) - ret(h,i));

        elseif fi(h,i)>0
            cent_t(h,1) = cent_t(h,1) + X_i;
            cent_t(h,2) = cent_t(h,2) + Y_i;
            weig_t(h) = weig_t(h) + (ret(h,i) - req(h,i));

            sum_dist_cent_2_alt = sum_dist_cent_2_alt + sum(dist_mtx(i,:).*pos_unb(h,:))*(ret(h,i) - req(h,i));

        end     
    end
end

% Weighted average by the total number of trips.
cent_q = cent_q.*weig_q./(sum(weig_q)*sum(neg_unb,2));
cent_t = cent_t.*weig_t./(sum(weig_t)*sum(pos_unb,2));

cent_q_tot = sum(cent_q)/numel(cent_q);
cent_t_tot = sum(cent_t)/numel(cent_t);
dist_cent = sqrt((cent_q_tot(1)-cent_t_tot(1))^2+(cent_q_tot(2)-cent_t_tot(2))^2);

dist_cent_2 = sum_dist_cent_2/(sum(weig_q)*sum(sum(neg_unb)));
dist_cent_2_alt = sum_dist_cent_2_alt/(sum(weig_t)*sum(sum(pos_unb)));

%%% Approximation #2 - Average distance between O/D pairs
sum_dist_cent_2 = zeros(num_h,1);
sum_dist_cent_2_alt = zeros(num_h,1);

for h=1:num_h
    %
    imb_mtx = neg_unb(h,:).*(req(h,:) - ret(h,:)) +...
        pos_unb(h,:).*(ret(h,:) - req(h,:));
    %
    for i = 1:num_z 
        if fi(h,i)<0
            sum_dist_cent_2(h) = sum_dist_cent_2(h) + ...
                sum(dist_mtx(:,i)'.*neg_unb(h,:).*imb_mtx)/sum(neg_unb(h,:).*imb_mtx);
        elseif fi(h,i)>0

            sum_dist_cent_2_alt(h) = sum_dist_cent_2_alt(h) + ...
                sum(dist_mtx(:,i)'.*pos_unb(h,:).*imb_mtx)/sum(pos_unb(h,:).*imb_mtx);
        end     
    end
end

dist_cent_2 = sum(sum_dist_cent_2.*weig_q)/(sum(weig_q)*sum(sum(neg_unb)));
dist_cent_2_alt = sum(sum_dist_cent_2_alt.*weig_t)/(sum(weig_t)*sum(sum(pos_unb)));

%% PLOTS AND OUTPUT FILES
%%% Aggregated demand values (.TXT)
%
% Selection of values to export.
varname = {'Total trips = ', 'Avg. demand density = ', 'Avg imbalance = ',...
    'Service area = ', 'R_t area fraction = ', 'R_q area fraction = ',...
    'Avg. trip distance = ',...
    'CV (temporal) = ', 'CV (spatial) = '};
units = {' trips', ' trips/h·km^2', '[fraction of trips]',...
    ' km^2', '[fraction of area]', '[fraction of area]',...
    ' meters',...
    '[fraction of demand density]', '[fraction of demand density]'};
values = {sum(dmd_tot), avg_dmd_dens, avg_Fi_tot,...
    R, avg_R_t, avg_R_q,...
    dist_avg_tot,...
    temp_dev/avg_dmd_dens, avg_spat_dev/avg_dmd_dens};
%
% Write fields to text file
fid = fopen([fldrname t '_aggDemandParameters.txt'],'w');
for i=1:numel(varname)
    str = [varname{i} num2str(values{i}) units{i} '\n'];
    fprintf(fid, str);
end
fclose(fid);

%% Demand histogram figure (.JPG)
%
% Generate figure
figure('Visible','off');
bar(dmd_tot);
% Title and axis
title('Total Demand Histogram', 'Interpreter','none');
xlabel('Hour')
ylabel('Number of trips')
% Print figure to jpg file
filename = [fldrname 'DemandHistogram.jpg'];
saveas(gcf,filename);
close(gcf);

%% Zonification with demand imbalance values (.JPG)
%
% Get values to represent
aux = 2*(sum(ret,1)-sum(req,1))./(sum(ret,1)+sum(req,1));
% Generate colormap
cmap = jet;
cmin = min(aux);
cmax = max(aux);
m = length(cmap);
%
% Generate figure
figure('Visible','off');
for j=1:numel(vZones)
    index = fix((aux(j)-cmin)/(cmax-cmin)*m)+1;
    RGB = cmap(min(index,m),:);
    %
    mapshow(SArea(j), 'FaceColor', RGB);
    hold on;
end
% Set colormap
colormap jet
h = colorbar('Ticks',[0, 0.5 ,1], 'TickLabels', {num2str(cmin,'%.2f'), ...
    num2str((cmax+cmin)/2,'%.2f'), num2str(cmax,'%.2f')});
ylabel(h, '(Demand generated - Demand attracted)/Demand level [-]')
% Title and axis
% title('Demand Imbalance', 'Interpreter','none');
title('Potential demand imbalance per zone', 'Interpreter','none');
xlabel('X UTM Coordinate [m]')
ylabel('Y UTM Coordinate [m]')
% Print figure to jpg file
filename = [fldrname 'DemandImbalance.jpg'];
saveas(gcf,filename);
close(gcf);

%% Zonification with demand REQUESTS LEVEL (.JPG)
%
% Get values to represent
aux = sum(req,1);
% Generate colormap
cmap = jet;
cmin = min(aux);
cmax = max(aux);
m = length(cmap);
%
% Generate figure
figure('Visible','off');
for j=1:numel(vZones)
    index = fix((aux(j)-cmin)/(cmax-cmin)*m)+1;
    RGB = cmap(min(index,m),:);
    %
    mapshow(SArea(j), 'FaceColor', RGB);
    hold on;
end
% Set colormap
colormap jet
h = colorbar('Ticks',[0, 0.5 ,1], 'TickLabels', {num2str(cmin,'%.2f'), ...
    num2str((cmax+cmin)/2,'%.2f'), num2str(cmax,'%.2f')});
ylabel(h, 'Demand generated [trips]')
% Title and axis
% title('Demand Requests Level', 'Interpreter','none');
title('Potential demand generated per zone', 'Interpreter','none');
xlabel('X UTM Coordinate [m]')
ylabel('Y UTM Coordinate [m]')
% Print figure to jpg file
filename = [fldrname 'DemandRequests.jpg'];
saveas(gcf,filename);
close(gcf);

%% Zonification with demand RETURNS LEVEL (.JPG)
%
% Get values to represent
aux = sum(ret,1);
% Generate colormap
cmap = jet;
cmin = min(aux);
cmax = max(aux);
m = length(cmap);
%
% Generate figure
figure('Visible','off');
for j=1:numel(vZones)
    index = fix((aux(j)-cmin)/(cmax-cmin)*m)+1;
    RGB = cmap(min(index,m),:);
    %
    mapshow(SArea(j), 'FaceColor', RGB);
    hold on;
end
% Set colormap
colormap jet
h = colorbar('Ticks',[0, 0.5 ,1], 'TickLabels', {num2str(cmin,'%.2f'), ...
    num2str((cmax+cmin)/2,'%.2f'), num2str(cmax,'%.2f')});
ylabel(h, 'Demand attracted [trips]')
% Title and axis
% title('Demand Returns Level', 'Interpreter','none');
title('Potential demand attracted per zone', 'Interpreter','none');
xlabel('X UTM Coordinate [m]')
ylabel('Y UTM Coordinate [m]')
% Print figure to jpg file
filename = [fldrname 'DemandReturns.jpg'];
saveas(gcf,filename);
close(gcf);


%% OUTPUT STRUCT
% (Only for auxilary purposes.)
outDmdParam = struct(...
    'dmd_mtx_24h',dmd_mtx_24h,...
    'dmd_tot',dmd_tot,...
    'dmd_den',dmd_den,...
    'dist_tot',dist_tot,...
    'dist_avg',dist_avg,...
    'req',req,...
    'ret',ret,...
    'fi',fi,...
    'unb_tot',unb_tot,...
    'neg_unb',neg_unb,...
    'pos_unb',pos_unb,...
    'area_total',R,...
    'R_q',R_q,...
    'R_t',R_t,...
    'Fi_q',Fi_q,...
    'Fi_t',Fi_t,...
    'Fi_tot',Fi_tot,...
    'spat_dev',spat_coef_dev,...
    'avg_dmd_dens',avg_dmd_dens,...
    'temp_dev',temp_dev,...
    'avg_Fi_q',avg_Fi_q,...
    'avg_Fi_t',avg_Fi_t,...
    'avg_R_q',avg_R_q,...
    'avg_R_t',avg_R_t,...
    'avg_Fi_tot',avg_Fi_tot,...
    'avg_Fi_tot_2',avg_Fi_tot_2,...
    'avg_spat_dev',avg_spat_dev,...
    'alt_spat_dev',alt_spat_dev);

end

