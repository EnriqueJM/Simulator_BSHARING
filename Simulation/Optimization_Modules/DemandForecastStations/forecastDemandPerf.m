function [vStationsOut, vZonesOut] = forecastDemandPerf(vStations, vZones,...
                                            vCars, vUsersGen, param, usr_timer)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

TotalTime = param.TotalTime;

%%% Calculation of expected demand and parking fraction on street/station.

%% CREATE REQUESTS-RETURNS ARRAYS
    for t=1:TotalTime
        usrs_idx = vUsersGen(:,1)==(t+usr_timer-1);
        usrs_in_t = vUsersGen(usrs_idx,:);
        
        rnd = random('unif',-1,2,[numel(vStations),1]);     % RANDOM ERROR

        if size(usrs_in_t,1)>0
            for i=1:size(usrs_in_t,1)
                % Copy origin and destination points.
                zoneO = usrs_in_t(i,2);
                XO = usrs_in_t(i,3);
                YO = usrs_in_t(i,4);
                zoneD = usrs_in_t(i,5);
                XD = usrs_in_t(i,6);
                YD = usrs_in_t(i,7);

                % Check availability and reserve vehicle
                [SB, SBpark] = closestStat(param, t,...
                    vStations, vZones, vCars,...
                    zoneO, XO, YO, zoneD, XD, YD);
                
                if SB~=0 && SBpark~=0
                    vStations{SB}.accRequests(t+1:end) = vStations{SB}.accRequests(t+1:end) + 1 *(1+rnd(SB));
                    vStations{SBpark}.accReturns(t+1:end) = vStations{SBpark}.accReturns(t+1:end) + 1 *(1+rnd(SBpark));
                end
            end
        end        
    end

vZonesOut = vZones;
vStationsOut = vStations;


save ('vStations_DMDPerf_Err2_2.mat', 'vStationsOut');

end

function [SB, SBpark] = closestStat(param, t, vStations, vZones, vCars,...
                            zoneO, XO, YO, zoneD, XD, YD)

    % STEP 1: FIND CLOSEST STATION AT DESTINATION
    % Look for closest station in the same zone &
    % neighbor zones
    dmin_SBpark = 1e6;
    SBpark = 0;
    % Stations in same & neighbor zones than Destination
    % zone
    list_SB = [vZones{zoneD}.listStations, vZones{zoneD}.listStations_neig];
    %
    for k=1:size(list_SB,2)
        XB = vStations{list_SB(k)}.X;
        YB = vStations{list_SB(k)}.Y;
        %
        d = sim_dist(XD, YD, XB, YB);
        if (d < param.Wmax) && (d < dmin_SBpark)           % Check maximum walking distance at destination
            dmin_SBpark = d;
            SBpark = list_SB(k);
        end
    end

    % STEP 2: FIND CLOSEST STATION AT ORIGIN
    % First, look for closest station in the same zone &
    % neighbor zones
    if param.Trips_SB2FF == 0 && SBpark == 0
        % If there's no station at destination and SB->FF
        % trips are forbidden, no station is considered at
        % origin.
        dmin_SB = 1e6;
        SB = 0;
    else
        % In any other case, find the closest station with
        % available cars.
        dmin_SB = 1e6;
        SB = 0;
        list_SB = [vZones{zoneO}.listStations,...
            vZones{zoneO}.listStations_neig]; % Stations in same & neighbor zones than user
        %
        for k=1:size(list_SB,2)
            XB = vStations{list_SB(k)}.X;
            YB = vStations{list_SB(k)}.Y;
            %
            d = sim_dist(XO, YO, XB, YB);
            if (d < param.Wmax) && (d < dmin_SB)       % Check also that d is lower than maximum walking distance
                dmin_SB = d;
                SB = list_SB(k);
            end
        end
    end
    % Flter. If the origin station is the same as the
    % destinaton station, no station at origin is
    % considered.
    if SB == SBpark
        SB = 0;
        dmin_SB = 1e6;
    end
end

%             % Check if there are available cars in station
%             availCar = 0;
%             list_cars = vStations{list_SB(k)}.listCars;
%             for l=1:size(list_cars,2)
%                 if vCars{list_cars(l)}.status(t) == 0  % Check that there are cars available
%                     availCar = 1;
%                     break;
%                 end
%             end
%             %
%             if availCar > 0
%                 XB = vStations{list_SB(k)}.X;
%                 YB = vStations{list_SB(k)}.Y;
%                 %
%                 d = sim_dist(XO, YO, XB, YB);
%                 if (d < param.Wmax) && (d < dmin_SB)       % Check also that d is lower than maximum walking distance
%                     dmin_SB = d;
%                     SB = list_SB(k);
%                 end
%             end

