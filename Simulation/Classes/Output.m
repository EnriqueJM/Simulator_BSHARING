% Output class

classdef Output<handle
    
    properties
        datafile             % results file to process
        MyCity               % City object
        
        %%%%%%%%%%%%
        % VEHICLES %
        %%%%%%%%%%%%
        CarsSB_dt              % table with number of cars per station at every hour (mean)
        CarsFF_dt              % table with number of cars per zone at every hour (mean)
        CarsTotal_dt           % table with number of cars per station+zone at every hour (mean)
        CarStatus_dt           % table with number of cars per status at every hour (mean)
        %
        CarsSB_AggT            % table with number of cars per station aggregated by time (mean)
        CarsFF_AggT            % table with number of cars per zone aggregated by time (mean)
        CarsTotal_AggT         % table with number of cars per station+zone aggregated by time (mean)
        CarStatus_AggT         % table with number of cars per status aggregated by time (mean)
        %
        CarsSB_AggR            % table with number of cars per station aggregated by region (mean)
        CarsFF_AggR            % table with number of cars per zone aggregated by region (mean)
        CarsTotal_AggR         % table with number of cars per station+zone aggregated by region (mean)

        %%%%%%%%%%%%%%%%%
        % BATTERY LEVEL %
        %%%%%%%%%%%%%%%%%
        BatterySB_dt           % table with battery level of ecars per station at every hour (mean)
        BatteryFF_dt           % table with battery level of ecars per zone at every hour (mean)
        BatteryTotal_dt        % table with battery level of ecars station+zone at every hour (mean)
        %
        BatterySB_AggT         % table with battery level of ecars per station aggregated by time (mean)
        BatteryFF_AggT         % table with battery level of ecars per zone aggregated by time (mean)
        BatteryTotal_AggT      % table with battery level of ecars station+zone aggregated by time (mean)
        %
        BatterySB_AggR         % table with battery level of ecars per station aggregated by region (mean)
        BatteryFF_AggR         % table with battery level of ecars per zone aggregated by region (mean)
        BatteryTotal_AggR      % table with battery level of ecars station+zone aggregated by region (mean)

        %%%%%%%%%%%%%%%%%%%%%
        % STATION OCCUPANCY %
        %%%%%%%%%%%%%%%%%%%%%
        EmptySlotsSB_dt           % table with empty parking slots per station at every hour (mean)
        OccupancySB_dt            % table with occupancy pctg per station at every hour (mean)
        %
        EmptySlotsSB_AggT         % table with empty parking slots per station aggregated by time (mean)
        OccupancySB_AggT          % table with occupancy pctg per station aggregated by time (mean)
        %
        EmptySlotsSB_AggR         % table with empty parking slots per station aggregated by region (mean)
        OccupancySB_AggR          % table with occupancy pctg per station aggregated by region (mean)
        %
        EmptyChargersSB_dt        % table with empty chargers per station at every hour (mean)
        OccupancyChargersSB_dt    % table with chargers occupancy pctg per station at every hour (mean)
        %
        EmptyChargersSB_AggT      % table with empty chargers per station aggregated by time (mean)
        OccupancyChargersSB_AggT  % table with chargers occupancy pctg per station aggregated by time (mean)
        %
        EmptyChargersSB_AggR      % table with empty chargers per station aggregated by region (mean)
        OccupancyChargersSB_AggR  % table with chargers occupancy pctg per station aggregated by region (mean)
        
        %%%%%%%%%%%%%
        % UNBALANCE %
        %%%%%%%%%%%%%
        UnbalanceCarsSB_dt        % table with unbalance of cars per station at every hour (mean)
        UnbalanceCarsFF_dt        % table with unbalance of cars per zone at every hour (mean)
        UnbalanceCarsTotal_dt     % table with unbalance of cars per station+zone at every hour (mean)
        %
        UnbalanceCarsSB_AggT      % table with unbalance of cars per station aggregated by time (mean)
        UnbalanceCarsFF_AggT      % table with unbalance of cars per zone aggregated by time (mean)
        UnbalanceCarsTotal_AggT   % table with unbalance of cars per station+zone aggregated by time (mean)
        %
        UnbalanceCarsSB_AggR      % table with unbalance of cars per station aggregated by region (mean)
        UnbalanceCarsFF_AggR      % table with unbalance of cars per zone aggregated by region (mean)
        UnbalanceCarsTotal_AggR   % table with unbalance of cars per station+zone aggregated by region (mean)
        
        %%%%%%%%%%
        % DEMAND %
        %%%%%%%%%%
        DemandOrigZoneSB_dt       % table with demand at origin in the zone from stations at every hour (sum)
        DemandOrigZoneFF_dt       % table with demand at origin in the zone from zones at every hour (sum)
        DemandOrigZoneTotal_dt    % table with demand at origin in the zone from stations+zones at every hour (sum)
        %
        DemandOrigZoneSB_AggT     % table with demand at origin in the zone from stations aggregated by time (sum)
        DemandOrigZoneFF_AggT     % table with demand at origin in the zone from zones aggregated by time (sum)
        DemandOrigZoneTotal_AggT  % table with demand at origin in the zone from stations+zones aggregated by time (sum)
        %
        DemandOrigZoneSB_AggR     % table with demand at origin in the zone from stations aggregated by region (sum)
        DemandOrigZoneFF_AggR     % table with demand at origin in the zone from zones aggregated by region (sum)
        DemandOrigZoneTotal_AggR  % table with demand at origin in the zone from stations+zones aggregated by region (sum)
        %
        DemandDestZoneSB_dt       % table with demand at destination in the zone to stations at every hour (sum)
        DemandDestZoneFF_dt       % table with demand at destination in the zone to zones at every hour (sum)
        DemandDestZoneTotal_dt    % table with demand at destination in the zone to stations+zones at every hour (sum)
        %
        DemandDestZoneSB_AggT     % table with demand at destination in the zone from stations aggregated by time (sum)
        DemandDestZoneFF_AggT     % table with demand at destination in the zone from zones aggregated by time (sum)
        DemandDestZoneTotal_AggT  % table with demand at destination in the zone from stations+zones aggregated by time (sum)
        %
        DemandDestZoneSB_AggR     % table with demand at destination in the zone from stations aggregated by region (sum)
        DemandDestZoneFF_AggR     % table with demand at destination in the zone from zones aggregated by region (sum)
        DemandDestZoneTotal_AggR  % table with demand at destination in the zone from stations+zones aggregated by region (sum)
        %
        DemandUnbalanceZoneSB_dt       % table with demand unbalance in the zone from stations at every hour (sum)
        DemandUnbalanceZoneFF_dt       % table with demand unbalance in the zone from zones at every hour (sum)
        DemandUnbalanceZoneTotal_dt    % table with demand unbalance in the zone from stations+zones at every hour (sum)
        %
        DemandUnbalanceZoneSB_AggT     % table with demand unbalance in the zone from stations aggregated by time (sum)
        DemandUnbalanceZoneFF_AggT     % table with demand unbalance in the zone from zones aggregated by time (sum)
        DemandUnbalanceZoneTotal_AggT  % table with demand unbalance in the zone from stations+zones aggregated by time (sum)
        %
        DemandUnbalanceZoneSB_AggR     % table with demand unbalance in the zone from stations aggregated by region (sum)
        DemandUnbalanceZoneFF_AggR     % table with demand unbalance in the zone from zones aggregated by region (sum)
        DemandUnbalanceZoneTotal_AggR  % table with demand unbalance in the zone from stations+zones aggregated by region (sum)
        %
        LostTripsTotal_dt         % table with lost trips from stations+zones at every hour (sum)
        LostTripsTotal_AggT       % table with lost trips from stations+zones aggregated by time (sum)
        LostTripsTotal_AggR       % table with lost trips from stations+zones aggregated by region (sum)
        %
        AvgAccessZoneSB_dt        % table with average access distance in the zone from stations at every hour (mean)
        AvgAccessZoneFF_dt        % table with average access distance in the zone from zones at every hour (mean)
        AvgAccessZoneTotal_dt     % table with average access distance in the zone from stations+zones at every hour (mean)
        %
        AvgAccessZoneSB_AggT      % table with average access distance in the zone from stations aggregated by time (mean)
        AvgAccessZoneFF_AggT      % table with average access distance in the zone from zones aggregated by time (mean)
        AvgAccessZoneTotal_AggT   % table with average access distance in the zone from stations+zones aggregated by time (mean)
        %
        AvgAccessZoneSB_AggR      % table with average access distance in the zone from stations aggregated by region (mean)
        AvgAccessZoneFF_AggR      % table with average access distance in the zone from zones aggregated by region (mean)
        AvgAccessZoneTotal_AggR   % table with average access distance in the zone from stations+zones aggregated by region (mean)
        %
        AvgEgressZoneSB_dt        % table with average egress distance in the zone from stations at every hour (mean)
        AvgEgressZoneFF_dt        % table with average egress distance in the zone from zones at every hour (mean)
        AvgEgressZoneTotal_dt     % table with average egress distance in the zone from stations+zones at every hour (mean)
        %
        AvgEgressZoneSB_AggT      % table with average egress distance in the zone from stations aggregated by time (mean)
        AvgEgressZoneFF_AggT      % table with average egress distance in the zone from zones aggregated by time (mean)
        AvgEgressZoneTotal_AggT   % table with average egress distance in the zone from stations+zones aggregated by time (mean)
        %
        AvgEgressZoneSB_AggR      % table with average egress distance in the zone from stations aggregated by region (mean)
        AvgEgressZoneFF_AggR      % table with average egress distance in the zone from zones aggregated by region (mean)
        AvgEgressZoneTotal_AggR   % table with average egress distance in the zone from stations+zones aggregated by region (mean)
        %
        FareTripsSB_dt            % table with fare from trips from stations at every hour (sum)
        FareTripsFF_dt            % table with fare from trips from zones at every hour (sum)
        FareTripsTotal_dt         % table with fare from trips from stations+zones at every hour (sum)
        %
        FareTripsSB_AggT          % table with fare from trips from stations aggregated by time (sum)
        FareTripsFF_AggT          % table with fare from trips from zones aggregated by time (sum)
        FareTripsTotal_AggT       % table with fare from trips from stations+zones aggregated by time (sum)
        %
        FareTripsSB_AggR          % table with fare from trips from stations aggregated by region (sum)
        FareTripsFF_AggR          % table with fare from trips from zones aggregated by region (sum)
        FareTripsTotal_AggR       % table with fare from trips from stations+zones aggregated by region (sum)
        
        %%%%%%%%%%%%%%%%%
        % REPOSITIONING %
        %%%%%%%%%%%%%%%%%
        VehiclesLeftRechargingSB_dt        % table with vehicles left because of recharging from stations at every hour (sum)
        VehiclesLeftRechargingFF_dt        % table with vehicles left because of recharging from zones at every hour (sum)
        VehiclesLeftRechargingTotal_dt     % table with vehicles left because of recharging from stations+zones at every hour (sum)
        %
        VehiclesLeftRebalancingSB_dt       % table with vehicles left because of rebalancing from stations at every hour (sum)
        VehiclesLeftRebalancingFF_dt       % table with vehicles left because of rebalancing from zones at every hour (sum)
        VehiclesLeftRebalancingTotal_dt    % table with vehicles left because of rebalancing from stations+zones at every hour (sum)
        %
        VehiclesLeftBothSB_dt              % table with vehicles left because of both from stations at every hour (sum)
        VehiclesLeftBothFF_dt              % table with vehicles left because of both from zones at every hour (sum)
        VehiclesLeftBothTotal_dt           % table with vehicles left because of both from stations+zones at every hour (sum)
        %
        VehiclesTakenRechargingSB_dt       % table with vehicles taken because of recharging from stations at every hour (sum)
        VehiclesTakenRechargingFF_dt       % table with vehicles taken because of recharging from zones at every hour (sum)
        VehiclesTakenRechargingTotal_dt    % table with vehicles taken because of recharging from stations+zones at every hour (sum)
        %
        VehiclesTakenRebalancingSB_dt      % table with vehicles taken because of rebalancing from stations at every hour (sum)
        VehiclesTakenRebalancingFF_dt      % table with vehicles taken because of rebalancing from zones at every hour (sum)
        VehiclesTakenRebalancingTotal_dt   % table with vehicles taken because of rebalancing from stations+zones at every hour (sum)
        %
        VehiclesTakenBothSB_dt             % table with vehicles taken because of both from stations at every hour (sum)
        VehiclesTakenBothFF_dt             % table with vehicles taken because of both from zones at every hour (sum)
        VehiclesTakenBothTotal_dt          % table with vehicles taken because of both from stations+zones at every hour (sum)
        %
        VehiclesLeftRechargingSB_AggT      % table with vehicles left because of recharging from stations aggregated by time (sum)
        VehiclesLeftRechargingFF_AggT      % table with vehicles left because of recharging from zones aggregated by time (sum)
        VehiclesLeftRechargingTotal_AggT   % table with vehicles left because of recharging from stations+zones aggregated by time (sum)
        %
        VehiclesLeftRebalancingSB_AggT     % table with vehicles left because of rebalancing from stations aggregated by time (sum)
        VehiclesLeftRebalancingFF_AggT     % table with vehicles left because of rebalancing from zones aggregated by time (sum)
        VehiclesLeftRebalancingTotal_AggT  % table with vehicles left because of rebalancing from stations+zones aggregated by time (sum)
        %
        VehiclesLeftBothSB_AggT            % table with vehicles left because of both from stations aggregated by time (sum)
        VehiclesLeftBothFF_AggT            % table with vehicles left because of both from zones aggregated by time (sum)
        VehiclesLeftBothTotal_AggT         % table with vehicles left because of both from stations+zones aggregated by time (sum)
        %
        VehiclesTakenRechargingSB_AggT     % table with vehicles taken because of recharging from stations aggregated by time (sum)
        VehiclesTakenRechargingFF_AggT     % table with vehicles taken because of recharging from zones aggregated by time (sum)
        VehiclesTakenRechargingTotal_AggT  % table with vehicles taken because of recharging from stations+zones aggregated by time (sum)
        %
        VehiclesTakenRebalancingSB_AggT    % table with vehicles taken because of rebalancing from stations aggregated by time (sum)
        VehiclesTakenRebalancingFF_AggT    % table with vehicles taken because of rebalancing from zones aggregated by time (sum)
        VehiclesTakenRebalancingTotal_AggT % table with vehicles taken because of rebalancing from stations+zones aggregated by time (sum)
        %
        VehiclesTakenBothSB_AggT           % table with vehicles taken because of both from stations aggregated by time (sum)
        VehiclesTakenBothFF_AggT           % table with vehicles taken because of both from zones aggregated by time (sum)
        VehiclesTakenBothTotal_AggT        % table with vehicles taken because of both from stations+zones aggregated by time (sum)
        %
        VehiclesLeftRechargingSB_AggR      % table with vehicles left because of recharging from stations aggregated by region (sum)
        VehiclesLeftRechargingFF_AggR      % table with vehicles left because of recharging from zones aggregated by region (sum)
        VehiclesLeftRechargingTotal_AggR   % table with vehicles left because of recharging from stations+zones aggregated by region (sum)
        %
        VehiclesLeftRebalancingSB_AggR     % table with vehicles left because of rebalancing from stations aggregated by region (sum)
        VehiclesLeftRebalancingFF_AggR     % table with vehicles left because of rebalancing from zones aggregated by region (sum)
        VehiclesLeftRebalancingTotal_AggR  % table with vehicles left because of rebalancing from stations+zones aggregated by region (sum)
        %
        VehiclesLeftBothSB_AggR            % table with vehicles left because of both from stations aggregated by region (sum)
        VehiclesLeftBothFF_AggR            % table with vehicles left because of both from zones aggregated by region (sum)
        VehiclesLeftBothTotal_AggR         % table with vehicles left because of both from stations+zones aggregated by region (sum)
        %
        VehiclesTakenRechargingSB_AggR     % table with vehicles taken because of recharging from stations aggregated by region (sum)
        VehiclesTakenRechargingFF_AggR     % table with vehicles taken because of recharging from zones aggregated by region (sum)
        VehiclesTakenRechargingTotal_AggR  % table with vehicles taken because of recharging from stations+zones aggregated by region (sum)
        %
        VehiclesTakenRebalancingSB_AggR    % table with vehicles taken because of rebalancing from stations aggregated by region (sum)
        VehiclesTakenRebalancingFF_AggR    % table with vehicles taken because of rebalancing from zones aggregated by region (sum)
        VehiclesTakenRebalancingTotal_AggR % table with vehicles taken because of rebalancing from stations+zones aggregated by region (sum)
        %
        VehiclesTakenBothSB_AggR           % table with vehicles taken because of both from stations aggregated by region (sum)
        VehiclesTakenBothFF_AggR           % table with vehicles taken because of both from zones aggregated by region (sum)
        VehiclesTakenBothTotal_AggR        % table with vehicles taken because of both from stations+zones aggregated by region (sum)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % USER LEVEL OF SERVICE %
        %%%%%%%%%%%%%%%%%%%%%%%%%        
        DemandLostOrigZoneTotal_dt
        DemandLostDestZoneTotal_dt
        
        DemandLostOrigZoneTotal_AggT
        DemandLostDestZoneTotal_AggT
        
        DemandLostOrigZoneTotal_AggR
        DemandLostDestZoneTotal_AggR
        
        DestinationFullZoneTotal_dt
        DestinationFullZoneTotal_AggT
        DestinationFullZoneTotal_AggR
        
        AvgTripIncreaseZoneTotal_dt
        AvgTripIncreaseZoneTotal_AggT
        AvgTripIncreaseZoneTotal_AggR
        
        AvgDistIncreaseZoneTotal_dt
        AvgDistIncreaseZoneTotal_AggT
        AvgDistIncreaseZoneTotal_AggR
        
        %%%%%%%%%%%
        % SUMMARY %
        %%%%%%%%%%%
        Summary                            % table with summary results (aggregated by time and region)

    end
    
    methods
