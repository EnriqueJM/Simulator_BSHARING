function outputCosts(param, obj)
    % Function to generate summary of costs

    if param.verbose
        disp('');
        disp('CREATING COSTS SUMMARY');
    end
    %
    TotalTime = size(obj.MyCity.vCars{1}.status,2)/60; % Total simulation time in hours
    
    %
    % INFRASTRUCTURE COSTS
    %
    obj.Summary = [obj.Summary; {'' '' ''}];
    obj.Summary = [obj.Summary; {'INFRASTRUCTURE COSTS' '' ''}];

    %%% Fleet cost
    % Count the number of electric and ICE cars.
    m_elec = 0;
    m_fuel = 0;
    for icar=1:obj.MyCity.numCars
        if obj.MyCity.vCars{icar}.isElectric
            m_elec = m_elec + 1;
        else
            m_fuel = m_fuel + 1;     
        end
    end
    
    % Cost of electric cars
    cost_cars_e = m_elec * param.costCarElectric;
    obj.Summary = [obj.Summary; {'Cost eCars' '€/h' num2str(cost_cars_e,'%8.2f')}];

    % Cost of ICE cars
    cost_cars_f = m_fuel * param.costCarICE;
    obj.Summary = [obj.Summary; {'Cost iceCars' '€/h' num2str(cost_cars_f,'%8.2f')}];
    
    % TOTAL FLEET COST
    cost_fleet_tot = cost_cars_e + cost_cars_f;
    obj.Summary = [obj.Summary; {'Cost Fleet' '€/h' num2str(cost_fleet_tot,'%8.2f')}];
    

    %%% Station cost
    % Count the total number of parking slots and chargers in use.
    m_park_SB = 0;
    m_char = 0;
    t_use_SB = 0;
    t_use_char = 0;
    for istat=1:obj.MyCity.numStations
        m_park_SB = m_park_SB + obj.MyCity.vStations{istat}.capacity;
        m_char = m_char + obj.MyCity.vStations{istat}.numChargers;
        t_use_SB = t_use_SB + ...
            sum(cellfun(@(t) numel(t),obj.MyCity.vStations{istat}.vlistCars))/60;
        t_use_char = t_use_char + ...
            sum(cellfun(@(t) numel(t),obj.MyCity.vStations{istat}.vlistCharging))/60;
    end
