function simulation(param, City)
    tic;
    
    % check correct inputs
    %errorInputs(param)
    
    % initialize the city
    disp('Initializing the city');
    initializeCity(param, City);
        
    % warmup cycles
    for icycle=1:param.WarmUpCycles
        
        % time simulation of service
        disp('Warmup simulation');
        timeSimulation(param, City);
        %
        % Set-up next simulation
        %
        for istat=1:City.numStations
            City.vStations{istat}.optCars = zeros(param.TotalTime+1, 1);
            City.vStations{istat}.accRequests = zeros(param.TotalTime+1, 1);
            City.vStations{istat}.accReturns = zeros(param.TotalTime+1, 1);
            %
            City.vStations{istat}.vlistCars = {};
            City.vStations{istat}.vlistCars{1} = City.vStations{istat}.listCars;
            City.vStations{istat}.vlistCharging = {};
            City.vStations{istat}.vlistCharging{1} = City.vStations{istat}.listCharging;
        end
        %
        for izone=1:City.numFreeFloatZones
            City.vFreeFloatZones{izone}.optCars = zeros(param.TotalTime+1, 1);
            %
            City.vFreeFloatZones{izone}.vlistCars = {};
            City.vFreeFloatZones{izone}.vlistCars{1} = City.vFreeFloatZones{izone}.listCars;
        end
        %
        for icar=1:City.numCars
            X = City.vCars{icar}.X(end);
            Y = City.vCars{icar}.Y(end);
            status = City.vCars{icar}.status(end);
            battery_level = City.vCars{icar}.batteryLevel(end);
            %
            City.vCars{icar}.X = X*ones(1, param.TotalTime);
            City.vCars{icar}.Y = Y*ones(1, param.TotalTime);
            City.vCars{icar}.status = status*ones(1, param.TotalTime);
            City.vCars{icar}.batteryLevel = battery_level*ones(1, param.TotalTime);
        end
        %
        for irepo=1:City.numRepoTeams
            X = City.vRepoTeams{irepo}.X(end);
            Y = City.vRepoTeams{irepo}.Y(end);
            status = City.vRepoTeams{irepo}.status(end);
            vehicles = City.vRepoTeams{irepo}.vehicles(end);
            carID = City.vRepoTeams{irepo}.carID(end);
            %
            City.vRepoTeams{irepo}.X = X*ones(1, param.TotalTime);
            City.vRepoTeams{irepo}.Y = Y*ones(1, param.TotalTime);
            City.vRepoTeams{irepo}.status = status*ones(1, param.TotalTime);
            City.vRepoTeams{irepo}.vehicles = vehicles*ones(1, param.TotalTime);
            City.vRepoTeams{irepo}.carID = carID*ones(1, param.TotalTime);
            %
            City.vRepoTeams{irepo}.taskTime = City.vRepoTeams{irepo}.taskTime - param.TotalTime;
            past_tasks = find(City.vRepoTeams{irepo}.taskTime < 1);
            City.vRepoTeams{irepo}.taskTime(past_tasks) = [];
            City.vRepoTeams{irepo}.taskStat(past_tasks) = [];
            City.vRepoTeams{irepo}.taskList(past_tasks) = [];
            City.vRepoTeams{irepo}.taskType(past_tasks) = [];
            City.vRepoTeams{irepo}.taskMovements(past_tasks) = [];
            City.vRepoTeams{irepo}.taskUtility(past_tasks) = [];
            %
            if numel(City.vRepoTeams{irepo}.taskTime)>1
                City.vRepoTeams{irepo}.taskTime = City.vRepoTeams{irepo}.taskTime(1);
                City.vRepoTeams{irepo}.taskStat = City.vRepoTeams{irepo}.taskStat(1);
                City.vRepoTeams{irepo}.taskList = City.vRepoTeams{irepo}.taskList(1);
                City.vRepoTeams{irepo}.taskType = City.vRepoTeams{irepo}.taskType(1);
                City.vRepoTeams{irepo}.taskMovements = City.vRepoTeams{irepo}.taskMovements(1);
                City.vRepoTeams{irepo}.taskUtility = City.vRepoTeams{irepo}.taskUtility(1);
            end
            if status == 0
                City.vRepoTeams{irepo}.taskCurrent = 0;
            else
                City.vRepoTeams{irepo}.taskCurrent = 1;
            end
        end
        %
        for iusers=1:City.numUsers
            %
            City.vUsers{iusers}.tCreation  = City.vUsers{iusers}.tCreation - param.TotalTime;
            City.vUsers{iusers}.tO2Car = City.vUsers{iusers}.tO2Car - param.TotalTime;
            City.vUsers{iusers}.tTrip = City.vUsers{iusers}.tTrip - param.TotalTime;
            City.vUsers{iusers}.tCar2D = City.vUsers{iusers}.tCar2D - param.TotalTime;
        end
        City.numFinishedUsers = 0;
        City.vFinishedUsers = {};
        City.notServicedUsers = [];
        if param.UsersKnown == 0
            City.vUsersGen(:,1) = City.vUsersGen(:,1) - param.TotalTime;
        end
    end
    
    % Time simulation of service
    disp('Time simulation');
    timeSimulation(param, City);
    
    % Total simulation time
    t = toc;
    if param.verbose
        disp('');
        disp(['Total simulation time [min]: ' num2str(t/60)]);
    end
    if param.UsersKnown == 0
        City.vUsersGen(:,1) = City.vUsersGen(:,1) + param.TotalTime*param.WarmUpCycles;
    end
end