%% CONSTRUCTOR

        function obj = Output()  % constructor
            obj.datafile = '';
            obj.MyCity = City();
            %
            % VEHICLES
            %
            obj.CarsSB_dt = table;
            obj.CarsFF_dt = table;
            obj.CarsTotal_dt = table;
            obj.CarStatus_dt = table;
            %
            obj.CarsSB_AggT = table;
            obj.CarsFF_AggT = table;
            obj.CarsTotal_AggT = table;
            obj.CarStatus_AggT = table;
            %
            obj.CarsSB_AggR = table;
            obj.CarsFF_AggR = table;
            obj.CarsTotal_AggR = table;
            %
            % BATTERY LEVEL
            %
            obj.BatterySB_dt = table;
            obj.BatteryFF_dt = table;
            obj.BatteryTotal_dt = table;
            %
            obj.BatterySB_AggT = table;
            obj.BatteryFF_AggT = table;
            obj.BatteryTotal_AggT = table;
            %
            obj.BatterySB_AggR = table;
            obj.BatteryFF_AggR = table;
            obj.BatteryTotal_AggR = table;
            %
            % STATION OCCUPANCY
            %
            obj.EmptySlotsSB_dt = table;
            obj.OccupancySB_dt = table;
            %
            obj.EmptySlotsSB_AggT = table;
            obj.OccupancySB_AggT = table;
            %
            obj.EmptySlotsSB_AggR = table;
            obj.OccupancySB_AggR = table;
            %
            obj.EmptyChargersSB_dt = table;
            obj.OccupancyChargersSB_dt = table;
            %
            obj.EmptyChargersSB_AggT = table;
            obj.OccupancyChargersSB_AggT = table;
            %
            obj.EmptyChargersSB_AggR = table;
            obj.OccupancyChargersSB_AggR = table;
            %
            % UNBALANCE
            %
            obj.UnbalanceCarsSB_dt = table;
            obj.UnbalanceCarsFF_dt = table;
            obj.UnbalanceCarsTotal_dt = table;
            %
            obj.UnbalanceCarsSB_AggT = table;
            obj.UnbalanceCarsFF_AggT = table;
            obj.UnbalanceCarsTotal_AggT = table;
            %
            obj.UnbalanceCarsSB_AggR = table;
            obj.UnbalanceCarsFF_AggR = table;
            obj.UnbalanceCarsTotal_AggR = table;
            %
            % DEMAND
            %
            obj.DemandOrigZoneSB_dt = table;
            obj.DemandOrigZoneFF_dt = table;
            obj.DemandOrigZoneTotal_dt = table;
            %
            obj.DemandOrigZoneSB_AggT = table;
            obj.DemandOrigZoneFF_AggT = table;
            obj.DemandOrigZoneTotal_AggT = table;
            %
            obj.DemandOrigZoneSB_AggR = table;
            obj.DemandOrigZoneFF_AggR = table;
            obj.DemandOrigZoneTotal_AggR = table;
            %
            obj.DemandDestZoneSB_dt = table;
            obj.DemandDestZoneFF_dt = table;
            obj.DemandDestZoneTotal_dt = table;
            %
            obj.DemandDestZoneSB_AggT = table;
            obj.DemandDestZoneFF_AggT = table;
            obj.DemandDestZoneTotal_AggT = table;
            %
            obj.DemandDestZoneSB_AggR = table;
            obj.DemandDestZoneFF_AggR = table;
            obj.DemandDestZoneTotal_AggR = table;
            %
            obj.DemandUnbalanceZoneSB_dt = table;
            obj.DemandUnbalanceZoneFF_dt = table;
            obj.DemandUnbalanceZoneTotal_dt = table;
            %
            obj.DemandUnbalanceZoneSB_AggT = table;
            obj.DemandUnbalanceZoneFF_AggT = table;
            obj.DemandUnbalanceZoneTotal_AggT = table;
            %
            obj.DemandUnbalanceZoneSB_AggR = table;
            obj.DemandUnbalanceZoneFF_AggR = table;
            obj.DemandUnbalanceZoneTotal_AggR = table;
            %
            obj.LostTripsTotal_dt = table;
            obj.LostTripsTotal_AggT = table;
            obj.LostTripsTotal_AggR = table;
            %
            obj.AvgAccessZoneSB_dt = table;
            obj.AvgAccessZoneFF_dt = table;
            obj.AvgAccessZoneTotal_dt = table;
            %
            obj.AvgAccessZoneSB_AggT = table;
            obj.AvgAccessZoneFF_AggT = table;
            obj.AvgAccessZoneTotal_AggT = table;
            %
            obj.AvgAccessZoneSB_AggR = table;
            obj.AvgAccessZoneFF_AggR = table;
            obj.AvgAccessZoneTotal_AggR = table;
            %
            obj.AvgEgressZoneSB_dt = table;
            obj.AvgEgressZoneFF_dt = table;
            obj.AvgEgressZoneTotal_dt = table;
            %
            obj.AvgEgressZoneSB_AggT = table;
            obj.AvgEgressZoneFF_AggT = table;
            obj.AvgEgressZoneTotal_AggT = table;
            %
            obj.AvgEgressZoneSB_AggR = table;
            obj.AvgEgressZoneFF_AggR = table;
            obj.AvgEgressZoneTotal_AggR = table;
            %
            obj.FareTripsSB_dt = table;
            obj.FareTripsFF_dt = table;
            obj.FareTripsTotal_dt = table;
            %
            obj.FareTripsSB_AggT = table;
            obj.FareTripsFF_AggT = table;
            obj.FareTripsTotal_AggT = table;
            %
            obj.FareTripsSB_AggR = table;
            obj.FareTripsFF_AggR = table;
            obj.FareTripsTotal_AggR = table;
            %
            % REPOSITIONING
            %
            obj.VehiclesLeftRechargingSB_dt = table;
            obj.VehiclesLeftRechargingFF_dt = table;
            obj.VehiclesLeftRechargingTotal_dt = table;
            %
            obj.VehiclesLeftRebalancingSB_dt = table;
            obj.VehiclesLeftRebalancingFF_dt = table;
            obj.VehiclesLeftRebalancingTotal_dt = table;
            %
            obj.VehiclesLeftBothSB_dt = table;
            obj.VehiclesLeftBothFF_dt = table;
            obj.VehiclesLeftBothTotal_dt = table;
            %
            obj.VehiclesTakenRechargingSB_dt = table;
            obj.VehiclesTakenRechargingFF_dt = table;
            obj.VehiclesTakenRechargingTotal_dt = table;
            %
            obj.VehiclesTakenRebalancingSB_dt = table;
            obj.VehiclesTakenRebalancingFF_dt = table;
            obj.VehiclesTakenRebalancingTotal_dt = table;
            %
            obj.VehiclesTakenBothSB_dt = table;
            obj.VehiclesTakenBothFF_dt = table;
            obj.VehiclesTakenBothTotal_dt = table;
            %
            obj.VehiclesLeftRechargingSB_AggT = table;
            obj.VehiclesLeftRechargingFF_AggT = table;
            obj.VehiclesLeftRechargingTotal_AggT = table;
            %
            obj.VehiclesLeftRebalancingSB_AggT = table;
            obj.VehiclesLeftRebalancingFF_AggT = table;
            obj.VehiclesLeftRebalancingTotal_AggT = table;
            %
            obj.VehiclesLeftBothSB_AggT = table;
            obj.VehiclesLeftBothFF_AggT = table;
            obj.VehiclesLeftBothTotal_AggT = table;
            %
            obj.VehiclesTakenRechargingSB_AggT = table;
            obj.VehiclesTakenRechargingFF_AggT = table;
            obj.VehiclesTakenRechargingTotal_AggT = table;
            %
            obj.VehiclesTakenRebalancingSB_AggT = table;
            obj.VehiclesTakenRebalancingFF_AggT = table;
            obj.VehiclesTakenRebalancingTotal_AggT = table;
            %
            obj.VehiclesTakenBothSB_AggT = table;
            obj.VehiclesTakenBothFF_AggT = table;
            obj.VehiclesTakenBothTotal_AggT = table;
            %
            obj.VehiclesLeftRechargingSB_AggR = table;
            obj.VehiclesLeftRechargingFF_AggR = table;
            obj.VehiclesLeftRechargingTotal_AggR = table;
            %
            obj.VehiclesLeftRebalancingSB_AggR = table;
            obj.VehiclesLeftRebalancingFF_AggR = table;
            obj.VehiclesLeftRebalancingTotal_AggR = table;
            %
            obj.VehiclesLeftBothSB_AggR = table;
            obj.VehiclesLeftBothFF_AggR = table;
            obj.VehiclesLeftBothTotal_AggR = table;
            %
            obj.VehiclesTakenRechargingSB_AggR = table;
            obj.VehiclesTakenRechargingFF_AggR = table;
            obj.VehiclesTakenRechargingTotal_AggR = table;
            %
            obj.VehiclesTakenRebalancingSB_AggR = table;
            obj.VehiclesTakenRebalancingFF_AggR = table;
            obj.VehiclesTakenRebalancingTotal_AggR = table;
            %
            obj.VehiclesTakenBothSB_AggR = table;
            obj.VehiclesTakenBothFF_AggR = table;
            obj.VehiclesTakenBothTotal_AggR = table;
            %
            % USER LEVEL OF SERVICE
            %
            obj.DemandLostOrigZoneTotal_dt = table;
            obj.DemandLostDestZoneTotal_dt = table;
            %
            obj.DemandLostOrigZoneTotal_AggT = table;
            obj.DemandLostDestZoneTotal_AggT = table;
            %
            obj.DemandLostOrigZoneTotal_AggR = table;
            obj.DemandLostDestZoneTotal_AggR = table;
            %
            obj.DestinationFullZoneTotal_dt = table;
            obj.DestinationFullZoneTotal_AggT = table;
            obj.DestinationFullZoneTotal_AggR = table;
            %
            obj.AvgTripIncreaseZoneTotal_dt = table;
            obj.AvgTripIncreaseZoneTotal_AggT = table;
            obj.AvgTripIncreaseZoneTotal_AggR = table;
            %
            obj.AvgDistIncreaseZoneTotal_dt = table;
            obj.AvgDistIncreaseZoneTotal_AggT = table;
            obj.AvgDistIncreaseZoneTotal_AggR = table;
                        
            %
            % Summary
            obj.Summary = table;
            
        end
        
 %% INITIALIZATION FUNCTIONS
 
        % initializeOutput
        function initializeOutput(param, obj)
            % Function to initialize the Output object
            obj.datafile = param.ResFile;
            
            % Read datafile
            try
                load(obj.datafile);
                obj.MyCity = MyCity;
                clear MyCity
            catch
                error(['Error: File ' obj.datafile ' cannot be loaded']);
            end
        end
        
        % createResultsCategory
        function createResultsCategory(param, obj, mainDir)
            % Function to generate results (tables & plots) by category
            k = find(param.ResFile=='.');
            folder = [param.ResFile(1:k(end)-1) '_output'];
            % Create results folder
            [status, msg, msgID] = mkdir(mainDir,folder);
            if status == 0
                error('Error: Output folder could not be created');
            end
            
        %% SINGLE ELEMENT SELECTION (REMOVED OPTION) %%
            % Check for a particular hour, station or zone in output params
            % from excel
            
            % 2021/12/20: We decided to remove the option to choose time
            % and station/zone for results
            param.Time = 0;
            param.StationID = 0;
            param.ZoneID = 0;
            
            % SINGLE HOUR SELECTION
            TotalTime = size(obj.MyCity.vCars{1}.status,2);
            if param.Time > 0
                % Check that the user selected hour is consistent with
                % simulation results
                thi = param.Time;
                thf = thi;
                %
                if param.Time*60 > TotalTime
                    error(['The selected hour ' num2str(thi) ' is outside of the results file simulation']);
                end
            else
                thi = 1;
                thf = ceil(TotalTime/60);
            end
            
            % SINGLE STATION SELECTION
            if param.StationID > 0
                % Find station ID in list
                StationI = 0;
                while StationI == 0
                    for istat=1:obj.MyCity.numStations
                        if obj.MyCity.vStations{istat}.ID == param.StationID
                            StationI = istat;
                            break;
                        end
                    end
                    %
                    if StationI == 0
                        error(['Station ID ' num2str(param.StationID) ' can not be found']);
                    end
                end
                StationF = StationI;
            else
                StationI = 1;
                StationF = obj.MyCity.numStations;
            end
            
            % SINGLE ZONE SELECTION
            if param.ZoneID > 0
                % Find zone ID in list
                ZoneI = 0;
                while ZoneI == 0
                    for izone=1:obj.MyCity.numFreeFloatZones
                        if obj.MyCity.vFreeFloatZones{izone}.ID == param.ZoneID
                            ZoneI = izone;
                            break;
                        end
                    end
                    %
                    if ZoneI == 0
                        error(['Zone ID ' num2str(param.ZoneID) ' can not be found']);
                    end
                end
                ZoneF = ZoneI;
            else
                ZoneI = 1;
                ZoneF = obj.MyCity.numFreeFloatZones;
            end
            
