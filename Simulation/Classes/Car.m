% CAR class

classdef Car<handle
    
    properties
        ID                     % car identifier
        X                      % array of X position UTM in time [m]
        Y                      % array of Y position UTM in time [m]
        Z                      % array of Z position UTM in time [m]
        status                 % array of car status in time (0: free, 1: reserved, 2: on trip, 3: repositioning, 4: not enough battery)
        isElectric             % 1: electric car; 0: combustion car
        batteryLevel           % array of battery levels of electric car in time
        
    end
    
    methods
%% CONSTRUCTOR

        function obj = Car()    % constructor
            obj.ID = 0;
            obj.X = [];
            obj.Y = [];
            obj.Z = [];
            obj.status = [];
            obj.isElectric = 0;
            obj.batteryLevel = [];
            
        end
        
%% INITIALIZATION FUNCTIONS

        % initializeCar
        function initializeCar(param, i, X, Y, obj)
            %obj.X = zeros(1, param.TotalTime);
            %obj.Y = zeros(1, param.TotalTime);
            obj.status = zeros(1, param.TotalTime);
            obj.batteryLevel = 100*ones(1, param.TotalTime);
            
            obj.ID = i;
            obj.X = X*ones(1, param.TotalTime);
            obj.Y = Y*ones(1, param.TotalTime);
        end
        
    end
    
end