% FREE FLOAT ZONE class

classdef FreeFloatZone<handle
    
    properties
        ID                     % station identifier
        X                      % centroid X position UTM [m]
        Y                      % centroid Y position UTM [m]
        Z                      % centroid Z position UTM [m]
        
        zoneArea               % zone area [m2]
        capacity               % station capacity
        numChargers            % number of chargers in zone
        nearestCharger         % ID of the nearest station with chargers
        
        numStations            % number of stations inside the zone
        listStations           % list of stations inside the zone
        
        numStations_neig       % number of stations in the neighbor zones
        listStations_neig      % list of stations in the neighbor zones
        
        accRequests            % accumulated demand over time
        accReturns             % accumulated returns over time
        
        optCars                % optimum number of cars over time
        listCars               % list of cars in the zone
        vlistCars              % array to store list of cars in the zone over time

    end
    
    methods
%% CONSTRUCTOR

        function obj = FreeFloatZone()    % constructor
            obj.ID = 0;
            obj.X = 0;
            obj.Y = 0;
            obj.Z = 0;
            obj.zoneArea = 0;
            obj.capacity = 1e6;
            obj.numChargers = 0;
            obj.nearestCharger = [];
            
            obj.numStations = 0;
            obj.listStations = [];
            
            obj.numStations_neig = 0;
            obj.listStations_neig = [];
            
            obj.accRequests = [];
            obj.accReturns = [];
            
            obj.optCars = [];
            obj.listCars = [];
            obj.vlistCars = {};
            
        end
        
%% INITIALIZATION FUNCTIONS

        %initializeFreeFloatZone
        function initializeFreeFloatZone(param, servArea, obj)
            obj.ID = servArea.NO;

            % Create polyshape
            pgon = polyshape(servArea.X(~isnan(servArea.X)), servArea.Y(~isnan(servArea.Y)));
            [obj.X, obj.Y] = centroid(pgon);
            obj.zoneArea = area(pgon);
            %
            obj.accRequests = zeros(param.TotalTime+1,1);
            obj.accReturns = zeros(param.TotalTime+1,1);
            obj.optCars = zeros(param.TotalTime+1,1);

        end

    end
    
end