%%          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Call each category module %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if param.Vehicles == 1
                obj.Summary = [obj.Summary; {'' '' ''}];
                obj.Summary = [obj.Summary; {'VEHICLES' '' ''}];
                outputVehicles(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj);
            end
            if param.BatteryLevel == 1
                obj.Summary = [obj.Summary; {'' '' ''}];
                obj.Summary = [obj.Summary; {'BATTERY LEVEL' '' ''}];
                outputBattery(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj);
            end
            if param.StationOccupancy == 1
                obj.Summary = [obj.Summary; {'' '' ''}];
                obj.Summary = [obj.Summary; {'STATION OCCUPANCY' '' ''}];
%                 outputStationOccupancy(param, folder, thi, thf, StationI, StationF, obj);
                outputStationOccupancy_2(param, folder, thi, thf, StationI, StationF, obj);
            end
            if param.Unbalance == 1
                obj.Summary = [obj.Summary; {'' '' ''}];
                obj.Summary = [obj.Summary; {'UNBALANCE' '' ''}];
                outputUnbalance(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj);
            end
            if param.Demand == 1
                obj.Summary = [obj.Summary; {'' '' ''}];
                obj.Summary = [obj.Summary; {'DEMAND' '' ''}];
                outputDemand(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj);
            end
            if param.Repositioning == 1
                obj.Summary = [obj.Summary; {'' '' ''}];
                obj.Summary = [obj.Summary; {'REPOSITIONING' '' ''}];
                outputRepositioning(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj);
            end
            if param.User_LOS == 1
                obj.Summary = [obj.Summary; {'' '' ''}];
                obj.Summary = [obj.Summary; {'USER LEVEL OF SERVICE' '' ''}];
                outputUserLOS(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj);
            end
            %
            obj.Summary = [obj.Summary; {'' '' ''}];
            obj.Summary = [obj.Summary; {'COSTS' '' ''}];
            outputCosts(param, obj);
            %
            % Rename column labels for Summary table
            allVars = 1:width(obj.Summary);
            newNames = {'PARAMETER','UNITS','VALUE'};
            obj.Summary = renamevars(obj.Summary, allVars, newNames);
            %
            % Generate excel sheet with Summary table
            xlsfile = [folder '/Table_summary.xlsx'];
            if isfile(xlsfile)
                delete(xlsfile);
            end
            sheet = 'Summary';
            writetable(obj.Summary, xlsfile, 'Sheet', sheet);
        end
        
        %% PLOT FUNCTIONS
        
        % plotTableStation
        function plotTableStation(tab_name, xlsfile, obj, titulo, unit_labl)
            % Function that plots table graphically by station
            
            % Get table by name
            tab = obj.(tab_name);
            cols = tab.Properties.VariableNames;
            cmap = colormap(flipud(bone));
           
            % Create folder to export jpg
            k = find(xlsfile=='/');
            folder = [xlsfile(1:k(end)) tab_name];
            % Find main directory
            mainDir = getExecutableFolder();
            % Create images folder
            [status, msg, msgID] = mkdir(mainDir,folder);
            if status == 0
                error('Error: Output folder could not be created');
            end
                
            % Get list of indexes depending on Station ID
            list_IDs = zeros(1,obj.MyCity.numStations);
            for i=1:obj.MyCity.numStations
                list_IDs(i) = obj.MyCity.vStations{i}.ID;
            end
            %
            ind = zeros(size(tab,1),1);
            for i=1:size(tab,1)
                ind(i) = find(tab.ID(i)==list_IDs);
            end
            
            % Loop over columns (do not consider ID & Name)
            for i=3:size(cols,2)
                aux = zeros(obj.MyCity.numStations,1);
                %
                % Get column values for every station in table
                for j=1:size(tab,1)
                    aux(ind(j)) = tab.(cols{i})(j);
                end
                %
