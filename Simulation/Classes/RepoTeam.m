% REPOTEAM class - ver 2021.12.15

classdef RepoTeam<handle
    
    properties
        ID                     % Repositioning team identifier
        X                      % array of X position UTM in time [m]
        Y                      % array of Y position UTM in time [m]
        Z                      % array of Z position UTM in time [m]
        status                 % array of status in time (0: idle, 1: moving on scooter, 2: moving on car)
        vehicles               % array of number of vehicles carried during time
        capacity               % maximum number of vehicles that the team can carry
        taskStat               % array of task type (0: FF zone, 1: Station)
        taskList               % array of zones/stations to visit during the next day
        taskType               % array of task type/priority (1: recharging, 2: repositioning)
        taskMovements          % array of movements of cars (-1: pick one car, +1: retunr one car)
        taskTime               % array of task ending time
        taskUtility            % array of task utility
        taskCurrent            % index of current task.
        carID                  % index of currently carried car.
        listBikes
        
    end
    
    methods
%% CONSTRUCTOR

        function obj = RepoTeam()    % constructor
            obj.ID = 0;
            obj.X = [];
            obj.Y = [];
            obj.Z = [];
            obj.status = [];
            obj.capacity = 0;
            obj.vehicles = [];
            obj.taskStat = [];
            obj.taskList = [];
            obj.taskType = [];
            obj.taskMovements = [];
            obj.taskTime = [];
            obj.taskUtility = [];
            obj.taskCurrent = 0;
            obj.carID = [];
            obj.listBikes = [];
            
        end
        
%% INITIALIZATION FUNCTIONS

        % initializeTeam
        function initializeTeam(TotalTime, i, X, Y, capacity, obj)
            obj.ID = i;
            obj.X = X*ones(1, TotalTime);
            obj.Y = Y*ones(1, TotalTime);
            obj.capacity = capacity;
            obj.status = zeros(1, TotalTime);
            obj.vehicles = zeros(1, TotalTime);
            obj.carID = zeros(1, TotalTime);
            
        end
        
    end
    
end