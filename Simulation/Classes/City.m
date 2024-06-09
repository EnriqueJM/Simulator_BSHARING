% CITY class BIEKSHARING ver 2022.08.20

classdef City<handle
    
    properties
        servArea                  % service area (zonification)
        zoneNum                   % array to store the zonification numbering from shp file
        OD                        % hourly OD matrices
        output                    % postprocess object to generate plots
        
        numStations               % number of Stations
        vStations                 % array to store Stations
        
        numFreeFloatZones         % number of Free Float Zones
        vFreeFloatZones           % array to store Free Float Zones
        
        numCars                   % number of Cars
        vCars                     % array to store Cars
        minBatteryLevel           % minimum battery level for longest trip in City (set eCar to unavailable)
        
        numRepoTeams              % number of Repositioning Teams
        vRepoTeams                % array to store Repositioning Teams
        
        numUsers                  % number of active Users
        vUsers                    % array to store active Users
        numFinishedUsers          % number of finished Users
        vFinishedUsers            % array to store finished Users
        notServicedUsers          % array of not serviced (dead) users
        
        vUsersGen                 % array of generated users (all)
        usr_timer                 % timer of user generation
                
    end
    
    methods
 %% CONSTRUCTOR
 
        function obj = City()     % constructor
            obj.servArea = {};
            obj.zoneNum = [];
            obj.OD = {};
            obj.output = PostProcess();
            
            obj.numStations = 0;
            obj.vStations = {};
            
            obj.numFreeFloatZones = 0;
            obj.vFreeFloatZones = {};
            
            obj.numCars = 0;
            obj.vCars = {};
            obj.minBatteryLevel = 0;
            
            obj.numRepoTeams = 0;
            obj.vRepoTeams = {};
            
            obj.numUsers = 0;
            obj.vUsers = {};
            obj.numFinishedUsers = 0;
            obj.vFinishedUsers = {};
            obj.notServicedUsers = [];
            
            obj.vUsersGen = [];
            obj.usr_timer = 1;
            
        end


 %% INITIALIZATION FUNCTIONS
 
        % initializeCity
        function initializeCity(param, obj)
            % Function to initialize the City
            
            disp('Creating Service Area');                                 % Create/Load service area
            createGeometry(param, obj);                                    
            
            disp('Creating Free Float Zones');                             % Create free float zones (needed before creating stations!!!)
            setFreeFloatZones(param, obj);
            
            disp('Creating O/D demand matrices');                          % Create O/D matrices
            setDemandMatrices(param, obj);                
            
            if param.UsersKnown == 1                                       % Read user array
                disp('Reading known demand array');
                usr_array = load(param.UsersFile).users;
                obj.vUsersGen = usr_array;
            end
            
            disp('Creating Stations');                                     % Create stations. Find nearest charging point for all stations/zones.
            setStations(param, obj);
            findNearestCharger(obj);                                       

            disp('Creating Cars');                                         % Create cars (SB & FF)
            setCars(param, obj);         
            
            disp('Creating Repositioning Teams');                          % Create repositioning teams
            setRepo(param, obj);
        end

        % timeSimulation
        function timeSimulation(param, obj)
            %%% Simulates ONE DEMAND CYCLE (i.e. DAY)
            %
            % Forecast expected returns and requests on stations and zones
            % for repositioning management purposes.
            if param.verbose
                disp('Forecasting demand on stations and zones for next cycle.');
            end
            
            if param.forecast_method == 'average'
            % Average demand forecast
                [obj.vStations, obj.vFreeFloatZones] = ...
                    forecastDemandAvg(obj.vStations, obj.vFreeFloatZones,...
                        obj.servArea, obj.vRepoTeams, obj.OD, param);
            elseif param.forecast_method == 'perfect'
              % "Perfect" demand forecast.  
                [obj.vStations, obj.vFreeFloatZones] = ...
                    forecastDemandPerf(obj.vStations, obj.vFreeFloatZones,...
                        obj.vCars, obj.vUsersGen, param, obj.usr_timer);
            end
            %
            % Estimate expected task list (if necessary)
            if param.repoMethod == 2 || param.repoMethod == 3
                % Expected route calculation.
                % Update expected demand on stations/zones including routes
                if param.verbose
                    disp('Optimizing predefined repositioning route');     % Route estimation
                end
                %
                [obj.vRepoTeams, obj.vStations] = ...
                    optimRepoRouteDual_bikSB_Tmax(obj.vRepoTeams, obj.vStations,...
                    obj.vCars, param);
                