%                 cmin = min(aux);
%                 cmax = max(aux);
                cmin = 0;
                cmax = 100;
                m = length(cmap);
                %
                % Generate figure
                figure('Visible','off');
                mapshow(obj.MyCity.servArea, 'FaceColor', 'none')
                set(gca,'fontname','times')
                colormap(flipud(bone))
                hold on;
                %
                for j=1:obj.MyCity.numStations
                    index = fix((aux(j)-cmin)/(cmax-cmin)*m)+1;
                    RGB = cmap(min(index,m),:);
                    %
                    scatter(obj.MyCity.vStations{ind(j)}.X, obj.MyCity.vStations{ind(j)}.Y, 30, RGB, 'filled','markeredgecolor','black');
%                     ax.scatter(edgecolors='black');
                    hold on;
                end
                % Set colormap
%                 colormap jet;
                h = colorbar('Ticks',[0, 0.5 ,1], 'TickLabels', ...
                    {num2str(cmin,'%.2f'), num2str((cmax+cmin)/2,'%.2f'), num2str(cmax,'%.2f')});
                ylabel(h, unit_labl,'fontname','times', 'FontSize', 14);
                %set(c, 'Ylim', [cmin cmax]);
                
                % Title
                title(titulo, 'Interpreter','none','fontname','times', 'FontSize', 16);
                %subtitle(['Table: ' tab_name ' - ' cols{i}], 'Interpreter','none');
                subtitle('Scenario 1 (Real-time pairwise assignment)', 'Interpreter','none','fontname','times');
                xlabel('X UTM Coordinate [m]','fontname','times', 'FontSize', 14)
                ylabel('Y UTM Coordinate [m]','fontname','times', 'FontSize', 14)
                
                % Print figure to jpg file
                filename = [folder '/' tab_name '_' cols{i} '.jpg'];
                saveas(gcf,filename);
                close(gcf);
            end
            
        end
            
        % plotTableZone
        function plotTableZone(tab_name, xlsfile, obj, titulo, unit_labl)
            % Function that plots table graphically by zone
            
            % Get table by name
            tab = obj.(tab_name);
            cols = tab.Properties.VariableNames;
            cmap = jet;
            
            % Create folder to export jpg
            k = find(xlsfile=='/');
            folder = [xlsfile(1:k(end)) tab_name];
            % Find main directory
            mainDir = getExecutableFolder();
            % Create images folder
            [status, msg, msgID] = mkdir(mainDir,folder);
            if status == 0
                error('Error: Output folder could not be created');
            end
                
            % Get list of indexes depending on zone ID
            ind = zeros(size(tab,1),1);
            for i=1:size(tab,1)
                ind(i) = find(tab.ID(i)==obj.MyCity.zoneNum);
            end
            
            % Loop over columns (do not consider ID)
            for i=2:size(cols,2)
                aux = zeros(obj.MyCity.numFreeFloatZones,1);
                %
                % Get column values for every zone in table
                for j=1:size(tab,1)
                    aux(ind(j)) = tab.(cols{i})(j);
                end
                %
                cmin = min(aux);
                cmax = max(aux);
                m = length(cmap);
                %
                % Generate figure
                figure('Visible','off');
                for j=1:obj.MyCity.numFreeFloatZones
                    index = fix((aux(j)-cmin)/(cmax-cmin)*m)+1;
                    RGB = cmap(min(index,m),:);
                    %
                    mapshow(obj.MyCity.servArea(j), 'FaceColor', RGB);
                    hold on;
                end
                % Set colormap
                colormap jet
                h = colorbar('Ticks',[0, 0.5 ,1], 'TickLabels', ...
                    {num2str(cmin,'%.2f'), num2str((cmax+cmin)/2,'%.2f'), num2str(cmax,'%.2f')});
                ylabel(h, unit_labl, 'FontSize', 16)
                %set(c, 'Ylim', [cmin cmax]);
                
                % Title
                title(titulo, 'Interpreter','none', 'FontSize', 16);
                subtitle(['Table: ' tab_name ' - ' cols{i}], 'Interpreter','none');
                xlabel('X UTM Coordinate [m]', 'FontSize', 16)
                ylabel('Y UTM Coordinate [m]', 'FontSize', 16)
                
                % Print figure to jpg file
                filename = [folder '/' tab_name '_' cols{i} '.jpg'];
                saveas(gcf,filename);
                close(gcf);
            end
        end
        
        % plotPieChart
        function plotPieChart(tab_name, xlsfile, obj, titulo)
            % Function that plots table graphically by pie chart
            
            % Get table by name
            tab = obj.(tab_name);
            cols = tab.Properties.VariableNames;
            
            % Create folder to export jpg
            k = find(xlsfile=='/');
            folder = [xlsfile(1:k(end)) tab_name];
            % Find main directory
            mainDir = getExecutableFolder();
            % Create images folder
            [status, msg, msgID] = mkdir(mainDir,folder);
            if status == 0
                error('Error: Output folder could not be created');
            end
                
            % Loop over columns (do not consider Status)
            for i=2:size(cols,2)
                aux = zeros(5,1);
                %
                % Get column values for every status in table
                for j=1:size(tab,1)
                    aux(j) = tab.(cols{i})(j);
                end
                %
                % Generate figure
                figure('Visible','off');
                til = tiledlayout('flow','TileSpacing','compact');
                % Chart
                nexttile;
                h = pie(aux);
                % Hide <1% labels
                th = findobj(h,'Type','Text'); % text handles
                % Determine which text strings begin with "<"
                isSmall = startsWith({th.String}, '<');  % r2016b or later
                % Replace their String values with empties.
                set(th(isSmall),'String', '')
                %
                % Legend
                lgd = legend(tab.Status);
                lgd.Layout.Tile = 2;
                % Title
                title(til, titulo, 'Interpreter','none');
                subtitle(til, ['Table: ' tab_name ' - ' cols{i}], 'Interpreter','none');
                % Print figure to jpg file
                filename = [folder '/' tab_name '_' cols{i} '.jpg'];
                saveas(gcf,filename);
                close(gcf);
            end
        end
        
        % plotTableTime
        function plotTableTime(tab_name, xlsfile, obj, titulo, eje_y)
            % Function that plots table graphically by time series
            
            % Get table by name
            tab = obj.(tab_name);
            cols = tab.Properties.VariableNames;
            
            % Create folder to export jpg
            k = find(xlsfile=='/');
            folder = [xlsfile(1:k(end)) tab_name];
            % Find main directory
            mainDir = getExecutableFolder();
            % Create images folder
            [status, msg, msgID] = mkdir(mainDir,folder);
            if status == 0
                error('Error: Output folder could not be created');
            end
                
            % Plot time series
            % Get column values for every status in table
            x = []; aux = [];
            for j=1:size(tab,1)
                x(j) = j;
                aux(j) = tab.(cols{2})(j);
            end
            %
            % Generate figure
            figure('Visible','off');
            plot(x,aux);
%             xlim([x(1) x(end)]);
            xlim([x(1) x(24)]);
            ylim([0, 800]);
            even_chk = (x(end)-x(1))/2;
%             xticks([x(24),x(48),x(end)])
            if floor(even_chk)==even_chk
                xticks([x(1):2:x(end)])
            end
            xlabel('Simulation time [hour]','fontname','times', 'FontSize', 14);

            % Title
%             title(titulo, 'Interpreter','none');
%             subtitle(['Table: ' tab_name], 'Interpreter','none');
            title(titulo, 'Interpreter','none','fontname','times', 'FontSize', 16);
            subtitle('(Bike-sharing, no rebalancing)', 'Interpreter','none','fontname','times');
            ylabel(eje_y,'fontname','times', 'FontSize', 14);

            % Print figure to jpg file
            filename = [folder '/' tab_name '.jpg'];
            saveas(gcf,filename);
            close(gcf);                        
        end
       
    end
end









