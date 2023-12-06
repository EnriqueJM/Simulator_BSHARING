% User class

classdef User<handle
    
    properties
        X             % current X position UTM [m]
        Y             % current Y position UTM [m]
        Z             % current Z position UTM [m]
        %status        % user status (0: origin, 1: travelling, 2: destination, 3: dead)
        
        XO            % origin X position UTM [m]
        YO            % origin Y position UTM [m]
        ZO            % origin Z position UTM [m]
        ZoneO         % origin Zone
        CarZoneO      % origin Zone for Car (may be different from user origin Zone)
    
        XD            % destination X position UTM [m]
        YD            % destination Y position UTM [m]
        ZD            % destination Z position UTM [m]
        ZoneD         % destination Zone
        CarZoneD      % destination Zone for Car (may be different from user destination Zone)
        
        CarID         % ID of assigned Car
        StatO         % Station at origin (0: FreeFloatZone)
        StatD         % Station at destination (0: FreeFloatZone)
        Xpark         % X position at parking [m]
        Ypark         % Y position at parking [m]
        
        tCreation     % time of creation
        tO2Car        % time from Origin to Car (walk)
        tTrip         % time of car trip
        tCar2D        % time from parking to Destination (walk)

        StatD_min     % Station at destination (original)
        tParkAdd      % additional trip time due to full parking
    
    end
    
    methods
%% CONSTRUCTOR

        function obj = User()  % constructor
            obj.X = 0;
            obj.Y = 0;
            obj.Z = 0;
            
            obj.XO = 0;
            obj.YO = 0;
            obj.ZO = 0;
            obj.ZoneO = 0;
            obj.CarZoneO = 0;
            
            obj.XD = 0;
            obj.YD = 0;
            obj.ZD = 0;
            obj.ZoneD = 0;
            obj.CarZoneD = 0;
            
            obj.CarID = 0;
            obj.StatO = 0;
            obj.StatD = 0;
            obj.Xpark = 0;
            obj.Ypark = 0;
            
            obj.tCreation = 0;
            obj.tO2Car = 0;
            obj.tTrip = 0;
            obj.tCar2D = 0;

            obj.StatD_min = 0;
            obj.tParkAdd = 0;
            
        end
        
        %initializeUser
        function initializeUser(param, XO, YO, zoneO, carzoneO, XD, YD, zoneD, carzoneD, carID, StatO, StatD, Xpark, Ypark, tCr, tO2C, tTrip, tC2D, obj)
            obj.X = XO;
            obj.Y = YO;
            
            obj.XO = XO;
            obj.YO = YO;
            obj.ZoneO = zoneO;
            obj.CarZoneO = carzoneO;
            
            obj.XD = XD;
            obj.YD = YD;
            obj.ZoneD = zoneD;
            obj.CarZoneD = carzoneD;
            
            obj.CarID = carID;
            obj.StatO = StatO;
            obj.StatD = StatD;
            obj.Xpark = Xpark;
            obj.Ypark = Ypark;
            
            obj.tCreation = tCr;
            obj.tO2Car = tO2C;
            obj.tTrip = tTrip;
            obj.tCar2D = tC2D;
        end
        
    end
    
end