%                 [obj.vRepoTeams, obj.vStations] = ...
%                     optimRepoRouteDual_bikSB_Tfix(obj.vRepoTeams, obj.vStations,...
%                     obj.vCars, param);
            end
            %
            % Time Simulation
            for t=1:param.TotalTime
                disp(['Time [min]: ' num2str(t)]);
                
                if param.verbose
                    disp('Moving users');                                  % Move users
                end
                moveUsers(param, t, obj);
                
                if param.verbose
                    disp('Recharging electric cars');                      % Recharging electric cars
                end
                rechargeCars(param, t, obj);
                
                if param.verbose
                    disp('Repositioning tasks');                           % Repositioning tasks
                end
                moveRepoTeams(param, t, obj);
                
                if param.verbose
                    disp('Creating Users');                                % Create Users
                end
                setUsers(param, t, obj);
                
                % Store list of cars & chargers in SB & FF for output results
                for istat=1:obj.numStations
                    obj.vStations{istat}.vlistCars{t} = obj.vStations{istat}.listCars;
                    obj.vStations{istat}.vlistCharging{t} = obj.vStations{istat}.listCharging;
                end
                for izone=1:obj.numFreeFloatZones
                    obj.vFreeFloatZones{izone}.vlistCars{t} = obj.vFreeFloatZones{izone}.listCars;
                end
            end
        end

        % createGeometry
        function createGeometry(param, obj)
            % Function to create / load service area and hourly OD matrices
            % [0 = service area from perimeter Excel; 1 = service area with zonification from SHP file]
            if param.ServiceArea == 0

                % Read xlsx file
                try
                    Perim = xlsread(param.PerimeterFile);
                catch
                    error(['Error when reading file: ' param.PerimeterFile]);
                end
                Perim = Perim(:,2:4)';                                     % Keep X, Y, Z coordinates from excel
                Perim(:,end+1) = [Perim(1,1); Perim(2,1); Perim(3,1)];     % Add initial point to close the line

                % Generate quad mesh
                [obj.servArea] = generateZones(Perim, param);
                obj.servArea = obj.servArea';
                
                % Get array with zone numbering
                obj.zoneNum = zeros(size(obj.servArea,1),1);
                for i=1:size(obj.servArea,1)
                    obj.zoneNum(i) = obj.servArea(i).NO;
                end
                
            elseif param.ServiceArea == 1
                % Read SHP file
                try
                    obj.servArea = shaperead(param.ShapeFile);
                    
                    % Check if shape file contains percParking per zone
                    if isfield(obj.servArea,'SB_PRK') == 0
                        % If the field does not exist, create it with
                        % constant input parameter
                        for i=1:size(obj.servArea,1)
                            obj.servArea(i).SB_PRK = param.percParking;
                        end
                    end
                catch
                    error(['Error when reading file: ' param.ShapeFile]);
                end

                % Get array with zone numbering
                obj.zoneNum = zeros(size(obj.servArea,1),1);
                for i=1:size(obj.servArea,1)
                    obj.zoneNum(i) = obj.servArea(i).NO;
                end
            end
            
            %%% Generate list of neighbors for every region (to speed up
            %   search of cars by users)
            obj.servArea = listNeighbors(obj.servArea);  
        end

        % setFreeFloatZones
        function setFreeFloatZones(param, obj)
            % Function to generate free float zones from geometry (1 to 1)
            obj.numFreeFloatZones = max(size(obj.servArea,1), size(obj.servArea,2));

            % Create free float zones
            for i=1:obj.numFreeFloatZones
                aux = FreeFloatZone();
                %
                initializeFreeFloatZone(param, obj.servArea(i), aux);
                
                % Add FreeFloatZone to array
                obj.vFreeFloatZones{i} = aux;              
            end
            
            %%% Compute minimum battery level (percentage) before setting 
            %   electric cars to unavailable.
            if param.minBatteryPerc > 0
                % If a value is given, set that as the minimum.
                obj.minBatteryLevel = param.minBatteryPerc; 
            else
                % If no value was given, take the minimum battery to make
                % the longest possible trip in the city.
                R = 0;
                for izone=1:obj.numFreeFloatZones
                    R = R + obj.vFreeFloatZones{izone}.zoneArea;           % Area in m2
                end
                %
                obj.minBatteryLevel = 100 * 3.2 * (sqrt(R)/1000) / param.BatteryConsume; % Percentage from total
                if param.verbose
                    disp(['Minimum battery level for eCars to set as unavailable: ' num2str(obj.minBatteryLevel) '%']);
                end
            end
            param.minBatteryPerc = obj.minBatteryLevel; % For the txt input recap. 
        end
        
        %setDemandMatrices
        function setDemandMatrices(param, obj)
            % Function to create / load OD matrices
            
            if param.OdmatKnown == 1
                %%% OPTION 1 - Read O/D matrices from .csv files.
                % Check if the shapefile was introduced.
                if param.ServiceArea == 0
                    error('The OD matrices introduced have no associated shapefile.');
                end
                
                % Initialize OD
                obj.OD = struct();
                %
                for i=1:param.TotalTime/param.TimeReDemand   % 24 hours
                    filename = [param.Odmat_prefix '_' num2str(i-1) '.csv'];
                    %
                    try
                        A = csvread(filename,1,0);      % Avoid first row of text titles
                        A = spconvert(A);
                        obj.OD(i).Matrix = A(obj.zoneNum,obj.zoneNum);
                    catch
                        try
                            A = csvread(filename,0,0);  % Start from first row (no text)
                            A = spconvert(A);
                            obj.OD(i).Matrix = A(obj.zoneNum,obj.zoneNum);
                        catch
                            A = zeros(size(obj.servArea,1), size(obj.servArea,1));
                            obj.OD(i).Matrix = sparse(A);
                            %
                            disp(['O/D matrix file format not supported or does not exist: ' filename]);
                        end
                    end
                    clear A;
                end
  
                
            elseif param.OdmatKnown == 0
                %%% OPTION 2 - Create O/D matrices from zonification and
                %   aggregated demand values.
                %
                % Estimate matrices
                estimateODMatrices(param,obj);
                disp('Estimating OD matrices from aggregated demand inputs.');
            end               
        end

        % setStations
        function setStations(param, obj)
            % Function to create/load stations
            
            %%% Step 1: Read and filter the station candidate list from an
            %%% excel file.
            disp('Reading the Station list file.');
            try
                [data, text] = xlsread(param.InputStationFile);
                text(1,:) = [];                                            % Remove first row of titles
            catch
                error(['Error when reading file: ' param.InputStationFile]);
            end
            
            % Discard stations out of service area
            ind_list = [];                                                 % List of indices of stations out of service area

            %%% Create all non discarded stations in the list.
            for i=1:size(data,1)
                X = data(i,3);
                Y = data(i,4);
                count = 0;
                %
                for j=1:size(obj.servArea,1)
                    XX = obj.servArea(j).X;                                % List of boundary nodes of zone j
                    YY = obj.servArea(j).Y;
                    %
                    % Check if point (station) is inside of polygon (zone)
                    in = inpolygon(X,Y,XX,YY);
                    %
                    if in == 1                                             % Point i belongs to zone j
                        obj.vFreeFloatZones{j}.numStations = obj.vFreeFloatZones{j}.numStations + 1;
                        % Create station in the list
                        aux = Station();
                        %
                        initializeStation_excel(param, data(i,:), text(i,:), aux);
                        aux.zoneID = j;

                        % Add Station to array
                        obj.vStations{end+1} = aux;
                        break;
                    end
                    %
                    count = count+1;
                end
                %
                if count == size(obj.servArea,1)                           % The point is NOT inside any zone
                    disp(['Station ' num2str(i) ', ' text{i,2} ' is out of service area']);
                    ind_list(end+1) = i;
                end
            end
            
            % Remove ind_list from data, text
            data(ind_list,:) = [];
            text(ind_list,:) = [];
            
            %%% Step 2: Set the stations from the list or optimization.
            [obj.vStations, obj.vFreeFloatZones] = ...
                optimStations(param.TotalStat, obj.vStations,...
                    obj.vFreeFloatZones, obj.servArea, obj.OD, param);
            obj.numStations = size(obj.vStations,2);
            
            %%% Step 3: Forecast the accumulated request and returns.

            %%% NOTA: Esto debería considerarse módulo independiete. Ahora
            %%% mismo se realiza una única vez como setup, pero en el
            %%% futuro debería considerarse de la siguiente forma:
            %%% - Posibilidad de usar un método más complejo o con otros
            %%% inputs (p.ej. redes neuronales).
            %%% - Cambiar a módulo time-step. De forma que, o se predicen
            %%% todas las salidas y retornos para cada estación al
            %%% principio del día, o se van actualizando esas predicciones
            %%% cuando es relevante.
        end
        
        % findNearestCharger
        function findNearestCharger(obj)
            %%% NOTA: Considerar mover esto a una función auxiliar.
            
            % Find nearest charger of all stations.
            for i=1:obj.numStations
                % If the station has chargers, do not search.
                if obj.vStations{i}.numChargers > 0
                    obj.vStations{i}.nearestCharger = obj.vStations{i}.ID;

                else
                    min_dist = 9999;
                    min_idx = 0;
                    
                    XA = obj.vStations{i}.X;
                    YA = obj.vStations{i}.Y;
                    
                    for j=1:obj.numStations
                        XB = obj.vStations{j}.X;
                        YB = obj.vStations{j}.Y;
                        
                        d = sim_dist(XA, YA, XB, YB);
                        
                        if (d<min_dist) && (obj.vStations{j}.numChargers > 0)
                            min_dist = d;
                            min_idx = obj.vStations{j}.ID;
                        end
                    end
                    obj.vStations{i}.nearestCharger = min_idx;
                end
            end
            
            % Find nearest charger of all free floating zones.
            for i=1:obj.numFreeFloatZones
                
                min_dist = 9999;
                min_idx = 0;

                XA = obj.vFreeFloatZones{i}.X;
                YA = obj.vFreeFloatZones{i}.Y;

                for j=1:obj.numStations
                    XB = obj.vStations{j}.X;
                    YB = obj.vStations{j}.Y;

                    d = sim_dist(XA, YA, XB, YB);

                    if (d<min_dist) && (obj.vStations{j}.numChargers > 0)
                        min_dist = d;
                        min_idx = obj.vStations{j}.ID;
                    end
                end
                
                obj.vFreeFloatZones{i}.nearestCharger = min_idx;
            end
        end
        
        % createCars
        function setCars(param, obj)
            % Function to generate initial distribution of cars between
            % stations & free float zones
            %
            if param.IniDistributionKnown == 0
                %%% Unkown initial distribution
                %
                % Compute optimum car distribution in SB at t=0
                [obj.vStations] = optimDistribution(obj.vStations, param.TotalCarsSB, 1, param.costLostSB);
                % Compute optimum car distribution in FF at t=0
                [obj.vFreeFloatZones] = optimDistribution(obj.vFreeFloatZones, param.TotalCarsFF, 1, param.costLostFF);
                % Total number.
                obj.numCars = param.TotalCarsSB + param.TotalCarsFF;
            elseif param.IniDistributionKnown == 1
                % Read optimum vehicle distribution in SB at t=0
                [obj.vStations] = readDistribution(obj.vStations, param, 'SB');
                % Read optimum vehicle distribution in FF at t=0
                % [obj.vFreeFloatZones] = readDistribution(obj.vFreeFloatZones, param, 'FF');
                % Total number.
                obj.numCars = param.TotalCarsSB + param.TotalCarsFF;
            end
            % Number of electric
            numEcars = ceil(param.percEcars * obj.numCars);
            
            % Counter of vehicles
            count = 0;
            count_eCar = 0;
            if obj.numStations > 0
                % Create cars in Stations
                for i=1:obj.numStations
                    X = obj.vStations{i}.X;                                % Station position
                    Y = obj.vStations{i}.Y;
                    %
                    obj.vStations{i}.listCars = [];
                    %
                    for j=1:obj.vStations{i}.optCars
                        aux = Car();
                        %
                        count = count + 1;
                        initializeCar(param, count, X, Y, aux);
                        
                        % Electric or combustion car?
                        if j <= ceil(param.percEcars*obj.vStations{i}.optCars(1)) && count_eCar < numEcars
                            aux.isElectric = 1;
                            count_eCar = count_eCar + 1;
                        end

                        % Add car to array
                        obj.vCars{count} = aux;

                        % Add car to list of cars by station
                        obj.vStations{i}.listCars(end+1) =  aux.ID;
                    end
                end
            end
            
            
            % Create cars in Free Float Zones
            for i=1:obj.numFreeFloatZones
                XB = obj.servArea(i).X;                                    % List of nodes in zone boundary
                YB = obj.servArea(i).Y;
                %
                obj.vFreeFloatZones{i}.listCars = [];
                %
                for j=1:obj.vFreeFloatZones{i}.optCars
                    aux = Car();
                    %
                    % Generate random point inside the zone
                    [X, Y] = randPointInZone(XB, YB);
                    count = count + 1;
                    initializeCar(param, count, X, Y, aux);
                    
                    % Electric or combustion car?
                    if j <= ceil(param.percEcars*obj.vFreeFloatZones{i}.optCars(1)) && count_eCar < numEcars
                        aux.isElectric = 1;
                        count_eCar = count_eCar + 1;
                    end
                    
                    % Add car to array
                    obj.vCars{count} = aux;
                    
                    % Add car to list of cars by FFZone
                    obj.vFreeFloatZones{i}.listCars(end+1) = aux.ID;
                end
            end
            %
            if param.verbose
                disp(['Total number of cars generated: ' num2str(count)]);
            end
        end
        
        % setUsers
        function setUsers(param, t, obj)
            %%% GENERATED USERS RANDOMLY
            if param.UsersKnown == 0
                % Get the hourly index for OD matrix
                ind = ceil(t/60);

                % Get the nonzero values in OD matrix
                [zo, zd, dem] = find(obj.OD(ind).Matrix);                      % [row, column, value]
                %
                for i=1:size(dem,1)
                    Daux = dem(i)/60;
