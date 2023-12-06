% TASK class

classdef Task<handle
    
    properties
        ID                     % Task identifier
        X                      % X position UTM [m]
        Y                      % Y position UTM [m]
        Z                      % Z position UTM [m]
        taskStat               % task type (0: FF zone, 1: Station)
        taskStatID             % zones/stations ID to visit
        taskType               % type/priority (1: recharging, 2: repositioning)
        taskMovements          % number of vehicles to move (+1, -1)
        taskUtility            % utility of task [€]
        
    end
    
    methods
%% CONSTRUCTOR

        function obj = Task()    % constructor
            obj.ID = 0;
            obj.X = [];
            obj.Y = [];
            obj.Z = [];
            obj.taskStat = 0;
            obj.taskStatID = 0;
            obj.taskType = 0;
            obj.taskMovements = 0;
            obj.taskUtility = 0;
            
        end
        
%% INITIALIZATION FUNCTIONS

        % initializeTask
        function initializeTask(i, X, Y, stat, statID, mov, obj)
            obj.ID = i;
            obj.X = X;
            obj.Y = Y;
            obj.taskStat = stat;
            obj.taskStatID = statID;
            obj.taskMovements = mov;
        end
        
    end
    
end