%     char_ratio = m_char/m_park_SB;
    
    % Cost of stations
    cost_stat = obj.MyCity.numStations * param.costStat;
    obj.Summary = [obj.Summary; {'Cost Stations' '€/h' num2str(cost_stat,'%8.2f')}];    
    
    % Cost of parkings
    cost_slot = t_use_SB * param.costParkingSB;
    obj.Summary = [obj.Summary; {'Cost SB parking' '€/h' num2str(cost_slot,'%8.2f')}];
    
    % Cost of chargers
    cost_char = t_use_char * param.costCharger;
    obj.Summary = [obj.Summary; {'Cost Chargers' '€/h' num2str(cost_char,'%8.2f')}];
    
    % TOTAL PARKING COST (ON STATIONS)
    cost_stat_tot = cost_stat + cost_slot + cost_char;
    obj.Summary = [obj.Summary; {'Total Parking Cost SB' '€/h' num2str(cost_stat_tot,'%8.2f')}];

    % On-street parking cost
    % Calculate the usage of on-street parking.
    t_use_FF = 0;
    for izone=obj.MyCity.numFreeFloatZones    
        t_use_FF = t_use_FF + sum(cellfun(@(t) numel(t),obj.MyCity.vFreeFloatZones{izone}.vlistCars));
    end

    % TOTAL PARKING COST (ON STREET)
    cost_slot_FF = t_use_FF * param.costParkingFF;
    obj.Summary = [obj.Summary; {'Total Parking Cost FF' '€/h' num2str(cost_slot_FF,'%8.2f')}];

    %
    % OPERATIVE COST
    %
    obj.Summary = [obj.Summary; {'' '' ''}];
    obj.Summary = [obj.Summary; {'OPERATION COSTS' '' ''}];

    % Count access time and IVTT (in hours)
    time_accs_tot = 0;
    time_trip_tot_ele = 0;
    time_trip_tot_ICE = 0;
    for iuser=1:obj.MyCity.numFinishedUsers
        % Access time
        time_accs_tot = time_accs_tot + (obj.MyCity.vFinishedUsers{iuser}.tO2Car - ...
            obj.MyCity.vFinishedUsers{iuser}.tCreation)/60;
        
        % IVTT splitting electric and ICE cars
        carID = obj.MyCity.vFinishedUsers{iuser}.CarID;
        trip = (obj.MyCity.vFinishedUsers{iuser}.tTrip - obj.MyCity.vFinishedUsers{iuser}.tO2Car)/60;
        %
        if obj.MyCity.vCars{carID}.isElectric
            time_trip_tot_ele = time_trip_tot_ele + trip;
        else
            time_trip_tot_ICE = time_trip_tot_ICE + trip;
        end
    end

    %%% Operative cost (w/o repositioning)
    % Administrative and general.
    cost_oper_gen =  (m_elec + m_fuel) * param.costOperative;
    obj.Summary = [obj.Summary; {'Cost Admin and General' '€/h' num2str(cost_oper_gen,'%8.2f')}];
    
    % Maintenance and refueling ELECTRIC
    cost_fuel_ele = time_trip_tot_ele * param.CarSpeed * ...
        (param.costMaintCar + param.costFuelElectric) / (100*TotalTime);   % Cost per 100km in outputs.xlsx
    obj.Summary = [obj.Summary; {'Cost Maint and Fuel eCars' '€/h' num2str(cost_fuel_ele,'%8.2f')}];
    
    % Maintenance and refueling ICE
    cost_fuel_ICE = time_trip_tot_ICE * param.CarSpeed * ...               % Cost per 100km in outputs.xlsx
        (param.costMaintCar + param.costFuelICE) / (100*TotalTime);
    obj.Summary = [obj.Summary; {'Cost Maint and Fuel iceCars' '€/h' num2str(cost_fuel_ICE,'%8.2f')}];
    %
    % TOTAL OPERATIVE COST (w/o REPOSITIONING)
    cost_oper_tot = cost_oper_gen + cost_fuel_ele + cost_fuel_ICE;
    obj.Summary = [obj.Summary; {'Cost Operation Total (w/o repo)' '€/h' num2str(cost_oper_tot,'%8.2f')}];

    %%% Repositioning cost
    % TOTAL REPOSITIONING COST
    cost_repo_tot = obj.MyCity.numRepoTeams * param.costRepo;
    obj.Summary = [obj.Summary; {'Cost Repositioning Total' '€/h' num2str(cost_repo_tot,'%8.2f')}];

    %
    % USER COSTS
    %
    obj.Summary = [obj.Summary; {'' '' ''}];
    obj.Summary = [obj.Summary; {'USER COSTS' '' ''}];

    % TOTAL USER ACCESS COST
    cost_accs_tot = time_accs_tot * param.costTimeUser / TotalTime;
    obj.Summary = [obj.Summary; {'Cost User Access' '€/h' num2str(cost_accs_tot,'%8.2f')}];

    %%% User no-service penalties
    % Count which dead users had a station nearby.
    dead_SB = 0;
    for idead = 1:size(obj.MyCity.notServicedUsers,1)
        % Check origin zone. If there are stations in the zone or neighbours,
        % it is a not-served SB penalty.
        % (This is an overestimation, since not all of them will be inside the
        % Wmax distance and shouldn't count. But it is the only way that
        % doesn't require further changes in the simulation code.)
        zoneO = obj.MyCity.notServicedUsers(idead,1);
        num_stat = obj.MyCity.vFreeFloatZones{zoneO}.numStations + ...
            obj.MyCity.vFreeFloatZones{zoneO}.numStations_neig;
        if num_stat > 0
            dead_SB = dead_SB + 1;
        end
    end
    
    % NO SERVICE PENALTIES SB
    cost_dead_SB = (dead_SB * param.costLostSB)/TotalTime;
    obj.Summary = [obj.Summary; {'Cost No Service Penalties SB' '€/h' num2str(cost_dead_SB,'%8.2f')}];
    
    % NO SERVICE PENALTIES FF (also called "demand lost")
    cost_dead_FF = ((size(obj.MyCity.notServicedUsers,1) - dead_SB) * param.costLostFF)/TotalTime;
    obj.Summary = [obj.Summary; {'Cost No Service Penalties FF' '€/h' num2str(cost_dead_FF,'%8.2f')}];
    
    %
    % REVENUE
    %
    obj.Summary = [obj.Summary; {'' '' ''}];
    obj.Summary = [obj.Summary; {'REVENUE' '' ''}];
    
    % REVENUE IN SB
    rev_SB = tableFareTripsInStationSumm(param, obj);
    obj.Summary = [obj.Summary; {'Revenue on stations' '€/h' num2str(rev_SB,'%8.2f')}];
        
    % REVEUE IN FF
    rev_FF = tableFareTripsInZoneSumm(param, obj);
    obj.Summary = [obj.Summary; {'Revenue on street' '€/h' num2str(rev_FF,'%8.2f')}];

    %
    % SUMMARY
    %
    obj.Summary = [obj.Summary; {'' '' ''}];
    obj.Summary = [obj.Summary; {'SUMMARY COSTS' '' ''}];
    
    % TOTAL AGENCY COST
    cost_agen_tot = cost_fleet_tot + cost_stat_tot + cost_slot_FF + cost_oper_tot + cost_repo_tot;
    obj.Summary = [obj.Summary; {'Total Agency Cost' '€/h' num2str(cost_agen_tot,'%8.2f')}];

    % TOTAL USER COST
    cost_user_tot =  cost_accs_tot + cost_dead_SB + cost_dead_FF;
    obj.Summary = [obj.Summary; {'Total User Cost' '€/h' num2str(cost_user_tot,'%8.2f')}];

    % TOTAL GENERALIZED COST
    cost_total = cost_agen_tot + cost_user_tot;
    obj.Summary = [obj.Summary; {'Total Generalized Cost' '€/h' num2str(cost_total,'%8.2f')}];
    
    % TOTAL REVENUE
    rev_tot = rev_SB + rev_FF;
    obj.Summary = [obj.Summary; {'Total system revenue' '€/h' num2str(rev_tot,'%8.2f')}];

    % GENERALIZED COST PER TRIP
    cost_trip = cost_total*TotalTime / obj.MyCity.numFinishedUsers;
    obj.Summary = [obj.Summary; {'Generalized Cost per Trip' '€/trip' num2str(cost_trip,'%8.2f')}];

    % REVENUE-NEUTRAL FARE
    fare_rev_neu = cost_agen_tot*TotalTime / obj.MyCity.numFinishedUsers;
    obj.Summary = [obj.Summary; {'Revenue-Neutral Fare' '€/trip' num2str(fare_rev_neu,'%8.2f')}];

    % FARE PER TRIP
%     revenue_tot = (time_accs_tot + time_trip_tot_ele + time_trip_tot_ICE) * ...
%         param.avgFare * 60; %%% (This option only if pays for reserve)
    fare_trip = rev_tot*TotalTime / obj.MyCity.numFinishedUsers;
    obj.Summary = [obj.Summary; {'Avg. Fare' '€/trip' num2str(fare_trip,'%8.2f')}];

    % PROFIT PER TRIP
    profit_trip = fare_trip - fare_rev_neu;
    obj.Summary = [obj.Summary; {'Profit per trip' '€/trip' num2str(profit_trip,'%8.2f')}];

    % PROFIT PER HOUR
    profit_hour = profit_trip * obj.MyCity.numFinishedUsers / TotalTime;
    obj.Summary = [obj.Summary; {'Profit per hour' '€/h' num2str(profit_hour,'%8.2f')}];
    
end


%% REVENUE FUNCTIONS
% tableFareTripsInStationSumm
function [aux] = tableFareTripsInStationSumm(param, obj)
    % Function to create table with average access time
    % in every zone from stations aggregated by region and time (sum)

    % Generate avg access time
    aux = 0;
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
            %
            % Trip time = Time when user arrives at parking - Time of taking car
            trip = tTrip - tO2Car;
            %
            aux = aux + trip*param.avgFare;
        end
    end
    % Total simulation time in hours
    TotalTime = size(obj.MyCity.vCars{1}.status,2)/60;
    % In [€/h]
    aux = aux/TotalTime;
end

% tableFareTripsInZoneSumm
function [aux] = tableFareTripsInZoneSumm(param, obj)
    % Function to create table with average access time
    % in every zone from zones aggregated by region and time (sum)

    % Generate avg access time
    aux = 0;
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO == 0          % Origin at station StatO
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
            %
            % Trip time = Time when user arrives at parking - Time of taking car
            trip = tTrip - tO2Car;
            %
            aux = aux + trip*param.avgFare;
        end
    end
    % Total simulation time in hours
    TotalTime = size(obj.MyCity.vCars{1}.status,2)/60;
    % In [€/h]
    aux = aux/TotalTime;
end

% tableFareTripsInTotalSumm
function [aux] = tableFareTripsInTotalSumm(param, obj)
    % Function to create table with average access time
    % in every zone from stations+zones aggregated by region and time (sum)

    % Generate avg access time
    aux = 0;
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
        tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
        %
        % Trip time = Time when user arrives at parking - Time of taking car
        trip = tTrip - tO2Car;
        %
        aux = aux + trip*param.avgFare;
    end
    % Total simulation time in hours
    TotalTime = size(obj.MyCity.vCars{1}.status,2)/60;
    % In [€/h]
    aux = aux/TotalTime;
end