%                     CUaux = poissrnd(Daux);
                    CUaux = poissrnd(Daux)*(1+normrnd(0,0.05));
                    %
                    for iuser=1:CUaux
                        zoneO = zo(i);
                        zoneD = zd(i);

                        % Random point in Origin zone
                        [XO, YO] = randPointInZone(obj.servArea(zoneO).X, obj.servArea(zoneO).Y);
                        % Random point in Destination zone
                        [XD, YD] = randPointInZone(obj.servArea(zoneD).X, obj.servArea(zoneD).Y);
                        
                        % Store created trip
                        obj.vUsersGen(end+1,:) = [t, zoneO, XO, YO, zoneD, XD, YD];
                        
                        % Check availability and reserve vehicle
                        [carzoneO, carzoneD, carID, Stat_O, Stat_D,...
                            Xpark, Ypark, tO2C, tTrip, tC2D,...
                            SB, carFF, SBpark] = ...
                            reserveBike(param, t, obj,...
                            zoneO, XO, YO, zoneD, XD, YD); 
                        
                        if carID ~=0
                            % Create user
                            aux = User();
                            initializeUser(param, XO, YO, zoneO, carzoneO, XD, YD, zoneD, carzoneD, carID, ...
                                           Stat_O, Stat_D, Xpark, Ypark, t, tO2C, tTrip, tC2D, aux);
                            %
                            obj.numUsers = obj.numUsers + 1;
                            obj.vUsers{end+1} = aux;
                        else
                            % Lost trip -> dead user
                            % Store position, origin zone and time of death [zoneO, zoneD, SB, carFF, SBpark, t]
                            obj.notServicedUsers(end+1,:) = [zoneO, zoneD, SB, carFF, SBpark, t];
                            % Create and store user
                            aux = User();
                            initializeUser(param, XO, YO, zoneO, carzoneO, XD, YD, zoneD, carzoneD, carID, ...
                                           Stat_O, Stat_D, Xpark, Ypark, t, tO2C, tTrip, tC2D, aux);
                        end
                    end
                end
            %
            elseif param.UsersKnown == 1
                % Read users generated in t
                usrs_idx = find(obj.vUsersGen(:,1)==obj.usr_timer);
                usrs_in_t = obj.vUsersGen(usrs_idx,:);

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
                        [carzoneO, carzoneD, carID, Stat_O, Stat_D,...
                            Xpark, Ypark, tO2C, tTrip, tC2D,...
                            SB, carFF, SBpark] = ...
                            reserveBike(param, t, obj,...
                            zoneO, XO, YO, zoneD, XD, YD); 
                        
                        if carID ~=0
                            % Create user
                            aux = User();
                            initializeUser(param, XO, YO, zoneO, carzoneO, XD, YD, zoneD, carzoneD, carID, ...
                                           Stat_O, Stat_D, Xpark, Ypark, t, tO2C, tTrip, tC2D, aux);
                            %
                            obj.numUsers = obj.numUsers + 1;
                            obj.vUsers{end+1} = aux;
                        else
                            % Lost trip -> dead user
                            % Store position, origin zone and time of death [zoneO, zoneD, SB, carFF, SBpark, t]
                            obj.notServicedUsers(end+1,:) = [zoneO, zoneD, SB, carFF, SBpark, t];
                        end
                    end
                end
                % Update timer of user generation.
                obj.usr_timer = obj.usr_timer +1;
            end    
        end
        
        % reserveBikes
        function [carzoneO, carzoneD, carID, Stat_O, Stat_D, Xpark, Ypark,...
                tO2C, tTrip, tC2D, SB, carFF, SBpark] =...
                reserveBike(param, t, obj,zoneO, XO, YO, zoneD, XD, YD)
            
            % Walking and driving speeds in [m/min]
            walk_spd = param.WalkSpeed * 1000 / 60;
            drive_spd = param.CarSpeed * 1000 / 60;
            
            % Initialize
            carzoneO = zoneO;
            carzoneD = zoneD;

            %%% ASSIGN CARS AND PARKINGS
            % STEP 1: FIND CLOSEST STATION AT DESTINATION
            % Look for closest station in the same zone &
            % neighbor zones
            dmin_SBpark = 1e6;
            SBpark = 0;
            % Stations in same & neighbor zones than Destination
            % zone
            list_SB = [obj.vFreeFloatZones{zoneD}.listStations, obj.vFreeFloatZones{zoneD}.listStations_neig];
            %
            for k=1:size(list_SB,2)
                XB = obj.vStations{list_SB(k)}.X;
                YB = obj.vStations{list_SB(k)}.Y;
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
                list_SB = [obj.vFreeFloatZones{zoneO}.listStations,...
                    obj.vFreeFloatZones{zoneO}.listStations_neig]; % Stations in same & neighbor zones than user
                %
                for k=1:size(list_SB,2)
                    % Check if there are available cars in station
                    availCar = 0;
                    list_cars = obj.vStations{list_SB(k)}.listCars;
                    for l=1:size(list_cars,2)
                        if obj.vCars{list_cars(l)}.status(t) == 0  % Check that there are cars available
                            availCar = 1;
                            break;
                        end
                    end
                    %
                    if availCar > 0
                        XB = obj.vStations{list_SB(k)}.X;
                        YB = obj.vStations{list_SB(k)}.Y;
                        %
                        d = sim_dist(XO, YO, XB, YB);
                        if (d < param.Wmax) && (d < dmin_SB)       % Check also that d is lower than maximum walking distance
                            dmin_SB = d;
                            SB = list_SB(k);
                        end
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

            % STEP 3: FIND CLOSEST FF CAR AT ORIGIN                                        
            % Look for closest cars in the same zone & neighbor zones
            dmin_FF = 1e6;
            carFF = 0;
            zone_FF = carzoneO;
            list_FF = [zoneO, obj.servArea(zoneO).Neighbors];      % Current and neighbor zones
            %
            for k=1:size(list_FF,2)
                % Check the distance for every car in zone
                list_cars = obj.vFreeFloatZones{list_FF(k)}.listCars;
                %
                for l=1:size(list_cars,2)
                    if obj.vCars{list_cars(l)}.status(t) == 0      % Check that the car is available
                        XB = obj.vCars{list_cars(l)}.X(t);         % Initial position
                        YB = obj.vCars{list_cars(l)}.Y(t);
                        %
                        d = sim_dist(XO, YO, XB, YB);
                        if (d < param.Wmax) && (d < dmin_FF)       % Check also that d is lower than maximum walking distance
                            dmin_FF = d;
                            carFF = list_cars(l);
                            zone_FF = list_FF(k);
                        end
                    end
                end
            end

            % STEP 4: COMPARE FF-SB OPTIONS AND ASSIGN CAR
            % Zone car vs SB car with penalty
            Xpark = 0; Ypark = 0;                                  % Parking position
            Stat_O = 0; Stat_D = 0;                                % O & D stations (in case of FF -> Stat=0)
            %
            if SB==0 && carFF==0
                % No available cars in the same zone & neighbor zones
                % disp('No available cars in zone and neighbor zones for user');
                % User dies
                carID = 0;
            else
                if (SB~=0)&&(dmin_SB + param.penSB <= dmin_FF)     % Take car from SB (add penalty distance for SB)
                    %disp('Assigned car at SB');
                    Stat_O = SB;
                    carzoneO = obj.vStations{SB}.zoneID;
                    list_cars = obj.vStations{SB}.listCars;
                    %
                    for l=1:size(list_cars,2)
                        if obj.vCars{list_cars(l)}.status(t) == 0   % free car
                            carID = list_cars(l);
                            % Reserve the first available car in the
                            % list if it is a combustion car. If it is
                            % an electric car, then reserve the ecar
                            % with largest battery level
                            if obj.vCars{carID}.isElectric == 1
                                maxBattery = 0;
                                for ll=l+1:size(list_cars,2)
                                    if (obj.vCars{list_cars(ll)}.isElectric == 1 && ...
                                       obj.vCars{list_cars(ll)}.status(t) == 0) && ...
                                       obj.vCars{list_cars(ll)}.batteryLevel(t) > maxBattery
                                        carID = list_cars(ll);
                                        maxBattery = obj.vCars{list_cars(ll)}.batteryLevel(t);
                                    end
                                end
                            end
                            break;
                        end
                    end

                    % Assign parking destination
                    if param.Trips_SB2FF == 1                      % Trips from SB to FF ARE allowed
                        % Assign randomly either a parking on
                        % street or in a station.
                        [Xpark, Ypark, Stat_D, carzoneD] = assignParking(param, dmin_SBpark, SBpark, carzoneD, XD, YD, obj);
                    elseif param.Trips_SB2FF == 0                  % Trips from SB to FF are NOT allowed
                        % Assign the parking at station
                        % directly.
                        Xpark = obj.vStations{SBpark}.X;
                        Ypark = obj.vStations{SBpark}.Y;
                        Stat_D = SBpark;
                        carzoneD = obj.vStations{SBpark}.zoneID;
                    end

                elseif (carFF~=0)&&(dmin_SB + param.penSB > dmin_FF) % Take car from FF
                    %disp('Assigned car at FF');
                    Stat_O = 0;
                    carID = carFF;
                    carzoneO = zone_FF;

                    % Assign parking destination
                    [Xpark, Ypark, Stat_D, carzoneD] = assignParking(param, dmin_SBpark, SBpark, carzoneD, XD, YD, obj);
                end
            end

            %%% ASSIGN AND CHANGE CAR STATUS
            if carID > 0
                obj.vCars{carID}.status(t:end) = 1;                % Set car to reserved from time t onwards
                XCar = obj.vCars{carID}.X(t);
                YCar = obj.vCars{carID}.Y(t);

                %%% Compute (accumulated) time of trip parts
                % tO2Car: trip from Origin to Car (walk)
                % Car status = 1: reserved
                d = sim_dist(XO, YO, XCar, YCar);
                if Stat_O > 0                                      % If car is in a station, add penalty distance
                    d = d + param.penSB;
                end
                tO2C = t + max([1,ceil(d/walk_spd)]);              % walk_spd in [m/min]

                % tTrip: trip from Car to parking (drive)
                % Car status = 2: on trip
                d = sim_dist(XCar, YCar, Xpark, Ypark);
                if Stat_D > 0                                      % If car is parked in a station, add penalty distance
                    tPark = 0;
                else
                    park_time = param.avgParkTime;
                    zone_prk = obj.servArea(carzoneD).SB_PRK;
                    tPark = exprnd((zone_prk/param.percParking)*park_time);
                end
                tTrip = tO2C + max([1,ceil(d/drive_spd + tPark)]); % drive_spd in [m/min]

                % tC2D: trip from parking to Destination (walk)
                d = sim_dist(Xpark, Ypark, XD, YD);
                if Stat_D > 0                                      % If car is in a station, add penalty distance
                    d = d + param.penSB;
                end
                tC2D = tTrip + max([1,ceil(d/walk_spd)]);          % walk_spd in [m/min]
            else
                tO2C = 0;
                tTrip = 0;
                tC2D = 0;
            end
        end
        
        % assignParking
        function [Xpark, Ypark, Stat_D, zoneD] = assignParking(param, dmin_SBpark, SBpark, zoneD, XD, YD, obj)
            % Function that assigns parking position [X, Y] depending on
            % probability between SB & FF
            %
            if dmin_SBpark + param.penSB <= param.Wmax                     % The closest station to park is good
                % Check probability of parking in SB
                aux = rand;
                %
                %if aux <= param.percParking                                % Probability of parking in station
                if aux <= obj.servArea(obj.vStations{SBpark}.zoneID).SB_PRK % Probability of parking in station
                    Xpark = obj.vStations{SBpark}.X;
                    Ypark = obj.vStations{SBpark}.Y;
                    Stat_D = SBpark;
                    zoneD = obj.vStations{SBpark}.zoneID;
                else                                                       % Probability of parking in zone
                    % Parking in FF (random point in square centered at destination with side Wmax)
                    [Xpark, Ypark, Stat_D, zoneD] = pointAroundDest(param, zoneD, XD, YD, obj);
                end
            else                                                           % The closest station to park is too far from Destination -> FF parking
                % Parking in FF (random point in square centered at destination with side Wmax)
                [Xpark, Ypark, Stat_D, zoneD] = pointAroundDest(param, zoneD, XD, YD, obj);
            end
        end
        
        % pointAroundDest
        function [Xpark, Ypark, Stat_D, zoneD] = pointAroundDest(param, zoneD, XD, YD, obj)
            % Function that generates a random point around Destination
            % Parking in FF (random point in square centered at destination with side Wmax)
            percParking = obj.servArea(zoneD).SB_PRK;
            a = min(3*param.Wmax/2, (param.Wmax/(1-percParking))/2);
            %a = param.Wmax/2;
            XB = [XD-a, XD+a, XD+a, XD-a];
            YB = [YD-a, YD-a, YD+a, YD+a];
            Stat_D = 0;

            % Random point in zone around Destination
            in = 0;
            while in == 0
                [Xpark, Ypark] = randPointInZone(XB, YB);

                % Identify in which zone lies the point
                XX = obj.servArea(zoneD).X;                                % List of boundary nodes of zoneD
                YY = obj.servArea(zoneD).Y;
                in = inpolygon(Xpark,Ypark,XX,YY);
                %
                if in == 0                                                 % Check if point (parking) is outside of zoneD
                    % Check if point (parking) is inside of neighbor zones
                    for i=1:size(obj.servArea(zoneD).Neighbors,2)
                        izone = obj.servArea(zoneD).Neighbors(i);
                        XX = obj.servArea(izone).X;
                        YY = obj.servArea(izone).Y;
                        %
                        in = inpolygon(Xpark,Ypark,XX,YY);
                        if in == 1
                            zoneD = izone;
                            break;
                        end
                    end
                    %
                    if in == 0                                             % If parking position not in zoneD or neighbor, look full list of zones
                        for i=1:size(obj.servArea,2)
                            XX = obj.servArea(izone).X;
                            YY = obj.servArea(izone).Y;
                            %
                            in = inpolygon(Xpark,Ypark,XX,YY);
                            if in == 1
                                zoneD = i;
                                break;
                            end
                        end
                    end
                end
            end
        end
        
        % moveUsers
        function moveUsers(param, t, obj)
            % Function that manages the users at time step t
            %
            finishedUsers = [];                                            % List to store finished users at time t
            %
            for iusr=1:obj.numUsers
                carID = obj.vUsers{iusr}.CarID;
                %
                if t > obj.vUsers{iusr}.tCreation && t < obj.vUsers{iusr}.tO2Car
                    % User is walking to take the car
                    
                elseif t == obj.vUsers{iusr}.tO2Car
                    % User takes the car
                    
                    % If car in station, remove it from station list
                    % If car in zone, remove it from FF list
                    stat = obj.vUsers{iusr}.StatO;
                    if stat > 0
                        listCars = obj.vStations{stat}.listCars;
                        k1 = find(carID==listCars);
                        obj.vStations{stat}.listCars(k1) = [];
                        %
                        % If car is electric and charging, remove it from
                        % list
                        k2 = find(carID==obj.vStations{stat}.listCharging);
                        obj.vStations{stat}.listCharging(k2) = [];

                    else
                        zoneO = obj.vUsers{iusr}.CarZoneO;
                        k1 = find(carID==obj.vFreeFloatZones{zoneO}.listCars);
                        obj.vFreeFloatZones{zoneO}.listCars(k1) = [];
                    end
                    
                    % Change car status to driving from t onwards
                    obj.vCars{carID}.status(t:end) = 2;
                    
                    % Change car position to NaN from t onwards
                    obj.vCars{carID}.X(t:end) = NaN;
                    obj.vCars{carID}.Y(t:end) = NaN;
                    
                elseif t > obj.vUsers{iusr}.tO2Car && t < obj.vUsers{iusr}.tTrip
                    % User drives the car to parking destination
                    
                    % Reduce battery level if electric car (per minute)
                    if obj.vCars{carID}.isElectric == 1
                        d1min = param.CarSpeed / 60;                       % Car distance in 1 min [km]
                        perc = 100 * d1min/param.BatteryConsume;           % Battery reduction percentage in 1 min
                        obj.vCars{carID}.batteryLevel(t:end) = obj.vCars{carID}.batteryLevel(t) - perc;
                    end
                    
                elseif t == obj.vUsers{iusr}.tTrip
                    % User parks the car
                    %%% Check free parking availability
                    stat = obj.vUsers{iusr}.StatD;
                    if numel(obj.vStations{stat}.listCars)<obj.vStations{stat}.capacity
                        %%% AVAILABLE PARKING
                        % Change car status to available from t onwards
                        obj.vCars{carID}.status(t:end) = 0;
                        
                        % Change car position from t onwards
                        obj.vCars{carID}.X(t:end) = obj.vUsers{iusr}.Xpark;
                        obj.vCars{carID}.Y(t:end) = obj.vUsers{iusr}.Ypark;                    
                        
                        % If car in station, add it to station list
                        % If car in zone, add it to FF list
                        stat = obj.vUsers{iusr}.StatD;
                        zoneD = obj.vUsers{iusr}.CarZoneD;
                        if stat > 0
                            obj.vStations{stat}.listCars(end+1) = carID;
                        else
                            obj.vFreeFloatZones{zoneD}.listCars(end+1) = carID;
                        end
                        
                        % If electric car and battery level too low, not available
                        if (obj.vCars{carID}.isElectric == 1) && (obj.vCars{carID}.batteryLevel(t) < obj.minBatteryLevel)
                            obj.vCars{carID}.status(t:end) = 4;                  % Change status to be recharged (not available)
                        end
                    else
                        %%% NO AVAILABLE PARKING
                        if param.fullDest == 1
                            % User looks for a different station.
                            [newSBpark] = changeParking(param, t, obj, iusr);
                            if newSBpark ~= 0 && newSBpark ~=obj.vUsers{iusr}.StatD
                            % User tries the new station (if any).
                                % If the previous station was the original,
                                % store it.
                                if obj.vUsers{iusr}.StatD_min == 0
                                    obj.vUsers{iusr}.StatD_min = obj.vUsers{iusr}.StatD;
                                end
                                % New parking time
                                Xnew = obj.vStations{newSBpark}.X;
                                Ynew = obj.vStations{newSBpark}.Y;
                                drive_spd = param.CarSpeed * 1000 / 60;
                                d = sim_dist(Xnew, Ynew, obj.vUsers{iusr}.Xpark, obj.vUsers{iusr}.Ypark);
                                newtTrip = t + max([1, ceil(d/drive_spd)]);
                                % New finish time.
                                walk_spd = param.WalkSpeed * 1000 / 60;
                                d = sim_dist(Xnew, Ynew, obj.vUsers{iusr}.XD, obj.vUsers{iusr}.YD);
                                newtC2D = newtTrip + max([1,ceil(d/walk_spd)]);
                                % Change new parking parameters.
                                obj.vUsers{iusr}.StatD = newSBpark;
                                obj.vUsers{iusr}.CarZoneD = obj.vStations{newSBpark}.zoneID;
                                obj.vUsers{iusr}.Xpark = Xnew;
                                obj.vUsers{iusr}.Ypark = Ynew;
                                obj.vUsers{iusr}.tParkAdd = obj.vUsers{iusr}.tParkAdd + (newtC2D - obj.vUsers{iusr}.tCar2D);
                                obj.vUsers{iusr}.tTrip = newtTrip;
                                obj.vUsers{iusr}.tCar2D = newtC2D;           
                            else
                                % User waits. (No alternatives)
                                obj.vUsers{iusr}.StatD_min = obj.vUsers{iusr}.StatD;
                                obj.vUsers{iusr}.tParkAdd = obj.vUsers{iusr}.tParkAdd + 1;
                                obj.vUsers{iusr}.tTrip = obj.vUsers{iusr}.tTrip + 1;
                                obj.vUsers{iusr}.tCar2D = obj.vUsers{iusr}.tCar2D + 1;
                            end
                        else
                            % User waits.
                            obj.vUsers{iusr}.StatD_min = obj.vUsers{iusr}.StatD;
                            obj.vUsers{iusr}.tParkAdd = obj.vUsers{iusr}.tParkAdd + 1;
                            obj.vUsers{iusr}.tTrip = obj.vUsers{iusr}.tTrip + 1;
                            obj.vUsers{iusr}.tCar2D = obj.vUsers{iusr}.tCar2D + 1;
                        end
                    end
                   
                elseif (t > obj.vUsers{iusr}.tTrip) && (t < obj.vUsers{iusr}.tCar2D)
                    % User walks to destination
                    
                elseif t == obj.vUsers{iusr}.tCar2D
                    % User arrives at destination
                    
                    % Trip finished, remove user (store finished users)
                    finishedUsers(end+1) = iusr;
                    
                else
                    % Error
                    error(['User ' num2str(iusr) ' should not be active at time ' num2str(t)]);
                end
            end
            %
            % Generate array to store finished user objects
            for i=1:size(finishedUsers,2)
                obj.vFinishedUsers{end+1} = obj.vUsers{finishedUsers(i)};
                obj.numFinishedUsers = obj.numFinishedUsers + 1;
            end
            
            % Remove finished users from array of active users
            obj.vUsers(finishedUsers) = [];
            obj.numUsers = obj.numUsers - size(finishedUsers,2);
            
        end
        
        % changeParking
        function [newSBpark] = changeParking(param, t, obj, iusr)
            % Function that assigns new parking station when original
            % station is full at destination.
            %
            % STEP 1: FIND CLOSEST STATION AT DESTINATION
            % Look for closest station in the same zone &
            % neighbor zones
            dmin_SBpark = 1e6;
            newSBpark = 0;
            searchD = obj.vUsers{iusr}.CarZoneD;
            % Stations in same & neighbor zones than Destination
            % zone
            list_SB = [obj.vFreeFloatZones{searchD}.listStations, obj.vFreeFloatZones{searchD}.listStations_neig];
            %
            for k=1:size(list_SB,2)
                % Check parking availability on each station.
                if numel(obj.vStations{list_SB(k)}.listCars)<obj.vStations{list_SB(k)}.capacity
                    % If available, calculate distance.
                    XB = obj.vStations{list_SB(k)}.X;
                    YB = obj.vStations{list_SB(k)}.Y;
                    %
                    d = sim_dist(obj.vUsers{iusr}.XD, obj.vUsers{iusr}.YD, XB, YB);
                    %
                    if (d < dmin_SBpark)           % Check minimum walking distance to destination
                        dmin_SBpark = d;
                        newSBpark = list_SB(k);
                    end
                end
            end
        end
        
        % rechargeCars
        function rechargeCars(param, t, obj)
            % Function that manages the recharging of electric cars at
            % current time
            %
            % Update battery levels
            for istat=1:obj.numStations
                listCharge = obj.vStations{istat}.listCharging;
                fullCars = [];
                for icar=1:size(listCharge,2)
                    carID = listCharge(icar);
                    obj.vCars{carID}.batteryLevel(t:end) = min(100, obj.vCars{carID}.batteryLevel(t) + (80/param.BatteryChargeTime));
                    %
                    % If battery over minimum and discharged status, change
                    % status to available.
                    if (obj.vCars{carID}.batteryLevel(t) >= obj.minBatteryLevel) && (obj.vCars{carID}.status(t) == 4)
                        obj.vCars{carID}.status(t:end) = 0;                  % Set car status to available
                    % If full battery, remove from charging list.
                    elseif obj.vCars{carID}.batteryLevel(t) >= 100
                        fullCars(end+1) = icar;
                        obj.vCars{carID}.batteryLevel(t:end) = 100;
                    end
                end
                %
                obj.vStations{istat}.listCharging(fullCars) = [];
            end
            
            % Manage list of charging cars at every station
            for istat=1:obj.numStations
                listCharge = obj.vStations{istat}.listCharging;
                listCars = obj.vStations{istat}.listCars;
                cand = [];                                                 % Car candidates to be recharged
                %
                % Check if there are chargers available
                empty_spots = obj.vStations{istat}.numChargers - size(listCharge,2);
                if empty_spots > 0
                    %
                    % Look for electric cars to charge
                    for icar=1:size(listCars,2)
                        carID = listCars(icar);
                        if obj.vCars{carID}.isElectric == 1 && obj.vCars{carID}.batteryLevel(t) < 100
                            cand(end+1,:) = [carID, obj.vCars{carID}.batteryLevel(t)];
                        end
                    end
                    %
                    % Order candidates by battery level
                    if size(cand,1) > 0 && size(cand,2) >  0
                        cand = sortrows(cand,2);                           % Sort car candidates ascending by battery level
                        % 
                        ind = min(empty_spots, size(cand,1));
                        for i=1:ind
                            obj.vStations{istat}.listCharging(end+1) = cand(ind,1);
                            % Redundant filter, but ok.
                            if cand(ind,2) <= obj.minBatteryLevel
                                obj.vCars{cand(ind,1)}.status(t:end) = 4;  % Not enough battery
                            end
                        end
                    end
                    % Remove duplicated cars
                    if size(obj.vStations{istat}.listCharging,2) > 0
                        obj.vStations{istat}.listCharging = unique(obj.vStations{istat}.listCharging);
                    end
                    
                elseif empty_spots == 0 && obj.vStations{istat}.numChargers > 0
                    % Only if the station has charging infrastructure.
                    disp(['All chargers are full at station ' num2str(istat) ' at time ' num2str(t)]);
                end
            end
        end
        
        % setRepo
        function setRepo(param, obj)
            % Function to generate the repositioning teams of the system
            
            % Repositioning teams start on service area centroid
            %%% Comprobar si está calculado.
            X = 0;
            Y = 0;
            for i=1:numel(obj.vFreeFloatZones)
                X = X + obj.vFreeFloatZones{i}.X;
                Y = Y + obj.vFreeFloatZones{i}.Y;
            end
            X = X/numel(obj.vFreeFloatZones);
            Y = Y/numel(obj.vFreeFloatZones);
            
            % Create Repositioning Teams
            obj.numRepoTeams = param.repoTeams;
            capacity = param.repoCapacity;
            
            for i=1:obj.numRepoTeams
                aux = RepoTeam ();
                % Initialize Repositioning Team
                initializeTeam(param.TotalTime, i, X, Y, capacity, aux);
                % Add Repositioning Team to array
                obj.vRepoTeams{i} = aux;  
            end           
        end
               
        % assignTasks
        function moveRepoTeams(param, t, obj)
            % Function to assign each repositioning team the next task
            % after the current one is finished.
           
            %%% Select the repositioning algorithm and update team
            %    status and tasks.
            if param.repoMethod == 0
                % METHOD 0: No repositioning
                %
                updateOptimumDistribution(param, t, obj)
                
            elseif param.repoMethod == 1
                % METHOD 1: Pairwise assignment.
                %   Each time step, move teams, update optimum
                %   distribution, and assign new tasks if necessary.
                %
                %
                [obj.vRepoTeams, obj.vStations, obj.vCars, vRepoPool, idle_cntr] = ...
                    repoTeamAction_bikSB(t, obj.vRepoTeams, obj.vStations,...
                    obj.vCars, param, obj.minBatteryLevel);
                %
                updateOptimumDistribution(param, t, obj)
                %
                if idle_cntr>0
                    [obj.vRepoTeams, obj.vStations, obj.vCars] = ...
                        optimRepoTaskAssignment_bikSB(t, obj.vRepoTeams, vRepoPool,...
                        obj.vStations, obj.vCars, param);
                end
                    
            elseif param.repoMethod == 2
                % METHOD 2: Predefined route + modification.
                %   All teams have already a list of expected tasks. After
                %   a task is finished, the next one is reevaluated
                %   according to the current system status and performance.
                %
                %
                [obj.vRepoTeams, obj.vStations, obj.vCars, vRepoPool, idle_cntr] = ...
                    repoTeamAction_bikSB(t, obj.vRepoTeams, obj.vStations,...
                    obj.vCars, param, obj.minBatteryLevel);
                %
                updateOptimumDistribution(param, t, obj)
                %
                if idle_cntr>0
                    [obj.vRepoTeams, obj.vStations, obj.vCars] = ...
                        optimRepoTaskAssignment_bikSB(t, obj.vRepoTeams, vRepoPool,...
                        obj.vStations, obj.vCars, param);
                end
            
            elseif param.repoMethod == 3
                % METHOD 3: Predefined route only.
                %   All teams have already a list of expected tasks. The
                %   teams follow that list without reevaluation.
                %
                %
                [obj.vRepoTeams, obj.vStations, obj.vCars, ~, ~] = ...
                    repoTeamAction_bikSB(t, obj.vRepoTeams, obj.vStations,...
                    obj.vCars, param, obj.minBatteryLevel);
                %
                updateOptimumDistribution(param, t, obj)
            end
            
            %%% NOTA: En el futuro hay que hacer modificaciones a este
            %%% módulo:
            %%% - Considerar una calibración del coste de mantener quieto
            %%% un equipo para que no realicen tareas contraproducentes.
            %%% HECHO TODO EN BIKESHARING
        end
        
        % updateOptimumDistribution
        function updateOptimumDistribution(param, t, obj)
            % Function to calculate the optimum distribution of cars for
            % each time step.
            
            %%% On Stations
            % Total available number of cars on stations.
            m_SB = 0;
            for i = 1:obj.numStations
                list = obj.vStations{i}.listCars;
                for j = 1:numel(list)
                    if obj.vCars{list(j)}.status(t) == 0
                        m_SB = m_SB + 1;
                    end
                end                          
            end
            for i = 1:obj.numRepoTeams
                m_SB = m_SB + numel(obj.vRepoTeams{i}.listBikes); 
            end
            % Optimal distribution on stations
            if obj.numStations > 0
                BPenSB = [param.costLostSB(1), param.costLostSB(2)];
                [obj.vStations] = optimDistribution(...
                    obj.vStations, m_SB, t, BPenSB);
            end
            
            %%% On Free Floating Zones
            % Total available number of cars on street.
            m_FF = 0;
            for i = 1:obj.numFreeFloatZones
                list = obj.vFreeFloatZones{i}.listCars;
                for j = 1:numel(list)
                    if obj.vCars{list(j)}.status(t) == 0
                        m_FF = m_FF + 1;
                    end
                end                              
            end
            % Optimal distribution on street
            if m_FF ~=0
                [obj.vFreeFloatZones] = optimDistribution(...
                        obj.vFreeFloatZones, m_FF, t, [param.costLostFF(1); param.costLostFF(2)]);
            end
        end
        
    end
end










