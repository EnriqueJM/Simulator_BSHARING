% STATION class

classdef Station<handle
    
    properties
        ID                     % station identifier
        Name                   % station name
        X                      % X position UTM [m]
        Y                      % Y position UTM [m]
        Z                      % Z position UTM [m]
        
        capacity               % station capacity
        numChargers            % number of chargers in station
        nearestCharger         % ID of the nearest station with chargers
        
        numCars                % number of combustion cars
        numEcars               % number of electric cars
        numBikes
        accRequests            % accumulated demand over time
        accReturns             % accumulated returns over time
        predRequests           % prediction of accumulated demand over time
        predReturns            % prediction of accumulated returns over time
        
        optCars                % optimum number of cars over time
        listCars               % list of cars in station
        listCharging           % list of cars charging in station
        vlistCars              % array to store list of cars in station over time
        vlistCharging          % array to store list of cars charging in station over time
        
        zoneID                 % ID of zone where station lies
        
    end
    
    methods
%% CONSTRUCTOR

        function obj = Station()    % constructor
            obj.ID = 0;
            obj.Name = '';
            obj.X = 0;
            obj.Y = 0;
            obj.Z = 0;
            
            obj.capacity = 9999;
            obj.numChargers = 9999;
            obj.nearestCharger = [];
            
            obj.numCars = 0;
            obj.numEcars = 0;
            obj.numBikes = [];
            obj.accRequests = [];
            obj.accReturns = [];
            obj.predRequests = [];
            obj.predReturns = [];
            
            obj.optCars = [];
            obj.listCars = [];
            obj.listCharging = [];
            obj.vlistCars = {};
            obj.vlistCharging = {};
            
            obj.zoneID = 0;
            
        end
        
%% INITIALIZATION FUNCTIONS

        %initializeStation
        function initializeStation_manual(ID, X, Y, Z, TotalTime, obj)
            % data, text are the arrays from values
            obj.ID = ID;
            %
            obj.X = X;
            obj.Y = Y;
            obj.Z = Z;
            %
            obj.numBikes = zeros(TotalTime+1,1);
            obj.accRequests = zeros(TotalTime+1,1);
            obj.accReturns = zeros(TotalTime+1,1);
            obj.optCars = zeros(TotalTime+1,1);

        end
        
        %initializeStation_excel
        function initializeStation_excel(param, data, text, obj)
            % data, text are the arrays from reading the excel file
            obj.ID = data(1);
            obj.Name = text{2};
            %
            obj.X = data(3);
            obj.Y = data(4);
            obj.Z = data(5);
            %
            obj.capacity = data(6);
            obj.numChargers = data(7);
            %
            obj.numBikes = zeros(param.TotalTime+1,1);
            obj.accRequests = zeros(param.TotalTime+1,1);
            obj.accReturns = zeros(param.TotalTime+1,1);
            obj.optCars = zeros(param.TotalTime+1,1);

        end
        
    end
    
end