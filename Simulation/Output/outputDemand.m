function outputDemand(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj)
    % Function to generate results (tables & plots) about demand
    
    if param.verbose
        disp('');
        disp('CREATING DEMAND TABLES');
    end
    
    % Create Vehicles folder
    [status, msg, msgID] = mkdir([pwd '/' folder],'Demand');
    if status == 0
        error('Error: Output folder could not be created');
    end
    
    xlsfile = [folder '/Demand/Tables_demand.xlsx'];
    if isfile(xlsfile)
        delete(xlsfile);
    end

    %%%%%%%%%%%%%%%%%%%%%%
    %    HOURLY TABLES   % 
    %%%%%%%%%%%%%%%%%%%%%%
    if param.Hourly
        
        % DemandInStationTime
        if param.verbose
            disp('Creating table DemandInStationTime');
        end
        %
        sheet1 = 'DemandOrigInStationTime';
        sheet2 = 'DemandDestInStationTime';
        sheet3 = 'DemandUnbalanceInStationTime';
        tableDemandInStationTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, StationI, StationF, obj);

        % DemandInZoneTime
        if param.verbose
            disp('Creating table DemandInZoneTime');
        end
        %
        sheet1 = 'DemandOrigInZoneTime';
        sheet2 = 'DemandDestInZoneTime';
        sheet3 = 'DemandUnbalanceInZoneTime';
        tableDemandInZoneTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, ZoneI, ZoneF, obj);

        % DemandInTotalTime
        if param.verbose
            disp('Creating table DemandInTotalTime');
        end
        %
        sheet1 = 'DemandOrigInTotalTime';
        sheet2 = 'DemandDestInTotalTime';
        sheet3 = 'DemandUnbalanceInTotalTime';
        tableDemandInTotalTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, ZoneI, ZoneF, obj);

        % LostTripsInTotalTime
        if param.verbose
            disp('Creating table LostTripsInTotalTime');
        end
        %
        sheet = 'LostTripsInTotalTime';
        tableLostTripsInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % AvgAccessInStationTime
        if param.verbose
            disp('Creating table AvgAccessInStationTime');
        end
        %
        sheet = 'AvgAccessInStationTime';
        tableAvgAccessInStationTime(param, xlsfile, sheet, thi, thf, StationI, StationF, obj);

        % AvgAccessInZoneTime
        if param.verbose
            disp('Creating table AvgAccessInZoneTime');
        end
        %
        sheet = 'AvgAccessInZoneTime';
        tableAvgAccessInZoneTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % AvgAccessInTotalTime
        if param.verbose
            disp('Creating table AvgAccessInTotalTime');
        end
        %
        sheet = 'AvgAccessInTotalTime';
        tableAvgAccessInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % AvgEgressInStationTime
        if param.verbose
            disp('Creating table AvgEgressInStationTime');
        end
        %
        sheet = 'AvgEgressInStationTime';
        tableAvgEgressInStationTime(param, xlsfile, sheet, thi, thf, StationI, StationF, obj);

        % AvgEgressInZoneTime
        if param.verbose
            disp('Creating table AvgEgressInZoneTime');
        end
        %
        sheet = 'AvgEgressInZoneTime';
        tableAvgEgressInZoneTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % AvgEgressInTotalTime
        if param.verbose
            disp('Creating table AvgEgressInTotalTime');
        end
        %
        sheet = 'AvgEgressInTotalTime';
        tableAvgEgressInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % FareTripsInStationTime
        if param.verbose
            disp('Creating table FareTripsInStationTime');
        end
        %
        sheet = 'FareTripsInStationTime';
        tableFareTripsInStationTime(param, xlsfile, sheet, thi, thf, StationI, StationF, obj);

        % FareTripsInZoneTime
        if param.verbose
            disp('Creating table FareTripsInZoneTime');
        end
        %
        sheet = 'FareTripsInZoneTime';
        tableFareTripsInZoneTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % FareTripsInTotalTime
        if param.verbose
            disp('Creating table FareTripsInTotalTime');
        end
        %
        sheet = 'FareTripsInTotalTime';
        tableFareTripsInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %    TIME AGGREGATION   % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggT
        
        % DemandInStationAggT
%         if param.verbose
%             disp('Creating table DemandInStationAggT');
%         end
%         %
%         sheet1 = 'DemandOrigInStationAggT';
%         sheet2 = 'DemandDestInStationAggT';
%         sheet3 = 'DemandUnbalanceInStationAggT';
%         tableDemandInStationAggT(param, xlsfile, sheet1, sheet2, sheet3, StationI, StationF, obj);
% 
%         % DemandInZoneAggT
%         if param.verbose
%             disp('Creating table DemandInZoneAggT');
%         end
%         %
%         sheet1 = 'DemandOrigInZoneAggT';
%         sheet2 = 'DemandDestInZoneAggT';
%         sheet3 = 'DemandUnbalanceInZoneAggT';
%         tableDemandInZoneAggT(param, xlsfile, sheet1, sheet2, sheet3, ZoneI, ZoneF, obj);

%         % DemandInTotalAggT
%         if param.verbose
%             disp('Creating table DemandInTotalAggT');
%         end
%         %
%         sheet1 = 'DemandOrigInTotalAggT';
%         sheet2 = 'DemandDestInTotalAggT';
%         sheet3 = 'DemandUnbalanceInTotalAggT';
%         tableDemandInTotalAggT(param, xlsfile, sheet1, sheet2, sheet3, ZoneI, ZoneF, obj);
% 
%         % LostTripsInTotalAggT
%         if param.verbose
%             disp('Creating table LostTripsInTotalAggT');
%         end
%         %
%         sheet = 'LostTripsInTotalAggT';
%         tableLostTripsInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
% 
%         % AvgAccessInStationAggT
%         if param.verbose
%             disp('Creating table AvgAccessInStationAggT');
%         end
%         %
%         sheet = 'AvgAccessInStationAggT';
%         tableAvgAccessInStationAggT(param, xlsfile, sheet, StationI, StationF, obj);

        % AvgAccessInZoneAggT
%         if param.verbose
%             disp('Creating table AvgAccessInZoneAggT');
%         end
%         %
%         sheet = 'AvgAccessInZoneAggT';
%         tableAvgAccessInZoneAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
% 
%         % AvgAccessInTotalAggT
%         if param.verbose
%             disp('Creating table AvgAccessInTotalAggT');
%         end
%         %
%         sheet = 'AvgAccessInTotalAggT';
%         tableAvgAccessInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
% 
%         % AvgEgressInStationAggT
%         if param.verbose
%             disp('Creating table AvgEgressInStationAggT');
%         end
%         %
%         sheet = 'AvgEgressInStationAggT';
%         tableAvgEgressInStationAggT(param, xlsfile, sheet, StationI, StationF, obj);
% 
%         % AvgEgressInZoneAggT
%         if param.verbose
%             disp('Creating table AvgEgressInZoneAggT');
%         end
%         %
%         sheet = 'AvgEgressInZoneAggT';
%         tableAvgEgressInZoneAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
% 
%         % AvgEgressInTotalAggT
%         if param.verbose
%             disp('Creating table AvgEgressInTotalAggT');
%         end
%         %
%         sheet = 'AvgEgressInTotalAggT';
%         tableAvgEgressInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
% 
%         % FareTripsInStationAggT
%         if param.verbose
%             disp('Creating table FareTripsInStationAggT');
%         end
%         %
%         sheet = 'FareTripsInStationAggT';
%         tableFareTripsInStationAggT(param, xlsfile, sheet, StationI, StationF, obj);
% 
%         % FareTripsInZoneAggT
%         if param.verbose
%             disp('Creating table FareTripsInZoneAggT');
%         end
%         %
%         sheet = 'FareTripsInZoneAggT';
%         tableFareTripsInZoneAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
% 
%         % FareTripsInTotalAggT
%         if param.verbose
%             disp('Creating table FareTripsInTotalAggT');
%         end
%         %
%         sheet = 'FareTripsInTotalAggT';
%         tableFareTripsInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %   REGION AGGREGATION  % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggR
        
        % DemandInStationAggR
%         if param.verbose
%             disp('Creating table DemandInStationAggR');
%         end
%         %
%         sheet1 = 'DemandOrigInStationAggR';
%         sheet2 = 'DemandDestInStationAggR';
%         sheet3 = 'DemandUnbalanceInStationAggR';
%         tableDemandInStationAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj);
% 
%         % DemandInZoneAggR
%         if param.verbose
%             disp('Creating table DemandInZoneAggR');
%         end
%         %
%         sheet1 = 'DemandOrigInZoneAggR';
%         sheet2 = 'DemandDestInZoneAggR';
%         sheet3 = 'DemandUnbalanceInZoneAggR';
%         tableDemandInZoneAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj);

        % DemandInTotalAggR
%         if param.verbose
%             disp('Creating table DemandInTotalAggR');
%         end
%         %
%         sheet1 = 'DemandOrigInTotalAggR';
%         sheet2 = 'DemandDestInTotalAggR';
%         sheet3 = 'DemandUnbalanceInTotalAggR';
%         tableDemandInTotalAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj);

        % LostTripsInTotalAggR
        if param.verbose
            disp('Creating table LostTripsInTotalAggR');
        end
        %
        sheet = 'LostTripsInTotalAggR';
        tableLostTripsInTotalAggR(param, xlsfile, sheet, thi, thf, obj);

%         % AvgAccessInStationAggR
%         if param.verbose
%             disp('Creating table AvgAccessInStationAggR');
%         end
%         %
%         sheet = 'AvgAccessInStationAggR';
%         tableAvgAccessInStationAggR(param, xlsfile, sheet, thi, thf, obj);
% 
%         % AvgAccessInZoneAggR
%         if param.verbose
%             disp('Creating table AvgAccessInZoneAggR');
%         end
%         %
%         sheet = 'AvgAccessInZoneAggR';
%         tableAvgAccessInZoneAggR(param, xlsfile, sheet, thi, thf, obj);
% 
%         % AvgAccessInTotalAggR
%         if param.verbose
%             disp('Creating table AvgAccessInTotalAggR');
%         end
%         %
%         sheet = 'AvgAccessInTotalAggR';
%         tableAvgAccessInTotalAggR(param, xlsfile, sheet, thi, thf, obj);
% 
%         % AvgEgressInStationAggR
%         if param.verbose
%             disp('Creating table AvgEgressInStationAggR');
%         end
%         %
%         sheet = 'AvgEgressInStationAggR';
%         tableAvgEgressInStationAggR(param, xlsfile, sheet, thi, thf, obj);
% 
%         % AvgEgressInZoneAggR
%         if param.verbose
%             disp('Creating table AvgEgressInZoneAggR');
%         end
%         %
%         sheet = 'AvgEgressInZoneAggR';
%         tableAvgEgressInZoneAggR(param, xlsfile, sheet, thi, thf, obj);
% 
%         % AvgEgressInTotalAggR
%         if param.verbose
%             disp('Creating table AvgEgressInTotalAggR');
%         end
%         %
%         sheet = 'AvgEgressInTotalAggR';
%         tableAvgEgressInTotalAggR(param, xlsfile, sheet, thi, thf, obj);
% 
%         % FareTripsInStationAggR
%         if param.verbose
%             disp('Creating table FareTripsInStationAggR');
%         end
%         %
%         sheet = 'FareTripsInStationAggR';
%         tableFareTripsInStationAggR(param, xlsfile, sheet, thi, thf, obj);
% 
%         % FareTripsInZoneAggR
%         if param.verbose
%             disp('Creating table FareTripsInZoneAggR');
%         end
%         %
%         sheet = 'FareTripsInZoneAggR';
%         tableFareTripsInZoneAggR(param, xlsfile, sheet, thi, thf, obj);
% 
%         % FareTripsInTotalAggR
%         if param.verbose
%             disp('Creating table FareTripsInTotalAggR');
%         end
%         %
%         sheet = 'FareTripsInTotalAggR';
%         tableFareTripsInTotalAggR(param, xlsfile, sheet, thi, thf, obj);
    end

    %%%%%%%%%%%%%
    %  SUMMARY  %
    %%%%%%%%%%%%%
    
    % DemandInStationSumm
    if param.verbose
        disp('Creating table DemandInStationSumm');
    end
    %
    tableDemandInStationSumm(obj);

    % DemandInZoneSumm
    if param.verbose
        disp('Creating table DemandInZoneSumm');
    end
    %
    tableDemandInZoneSumm(obj);

    % DemandInTotalSumm
    if param.verbose
        disp('Creating table DemandInTotalSumm');
    end
    %
    tableDemandInTotalSumm(obj);

    % LostTripsInTotalSumm
    if param.verbose
        disp('Creating table LostTripsInTotalSumm');
    end
    %
    tableLostTripsInTotalSumm(obj);

    % AvgAccessInStationSumm
    if param.verbose
        disp('Creating table AvgAccessInStationSumm');
    end
    %
    tableAvgAccessInStationSumm(param, obj);

    % AvgAccessInZoneSumm
    if param.verbose
        disp('Creating table AvgAccessInZoneSumm');
    end
    %
    tableAvgAccessInZoneSumm(param, obj);

    % AvgAccessInTotalSumm
    if param.verbose
        disp('Creating table AvgAccessInTotalSumm');
    end
    %
    tableAvgAccessInTotalSumm(param, obj);

    % AvgEgressInStationSumm
    if param.verbose
        disp('Creating table AvgEgressInStationSumm');
    end
    %
    tableAvgEgressInStationSumm(param, obj);

    % AvgEgressInZoneSumm
    if param.verbose
        disp('Creating table AvgEgressInZoneSumm');
    end
    %
    tableAvgEgressInZoneSumm(param, obj);

    % AvgEgressInTotalSumm
    if param.verbose
        disp('Creating table AvgEgressInTotalSumm');
    end
    %
    tableAvgEgressInTotalSumm(param, obj);
    
    %%% Aggregation of revenue is moved to outputCosts.m
%     % FareTripsInStationSumm
%     if param.verbose
%         disp('Creating table FareTripsInStationSumm');
%     end
%     %
%     tableFareTripsInStationSumm(param, obj);
% 
%     % FareTripsInZoneSumm
%     if param.verbose
%         disp('Creating table FareTripsInZoneSumm');
%     end
%     %
%     tableFareTripsInZoneSumm(param, obj);
% 
%     % FareTripsInTotalSumm
%     if param.verbose
%         disp('Creating table FareTripsInTotalSumm');
%     end
%     %
%     tableFareTripsInTotalSumm(param, obj);

    % AvgTripsInTotalSumm
    if param.verbose
        disp('Creating table AvgTripsInTotalSumm');
    end
    %
    tableAvgTripsInTotalSumm(param, obj);
    
    % AvgReservedTimeSumm
    if param.verbose
        disp('Creating table AvgReservedTimeSumm');
    end
    %
    tableAvgReservedTimeSumm(obj);

end

% tableDemandInStationTime
function tableDemandInStationTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, statI, statF, obj)
    % Function to create tables with origin/destination demand
    % from/to stations in every zone at every hour (sum)

    % Generate first 2 columns with labels
    ID = []; Name = {};
    for istat=statI:statF
        ID(end+1,1) = obj.MyCity.vStations{istat}.ID;
        try
            Name(end+1,1) = obj.MyCity.vStations{istat}.Name;
        catch
            Name(end+1,1) = {''};
        end
    end
    %
    obj.DemandOrigZoneSB_dt = table(ID, Name);
    obj.DemandDestZoneSB_dt = table(ID, Name);
    obj.DemandUnbalanceZoneSB_dt = table(ID, Name);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = statI:statF;
    Orig = zeros(statF-statI+1, TotalTime);
    Dest = zeros(statF-statI+1, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
            StatO = obj.MyCity.vFinishedUsers{iusr}.StatO;
            k = find(list_zone==StatO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user takes the car
                if tO2Car > 0
                    Orig(k,tO2Car) = Orig(k,tO2Car) + 1;
                end
            end
        end
        %
        if obj.MyCity.vFinishedUsers{iusr}.StatD > 0               % Destination at station StatD
            StatD = obj.MyCity.vFinishedUsers{iusr}.StatD;
            k = find(list_zone==StatD);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
                tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when the user parks the car
                if tTrip > 0
                    Dest(k,tTrip) = Dest(k,tTrip) + 1;
                end
            end
        end
    end
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux1 = sum(Orig(:,ti:tf),2);
        aux2 = sum(Dest(:,ti:tf),2);

        % Add column to table
        obj.DemandOrigZoneSB_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux1;
        obj.DemandDestZoneSB_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
        obj.DemandUnbalanceZoneSB_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux1-aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandOrigZoneSB_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandDestZoneSB_dt, xlsfile, 'Sheet', sheet2);
    writetable(obj.DemandUnbalanceZoneSB_dt, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        unit_labl = '[trips]';
        titulo = 'Trips starting in station (SB) per hour';
        plotTableStation('DemandOrigZoneSB_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Trips finishing in station (SB) per hour';
        plotTableStation('DemandDestZoneSB_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Unbalance of trips in the Station-Based system (SB) per hour';
        unit_labl = 'Difference between trips finishing and starting [trips]';
        plotTableStation('DemandUnbalanceZoneSB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDemandInZoneTime
function tableDemandInZoneTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, zoneI, zoneF, obj)
    % Function to create tables with origin/destination demand
    % from/to zones in every zone at every hour (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.DemandOrigZoneFF_dt = table(ID);
    obj.DemandDestZoneFF_dt = table(ID);
    obj.DemandUnbalanceZoneFF_dt = table(ID);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    Orig = zeros(zoneF-zoneI+1, TotalTime);
    Dest = zeros(zoneF-zoneI+1, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at FF
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            k = find(list_zone==CarZoneO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user takes the car
                if tO2Car > 0
                    Orig(k,tO2Car) = Orig(k,tO2Car) + 1;
                end
            end
        end
        %
        if obj.MyCity.vFinishedUsers{iusr}.StatD == 0              % Destination at FF
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            k = find(list_zone==CarZoneD);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
                tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when the user parks the car
                if tTrip > 0
                    Dest(k,tTrip) = Dest(k,tTrip) + 1;
                end
            end
        end
    end
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux1 = sum(Orig(:,ti:tf),2);
        aux2 = sum(Dest(:,ti:tf),2);

        % Add column to table
        obj.DemandOrigZoneFF_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux1;
        obj.DemandDestZoneFF_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
        obj.DemandUnbalanceZoneFF_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux1-aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandOrigZoneFF_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandDestZoneFF_dt, xlsfile, 'Sheet', sheet2);
    writetable(obj.DemandUnbalanceZoneFF_dt, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by zones
    if param.GeneratePlots
        unit_labl = '[trips]';
        titulo = 'Trips starting on-street (FF) per hour';    
        plotTableZone('DemandOrigZoneFF_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Trips finishing on-street (FF) per hour';
        plotTableZone('DemandDestZoneFF_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Unbalance of trips in the Free-Floating system (FF) per hour';
        unit_labl = 'Difference between trips finishing and starting [trips]';
        plotTableZone('DemandUnbalanceZoneFF_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDemandInTotalTime
function tableDemandInTotalTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, zoneI, zoneF, obj)
    % Function to create tables with origin/destination demand
    % from/to station+zones in every zone at every hour (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.DemandOrigZoneTotal_dt = table(ID);
    obj.DemandDestZoneTotal_dt = table(ID);
    obj.DemandUnbalanceZoneTotal_dt = table(ID);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    Orig = zeros(zoneF-zoneI+1, TotalTime);
    Dest = zeros(zoneF-zoneI+1, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
        k = find(list_zone==CarZoneO);
        if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user takes the car
            if tO2Car > 0
                Orig(k,tO2Car) = Orig(k,tO2Car) + 1;
            end
        end
        %
        CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
        k = find(list_zone==CarZoneD);
        if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when the user parks the car
            if tTrip > 0
                Dest(k,tTrip) = Dest(k,tTrip) + 1;
            end
        end
    end
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux1 = sum(Orig(:,ti:tf),2);
        aux2 = sum(Dest(:,ti:tf),2);

        % Add column to table
        obj.DemandOrigZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux1;
        obj.DemandDestZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
        obj.DemandUnbalanceZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux1-aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandOrigZoneTotal_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandDestZoneTotal_dt, xlsfile, 'Sheet', sheet2);
    writetable(obj.DemandUnbalanceZoneTotal_dt, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by zones
    if param.GeneratePlots
        unit_labl = '[trips]';
        titulo = 'Total trips starting per zone and hour (SB+FF)';
        plotTableZone('DemandOrigZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total trips finishing per zone and hour (SB+FF)';
        plotTableZone('DemandDestZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total unbalance of trips per zone and hour (SB+FF)';
        unit_labl = 'Difference between trips finishing and starting [trips]';
        plotTableZone('DemandUnbalanceZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDemandInStationAggT
function tableDemandInStationAggT(param, xlsfile, sheet1, sheet2, sheet3, statI, statF, obj)
    % Function to create tables with origin/destination demand
    % from/to stations in every zone aggregated by time (sum)

    % Generate first 2 columns with labels
    ID = []; Name = {};
    for istat=statI:statF
        ID(end+1,1) = obj.MyCity.vStations{istat}.ID;
        try
            Name(end+1,1) = obj.MyCity.vStations{istat}.Name;
        catch
            Name(end+1,1) = {''};
        end
    end
    %
    obj.DemandOrigZoneSB_AggT = table(ID, Name);
    obj.DemandDestZoneSB_AggT = table(ID, Name);
    obj.DemandUnbalanceZoneSB_AggT = table(ID, Name);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = statI:statF;
    Orig = zeros(statF-statI+1, TotalTime);
    Dest = zeros(statF-statI+1, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
            StatO = obj.MyCity.vFinishedUsers{iusr}.StatO;
            k = find(list_zone==StatO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user takes the car
                if tO2Car > 0 
                    Orig(k,tO2Car) = Orig(k,tO2Car) + 1;
                end
            end
        end
        %
        if obj.MyCity.vFinishedUsers{iusr}.StatD > 0               % Destination at station StatD
            StatD = obj.MyCity.vFinishedUsers{iusr}.StatD;
            k = find(list_zone==StatD);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
                tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when the user parks the car
                if tTrip > 0
                    Dest(k,tTrip) = Dest(k,tTrip) + 1;
                end
            end
        end
    end
    %
    % Add column to table
    obj.DemandOrigZoneSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = sum(Orig,2);
    obj.DemandDestZoneSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = sum(Dest,2);
    obj.DemandUnbalanceZoneSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = sum(Orig,2)-sum(Dest,2);
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandOrigZoneSB_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandDestZoneSB_AggT, xlsfile, 'Sheet', sheet2);
    writetable(obj.DemandUnbalanceZoneSB_AggT, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        unit_labl = '[trips]';
        titulo = 'Total trips starting in station (SB)';
        plotTableStation('DemandOrigZoneSB_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total trips finishing in station (SB)';
        plotTableStation('DemandDestZoneSB_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Unbalance of trips in the Station-Based system (SB)';
        unit_labl = 'Difference between trips finishing and starting [trips]';
        plotTableStation('DemandUnbalanceZoneSB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDemandInZoneAggT
function tableDemandInZoneAggT(param, xlsfile, sheet1, sheet2, sheet3, zoneI, zoneF, obj)
    % Function to create tables with origin/destination demand
    % from/to zones in every zone aggregated by time (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.DemandOrigZoneFF_AggT = table(ID);
    obj.DemandDestZoneFF_AggT = table(ID);
    obj.DemandUnbalanceZoneFF_AggT = table(ID);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    Orig = zeros(zoneF-zoneI+1, TotalTime);
    Dest = zeros(zoneF-zoneI+1, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at FF
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            k = find(list_zone==CarZoneO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user takes the car
                if tO2Car > 0
                    Orig(k,tO2Car) = Orig(k,tO2Car) + 1;
                end
            end
        end
        %
        if obj.MyCity.vFinishedUsers{iusr}.StatD == 0              % Destination at FF
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            k = find(list_zone==CarZoneD);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
                tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when the user parks the car
                if tTrip > 0
                    Dest(k,tTrip) = Dest(k,tTrip) + 1;
                end
            end
        end
    end
    %
    % Add column to table
    obj.DemandOrigZoneFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = sum(Orig,2);
    obj.DemandDestZoneFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = sum(Dest,2);
    obj.DemandUnbalanceZoneFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = sum(Orig,2)-sum(Dest,2);
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandOrigZoneFF_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandDestZoneFF_AggT, xlsfile, 'Sheet', sheet2);
    writetable(obj.DemandUnbalanceZoneFF_AggT, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by zones
    if param.GeneratePlots
        unit_labl = '[trips]';
        titulo = 'Total trips starting on-street (FF)';    
        plotTableZone('DemandOrigZoneFF_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total trips finishing on-street (FF)';
        plotTableZone('DemandDestZoneFF_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Unbalance of trips in the Free-Floating system (FF)';
        unit_labl = 'Difference between trips finishing and starting [trips]';
        plotTableZone('DemandUnbalanceZoneFF_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDemandInTotalAggT
function tableDemandInTotalAggT(param, xlsfile, sheet1, sheet2, sheet3, zoneI, zoneF, obj)
    % Function to create tables with origin/destination demand
    % from/to station+zones in every zone aggregated by time (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.DemandOrigZoneTotal_AggT = table(ID);
    obj.DemandDestZoneTotal_AggT = table(ID);
    obj.DemandUnbalanceZoneTotal_AggT = table(ID);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    Orig = zeros(zoneF-zoneI+1, TotalTime);
    Dest = zeros(zoneF-zoneI+1, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
        k = find(list_zone==CarZoneO);
        if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user takes the car
            if tO2Car > 0
                Orig(k,tO2Car) = Orig(k,tO2Car) + 1;
            end
        end
        %
        CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
        k = find(list_zone==CarZoneD);
        if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when the user parks the car
            if tTrip > 0
                Dest(k,tTrip) = Dest(k,tTrip) + 1;
            end
        end
    end
    %
    % Add column to table
    obj.DemandOrigZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = sum(Orig,2);
    obj.DemandDestZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = sum(Dest,2);
    obj.DemandUnbalanceZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = sum(Orig,2)-sum(Dest,2);
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandOrigZoneTotal_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandDestZoneTotal_AggT, xlsfile, 'Sheet', sheet2);
    writetable(obj.DemandUnbalanceZoneTotal_AggT, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by zones
    if param.GeneratePlots
        unit_labl = '[trips]';
        titulo = 'Total trips starting per zone (SB+FF)';
        plotTableZone('DemandOrigZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total trips finishing per zone (SB+FF)';
        plotTableZone('DemandDestZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total unbalance per zone (SB+FF)';
        unit_labl = 'Difference between trips finishing and starting [trips]';
        plotTableZone('DemandUnbalanceZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDemandInStationAggR
function tableDemandInStationAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj)
    % Function to create tables with origin/destination demand
    % from/to stations in every zone aggregated by region (sum)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.DemandOrigZoneSB_AggR = table(Time);
    obj.DemandDestZoneSB_AggR = table(Time);
    obj.DemandUnbalanceZoneSB_AggR = table(Time);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Orig = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    Dest = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;       % Time when the user takes the car
            if tO2Car > 0
                Orig(CarZoneO,tO2Car) = Orig(CarZoneO,tO2Car) + 1;
            end
        end
        %
        if obj.MyCity.vFinishedUsers{iusr}.StatD > 0               % Destination at station StatD
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;         % Time when the user parks the car
            if tTrip > 0
                Dest(CarZoneD,tTrip) = Dest(CarZoneD,tTrip) + 1;
            end
        end
    end
    %
    dayO = zeros(thf-thi+1,1);
    dayD = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        dayO(th) = sum(sum(Orig(:,ti:tf),1));
        dayD(th) = sum(sum(Dest(:,ti:tf),1));
    end
    % Add column to table
    obj.DemandOrigZoneSB_AggR.('DemandOrigZoneSB_AggR') = dayO;
    obj.DemandDestZoneSB_AggR.('DemandDestZoneSB_AggR') = dayD;
    obj.DemandUnbalanceZoneSB_AggR.('DemandUnbalanceZoneSB_AggR') = dayO-dayD;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandOrigZoneSB_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandDestZoneSB_AggR, xlsfile, 'Sheet', sheet2);
    writetable(obj.DemandUnbalanceZoneSB_AggR, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Trips starting in stations over time (SB)';
        eje_y = 'Total trips starting [trips]';
        plotTableTime('DemandOrigZoneSB_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Trips finishing in stations over time (SB)';
        eje_y = 'Total trips finishing [trips]';
        plotTableTime('DemandDestZoneSB_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Imbalance of trips in stations over time (SB)';
        eje_y = 'Difference between trips finishing and starting [trips]';
        plotTableTime('DemandUnbalanceZoneSB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableDemandInZoneAggR
function tableDemandInZoneAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj)
    % Function to create tables with origin/destination demand
    % from/to zones in every zone aggregated by region (sum)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.DemandOrigZoneFF_AggR = table(Time);
    obj.DemandDestZoneFF_AggR = table(Time);
    obj.DemandUnbalanceZoneFF_AggR = table(Time);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Orig = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    Dest = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at station StatO
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;       % Time when the user takes the car
            if tO2Car > 0
                Orig(CarZoneO,tO2Car) = Orig(CarZoneO,tO2Car) + 1;
            end
        end
        %
        if obj.MyCity.vFinishedUsers{iusr}.StatD == 0              % Destination at station StatD
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;         % Time when the user parks the car
            if tTrip > 0
                Dest(CarZoneD,tTrip) = Dest(CarZoneD,tTrip) + 1;
            end
        end
    end
    %
    dayO = zeros(thf-thi+1,1);
    dayD = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        dayO(th) = sum(sum(Orig(:,ti:tf),1));
        dayD(th) = sum(sum(Dest(:,ti:tf),1));
    end
    % Add column to table
    obj.DemandOrigZoneFF_AggR.('DemandOrigZoneFF_AggR') = dayO;
    obj.DemandDestZoneFF_AggR.('DemandDestZoneFF_AggR') = dayD;
    obj.DemandUnbalanceZoneFF_AggR.('DemandUnbalanceZoneFF_AggR') = dayO-dayD;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandOrigZoneFF_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandDestZoneFF_AggR, xlsfile, 'Sheet', sheet2);
    writetable(obj.DemandUnbalanceZoneFF_AggR, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Trips starting on-street over time (FF)';
        eje_y = 'Total trips starting [trips]';
        plotTableTime('DemandOrigZoneFF_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Trips finishing on-street over time (FF)';
        eje_y = 'Total trips finishing [trips]';
        plotTableTime('DemandDestZoneFF_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Imbalance of trips on-street over time (FF)';
        eje_y = 'Difference between trips finishing and starting [trips]';
        plotTableTime('DemandUnbalanceZoneFF_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableDemandInTotalAggR
function tableDemandInTotalAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj)
    % Function to create tables with origin/destination demand
    % from/to stations+zones in every zone aggregated by region (sum)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.DemandOrigZoneTotal_AggR = table(Time);
    obj.DemandDestZoneTotal_AggR = table(Time);
    obj.DemandUnbalanceZoneTotal_AggR = table(Time);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Orig = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    Dest = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
        tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;       % Time when the user takes the car
        if tO2Car > 0
            Orig(CarZoneO,tO2Car) = Orig(CarZoneO,tO2Car) + 1;
        end
        %
        CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
        tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;         % Time when the user parks the car
        if tTrip > 0
            Dest(CarZoneD,tTrip) = Dest(CarZoneD,tTrip) + 1;
        end
    end
    %
    dayO = zeros(thf-thi+1,1);
    dayD = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        dayO(th) = sum(sum(Orig(:,ti:tf),1));
        dayD(th) = sum(sum(Dest(:,ti:tf),1));
    end
    % Add column to table
    obj.DemandOrigZoneTotal_AggR.('DemandOrigZoneTotal_AggR') = dayO;
    obj.DemandDestZoneTotal_AggR.('DemandDestZoneTotal_AggR') = dayD;
    obj.DemandUnbalanceZoneTotal_AggR.('DemandUnbalanceZoneTotal_AggR') = dayO-dayD;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandOrigZoneTotal_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandDestZoneTotal_AggR, xlsfile, 'Sheet', sheet2);
    writetable(obj.DemandUnbalanceZoneTotal_AggR, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total trips starting over time (SB+FF)';
        eje_y = 'Total trips starting [trips]';
        plotTableTime('DemandOrigZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Total trips finishing over time (SB+FF)';
        eje_y = 'Total trips finishing [trips]';
        plotTableTime('DemandDestZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Total imbalance of trips over time (SB+FF)';
        eje_y = 'Difference between trips finishing and starting [trips]';
        plotTableTime('DemandUnbalanceZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableLostTripsInTotalTime
function tableLostTripsInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create tables with lost trips from stations+zones 
    % in every zone at every hour (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.LostTripsTotal_dt = table(ID);

    % Generate matrix from notServicedUsers
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    Lost = zeros(zoneF-zoneI+1, TotalTime);
    %
    for iusr=1:size(obj.MyCity.notServicedUsers,1)
        zoneO = obj.MyCity.notServicedUsers(iusr,1);
        t = obj.MyCity.notServicedUsers(iusr,6);
        k = find(list_zone==zoneO);
        if size(k,1) > 0 && size(k,2) > 0
            Lost(k,t) = Lost(k,t) + 1;
        end
    end
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = sum(Lost(:,ti:tf),2);

        % Add column to table
        obj.LostTripsTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.LostTripsTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Lost trips per zone and hour';
        unit_labl = '[trips]';
        plotTableZone('LostTripsTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableLostTripsInTotalAggT
function tableLostTripsInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create tables with lost trips from stations+zones 
    % in every zone aggregated by time (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.LostTripsTotal_AggT = table(ID);

    % Generate matrix from notServicedUsers
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    Lost = zeros(zoneF-zoneI+1, TotalTime);
    %
    for iusr=1:size(obj.MyCity.notServicedUsers,1)
        zoneO = obj.MyCity.notServicedUsers(iusr,1);
        t = obj.MyCity.notServicedUsers(iusr,6);
        k = find(list_zone==zoneO);
        if size(k,1) > 0 && size(k,2) > 0
            Lost(k,t) = Lost(k,t) + 1;
        end
    end
    %
    aux = sum(Lost(:,1:TotalTime),2);

    % Add column to table
    obj.LostTripsTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.LostTripsTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total lost trips per zone';
        unit_labl = '[trips]';
        plotTableZone('LostTripsTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableLostTripsInTotalAggR
function tableLostTripsInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create tables with lost trips from stations+zones 
    % in every zone aggregated by region (sum)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.LostTripsTotal_AggR = table(Time);

    % Generate matrix from notServicedUsers
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Lost = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    for iusr=1:size(obj.MyCity.notServicedUsers,1)
        zoneO = obj.MyCity.notServicedUsers(iusr,1);
        t = obj.MyCity.notServicedUsers(iusr,6);
        Lost(zoneO,t) = Lost(zoneO,t) + 1;
    end
    %
    day = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        day(th) = sum(sum(Lost(:,ti:tf),1));
    end

    % Add column to table
    obj.LostTripsTotal_AggR.('LostTripsTotal_AggR') = day;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.LostTripsTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically
    if param.GeneratePlots
        titulo = 'Lost trips in the system over time';
        eje_y = 'Trips';
        plotTableTime('LostTripsTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableAvgAccessInStationTime
function tableAvgAccessInStationTime(param, xlsfile, sheet, thi, thf, statI, statF, obj)
    % Function to create table with average access time
    % in every zone from stations at every hour (mean)

    % Generate first 2 columns with labels
    ID = []; Name = {};
    for istat=statI:statF
        ID(end+1,1) = obj.MyCity.vStations{istat}.ID;
        try
            Name(end+1,1) = obj.MyCity.vStations{istat}.Name;
        catch
            Name(end+1,1) = {''};
        end
    end
    %
    obj.AvgAccessZoneSB_dt = table(ID, Name);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = cell(statF-statI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
                k = find(list_stat==obj.MyCity.vFinishedUsers{iusr}.StatO);
                if size(k,1) > 0 && size(k,2) > 0                      % The car station at origin is in list_stat
                    tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user takes the car
                    %
                    % Access time = Time when user takes the car - Time of car reservation
                    tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
                    %
                    if tO2Car >= ti && tO2Car < tf
                        aux{k}(end+1) = tAccess*param.WalkSpeed*1000/60;
                    end
                end
            end
        end
        %
        aux2 = zeros(statF-statI+1,1);
        for i=1:statF-statI+1
            aux2(i) = mean(aux{i});
        end

        % Add column to table
        obj.AvgAccessZoneSB_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgAccessZoneSB_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance (SB) per station and hour';
        unit_labl = '[meters]';
        plotTableStation('AvgAccessZoneSB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgAccessInZoneTime
function tableAvgAccessInZoneTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with average access time
    % in every zone from zones at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgAccessZoneFF_dt = table(ID);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = cell(zoneF-zoneI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at FF
                CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
                k = find(list_zone==CarZoneO);
                if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                    tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user takes the car
                    %
                    % Access time = Time when user takes the car - Time of car reservation
                    tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
                    %
                    if tO2Car >= ti && tO2Car < tf
                        aux{k}(end+1) = tAccess*param.WalkSpeed*1000/60;
                    end
                end
            end
        end
        %
        aux2 = zeros(zoneF-zoneI+1,1);
        for i=1:zoneF-zoneI+1
            aux2(i) = mean(aux{i});
        end

        % Add column to table
        obj.AvgAccessZoneFF_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgAccessZoneFF_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance on-street (FF) per zone and hour';
        unit_labl = '[meters]';
        plotTableZone('AvgAccessZoneFF_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgAccessInTotalTime
function tableAvgAccessInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with average access time
    % in every zone from stations+zones at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgAccessZoneTotal_dt = table(ID);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = cell(zoneF-zoneI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            k = find(list_zone==CarZoneO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user takes the car
                %
                % Access time = Time when user takes the car - Time of car reservation
                tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
                %
                if tO2Car >= ti && tO2Car < tf
                    aux{k}(end+1) = tAccess*param.WalkSpeed*1000/60;
                end
            end
        end
        %
        aux2 = zeros(zoneF-zoneI+1,1);
        for i=1:zoneF-zoneI+1
            aux2(i) = mean(aux{i});
        end

        % Add column to table
        obj.AvgAccessZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgAccessZoneTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance in the system (SB+FF) per zone and hour';
        unit_labl = '[meters]';
        plotTableZone('AvgAccessZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgAccessInStationAggT
function tableAvgAccessInStationAggT(param, xlsfile, sheet, statI, statF, obj)
    % Function to create table with average access time
    % in every zone from stations aggregated by time (mean)

    % Generate first 2 columns with labels
    ID = []; Name = {};
    for istat=statI:statF
        ID(end+1,1) = obj.MyCity.vStations{istat}.ID;
        try
            Name(end+1,1) = obj.MyCity.vStations{istat}.Name;
        catch
            Name(end+1,1) = {''};
        end
    end
    %
    obj.AvgAccessZoneSB_AggT = table(ID, Name);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    aux = cell(statF-statI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
            k = find(list_stat==obj.MyCity.vFinishedUsers{iusr}.StatO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car station at origin is in list_stat
                %
                % Access time = Time when user takes the car - Time of car reservation
                tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
                %
                aux{k}(end+1) = tAccess*param.WalkSpeed*1000/60;
            end
        end
    end
    %
    aux2 = zeros(statF-statI+1,1);
    for i=1:statF-statI+1
        aux2(i) = mean(aux{i});
    end

    % Add column to table
    obj.AvgAccessZoneSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgAccessZoneSB_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance (SB) per station';
        unit_labl = '[meters]';
        plotTableStation('AvgAccessZoneSB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgAccessInZoneAggT
function tableAvgAccessInZoneAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with average access time
    % in every zone from zones aggregated by time (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgAccessZoneFF_AggT = table(ID);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = cell(zoneF-zoneI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at FF
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            k = find(list_zone==CarZoneO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                %
                % Access time = Time when user takes the car - Time of car reservation
                tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
                %
                aux{k}(end+1) = tAccess*param.WalkSpeed*1000/60;
            end
        end
    end
    %
    aux2 = zeros(zoneF-zoneI+1,1);
    for i=1:zoneF-zoneI+1
        aux2(i) = mean(aux{i});
    end

    % Add column to table
    obj.AvgAccessZoneFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgAccessZoneFF_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance on-street (FF) per zone';
        unit_labl = '[meters]';
        plotTableZone('AvgAccessZoneFF_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgAccessInTotalAggT
function tableAvgAccessInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with average access time
    % in every zone from stations+zones aggregated by time (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgAccessZoneTotal_AggT = table(ID);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = cell(zoneF-zoneI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
        k = find(list_zone==CarZoneO);
        if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
            %
            % Access time = Time when user takes the car - Time of car reservation
            tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
            %
            aux{k}(end+1) = tAccess*param.WalkSpeed*1000/60;
        end
    end
    %
    aux2 = zeros(zoneF-zoneI+1,1);
    for i=1:zoneF-zoneI+1
        aux2(i) = mean(aux{i});
    end

    % Add column to table
    obj.AvgAccessZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgAccessZoneTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance in the system (SB+FF) per zone';
        unit_labl = '[meters]';
        plotTableZone('AvgAccessZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgAccessInStationAggR
function tableAvgAccessInStationAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with average access time
    % in every zone from stations at every hour (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.AvgAccessZoneSB_AggR = table(Time);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = cell(thf-thi+1,1);
    aux2 = zeros(thf-thi+1,1);
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;       % Time when the user takes the car
                %
                % Access time = Time when user takes the car - Time of car reservation
                tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
                %
                if tO2Car >= ti && tO2Car < tf
                    aux{th}(end+1) = tAccess*param.WalkSpeed*1000/60;
                end
            end
        end
        %
        aux2(th) = mean(aux{th});
    end
    % Add column to table
    obj.AvgAccessZoneSB_AggR.('AvgAccessZoneSB_AggR') = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgAccessZoneSB_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance in stations (SB) over time';
        eje_y = 'Distance [meters]';
        plotTableTime('AvgAccessZoneSB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableAvgAccessInZoneAggR
function tableAvgAccessInZoneAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with average access time
    % in every zone from zones at every hour (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.AvgAccessZoneFF_AggR = table(Time);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = cell(thf-thi+1,1);
    aux2 = zeros(thf-thi+1,1);
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at FF
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;       % Time when the user takes the car
                %
                % Access time = Time when user takes the car - Time of car reservation
                tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
                %
                if tO2Car >= ti && tO2Car < tf
                    aux{th}(end+1) = tAccess*param.WalkSpeed*1000/60;
                end
            end
        end
        %
        aux2(th) = mean(aux{th});
    end
    % Add column to table
    obj.AvgAccessZoneFF_AggR.('AvgAccessZoneFF_AggR') = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgAccessZoneFF_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance on-street (FF) over time';
        eje_y = 'Distance [meters]';
        plotTableTime('AvgAccessZoneFF_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableAvgAccessInTotalAggR
function tableAvgAccessInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with average access time
    % in every zone from stations+zones at every hour (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.AvgAccessZoneTotal_AggR = table(Time);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = cell(thf-thi+1,1);
    aux2 = zeros(thf-thi+1,1);
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;       % Time when the user takes the car
            %
            % Access time = Time when user takes the car - Time of car reservation
            tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
            %
            if tO2Car >= ti && tO2Car < tf
                aux{th}(end+1) = tAccess*param.WalkSpeed*1000/60;
            end
        end
        %
        aux2(th) = mean(aux{th});
    end
    % Add column to table
    obj.AvgAccessZoneTotal_AggR.('AvgAccessZoneTotal_AggR') = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgAccessZoneTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance in the system (SB+FF) over time';
        eje_y = 'Distance [meters]';
        plotTableTime('AvgAccessZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableAvgEgressInStationTime
function tableAvgEgressInStationTime(param, xlsfile, sheet, thi, thf, statI, statF, obj)
    % Function to create table with average Egress time
    % in every zone from stations at every hour (mean)

    % Generate first 2 columns with labels
    ID = []; Name = {};
    for istat=statI:statF
        ID(end+1,1) = obj.MyCity.vStations{istat}.ID;
        try
            Name(end+1,1) = obj.MyCity.vStations{istat}.Name;
        catch
            Name(end+1,1) = {''};
        end
    end
    %
    obj.AvgEgressZoneSB_dt = table(ID, Name);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = cell(statF-statI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatD > 0               % Destination at station StatD
                k = find(list_stat==obj.MyCity.vFinishedUsers{iusr}.StatD);
                if size(k,1) > 0 && size(k,2) > 0                      % The car station at destination is in list_stat
                    tCar2D = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user arrives at destination
                    %
                    % Egress time = Time when user arrives at destination - Time of car parking
                    tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
                    %
                    if tCar2D >= ti && tCar2D < tf
                        aux{k}(end+1) = tEgress*param.WalkSpeed*1000/60;
                    end
                end
            end
        end
        %
        aux2 = zeros(statF-statI+1,1);
        for i=1:statF-statI+1
            aux2(i) = mean(aux{i});
        end

        % Add column to table
        obj.AvgEgressZoneSB_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgEgressZoneSB_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance (SB) per station and hour';
        unit_labl = '[meters]';
        plotTableStation('AvgEgressZoneSB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgEgressInZoneTime
function tableAvgEgressInZoneTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with average Egress time
    % in every zone from zones at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgEgressZoneFF_dt = table(ID);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = cell(zoneF-zoneI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatD == 0              % Destination at FF
                CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
                k = find(list_zone==CarZoneD);
                if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
                    tCar2D = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user arrives at destination
                    %
                    % Egress time = Time when user arrives at destination - Time of car parking
                    tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
                    %
                    if tCar2D >= ti && tCar2D < tf
                        aux{k}(end+1) = tEgress*param.WalkSpeed*1000/60;
                    end
                end
            end
        end
        %
        aux2 = zeros(zoneF-zoneI+1,1);
        for i=1:zoneF-zoneI+1
            aux2(i) = mean(aux{i});
        end

        % Add column to table
        obj.AvgEgressZoneFF_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgEgressZoneFF_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance on-street (FF) per zone and hour';
        unit_labl = '[meters]';
        plotTableZone('AvgEgressZoneFF_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgEgressInTotalTime
function tableAvgEgressInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with average Egress time
    % in every zone from stations+zones at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgEgressZoneTotal_dt = table(ID);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = cell(zoneF-zoneI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            k = find(list_zone==CarZoneD);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
                tCar2D = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user arrives at destination
                %
                % Egress time = Time when user arrives at destination - Time of car parking
                tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
                %
                if tCar2D >= ti && tCar2D < tf
                    aux{k}(end+1) = tEgress*param.WalkSpeed*1000/60;
                end
            end
        end
        %
        aux2 = zeros(zoneF-zoneI+1,1);
        for i=1:zoneF-zoneI+1
            aux2(i) = mean(aux{i});
        end

        % Add column to table
        obj.AvgEgressZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgEgressZoneTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance in the system (SB+FF) per zone and hour';
        unit_labl = '[meters]';
        plotTableZone('AvgEgressZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgEgressInStationAggT
function tableAvgEgressInStationAggT(param, xlsfile, sheet, statI, statF, obj)
    % Function to create table with average Egress time
    % in every zone from stations aggregated by time (mean)

    % Generate first 2 columns with labels
    ID = []; Name = {};
    for istat=statI:statF
        ID(end+1,1) = obj.MyCity.vStations{istat}.ID;
        try
            Name(end+1,1) = obj.MyCity.vStations{istat}.Name;
        catch
            Name(end+1,1) = {''};
        end
    end
    %
    obj.AvgEgressZoneSB_AggT = table(ID, Name);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    aux = cell(statF-statI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatD > 0               % Destination at station StatD
            k = find(list_stat==obj.MyCity.vFinishedUsers{iusr}.StatD);
            if size(k,1) > 0 && size(k,2) > 0                      % The car station at destination is in list_stat
                %
                % Egress time = Time when user arrives at destination - Time of car parking
                tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
                %
                aux{k}(end+1) = tEgress*param.WalkSpeed*1000/60;
            end
        end
    end
    %
    aux2 = zeros(statF-statI+1,1);
    for i=1:statF-statI+1
        aux2(i) = mean(aux{i});
    end

    % Add column to table
    obj.AvgEgressZoneSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgEgressZoneSB_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance (SB) per station';
        unit_labl = '[meters]';
        plotTableStation('AvgEgressZoneSB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgEgressInZoneAggT
function tableAvgEgressInZoneAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with average Egress time
    % in every zone from zones aggregated by time (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgEgressZoneFF_AggT = table(ID);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = cell(zoneF-zoneI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatD == 0              % Destination at FF
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            k = find(list_zone==CarZoneD);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
                %
                % Egress time = Time when user arrives at destination - Time of car parking
                tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
                %
                aux{k}(end+1) = tEgress*param.WalkSpeed*1000/60;
            end
        end
    end
    %
    aux2 = zeros(zoneF-zoneI+1,1);
    for i=1:zoneF-zoneI+1
        aux2(i) = mean(aux{i});
    end

    % Add column to table
    obj.AvgEgressZoneFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgEgressZoneFF_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance on-street (FF) per zone';
        unit_labl = '[meters]';
        plotTableZone('AvgEgressZoneFF_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgEgressInTotalAggT
function tableAvgEgressInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with average Egress time
    % in every zone from stations+zones aggregated by time (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgEgressZoneTotal_AggT = table(ID);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = cell(zoneF-zoneI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
        k = find(list_zone==CarZoneD);
        if size(k,1) > 0 && size(k,2) > 0                      % The car zone at destination is in list_zone
            %
            % Egress time = Time when user arrives at destination - Time of car parking
            tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
            %
            aux{k}(end+1) = tEgress*param.WalkSpeed*1000/60;
        end
    end
    %
    aux2 = zeros(zoneF-zoneI+1,1);
    for i=1:zoneF-zoneI+1
        aux2(i) = mean(aux{i});
    end

    % Add column to table
    obj.AvgEgressZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgEgressZoneTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance in the system (SB+FF) per zone [meters]';
        unit_labl = '[meters]';
        plotTableZone('AvgEgressZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgEgressInStationAggR
function tableAvgEgressInStationAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with average Egress time
    % in every zone from stations at every hour (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.AvgEgressZoneSB_AggR = table(Time);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = cell(thf-thi+1,1);
    aux2 = zeros(thf-thi+1,1);
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatD > 0           % Destination at station StatD
                tCar2D = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user arrives at destination
                %
                % Egress time = Time when user arrives at destination - Time of car parking
                tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
                %
                if tCar2D >= ti && tCar2D < tf
                    aux{th}(end+1) = tEgress*param.WalkSpeed*1000/60;
                end
            end
        end
        %
        aux2(th) = mean(aux{th});
    end
    % Add column to table
    obj.AvgEgressZoneSB_AggR.('AvgEgressZoneSB_AggR') = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgEgressZoneSB_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by time
    if param.GeneratePlots
        titulo = 'Average egress distance in stations (SB) over time';
        eje_y = 'Distance [meters]';
        plotTableTime('AvgEgressZoneSB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableAvgEgressInZoneAggR
function tableAvgEgressInZoneAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with average Egress time
    % in every zone from zones at every hour (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.AvgEgressZoneFF_AggR = table(Time);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = cell(thf-thi+1,1);
    aux2 = zeros(thf-thi+1,1);
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatD == 0          % Destination at station StatD
                tCar2D = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user arrives at destination
                %
                % Egress time = Time when user arrives at destination - Time of car parking
                tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
                %
                if tCar2D >= ti && tCar2D < tf
                    aux{th}(end+1) = tEgress*param.WalkSpeed*1000/60;
                end
            end
        end
        %
        aux2(th) = mean(aux{th});
    end
    % Add column to table
    obj.AvgEgressZoneFF_AggR.('AvgEgressZoneFF_AggR') = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgEgressZoneFF_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance on-street (FF) over time';
        eje_y = 'Distance [meters]';
        plotTableTime('AvgEgressZoneFF_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableAvgEgressInTotalAggR
function tableAvgEgressInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with average Egress time
    % in every zone from stations+zones at every hour (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.AvgEgressZoneTotal_AggR = table(Time);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = cell(thf-thi+1,1);
    aux2 = zeros(thf-thi+1,1);
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            tCar2D = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when the user arrives at destination
            %
            % Egress time = Time when user arrives at destination - Time of car parking
            tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
            %
            if tCar2D >= ti && tCar2D < tf
                aux{th}(end+1) = tEgress*param.WalkSpeed*1000/60;
            end
        end
        %
        aux2(th) = mean(aux{th});
    end
    % Add column to table
    obj.AvgEgressZoneTotal_AggR.('AvgEgressZoneTotal_AggR') = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgEgressZoneTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance in the system (SB+FF) over time';
        eje_y = 'Distance [meters]';
        plotTableTime('AvgEgressZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableFareTripsInStationTime
function tableFareTripsInStationTime(param, xlsfile, sheet, thi, thf, statI, statF, obj)
    % Function to create table with fare from trips
    % from stations at every hour (sum)

    % Generate first 2 columns with labels
    ID = []; Name = {};
    for istat=statI:statF
        ID(end+1,1) = obj.MyCity.vStations{istat}.ID;
        try
            Name(end+1,1) = obj.MyCity.vStations{istat}.Name;
        catch
            Name(end+1,1) = {''};
        end
    end
    %
    obj.FareTripsSB_dt = table(ID, Name);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = zeros(statF-statI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
                k = find(list_stat==obj.MyCity.vFinishedUsers{iusr}.StatO);
                if size(k,1) > 0 && size(k,2) > 0                      % The car station at origin is in list_stat
                    tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
                    tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
                    %
                    % Trip time = Time when user arrives at parking - Time of taking car
                    trip = tTrip - tO2Car;
                    %
                    if tO2Car >= ti && tO2Car < tf
                        aux(k) = aux(k) + trip*param.avgFare;
                    end
                end
            end
        end

        % Add column to table
        obj.FareTripsSB_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.FareTripsSB_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Revenue in the Station-Based system (SB) per station and hour';
        unit_labl = 'Total revenue in [€]';
        plotTableStation('FareTripsSB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableFareTripsInZoneTime
function tableFareTripsInZoneTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with average Egress time
    % in every zone from zones at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.FareTripsFF_dt = table(ID);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = zeros(zoneF-zoneI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at FF
                k = find(list_zone==obj.MyCity.vFinishedUsers{iusr}.CarZoneO);
                if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                    tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
                    tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
                    %
                    % Trip time = Time when user arrives at parking - Time of taking car
                    trip = tTrip - tO2Car;
                    %
                    if tO2Car >= ti && tO2Car < tf
                        aux(k) = aux(k) + trip*param.avgFare;
                    end
                end
            end
        end

        % Add column to table
        obj.FareTripsFF_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.FareTripsFF_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Revenue in the Free-Floating system (FF) per zone and hour';
        unit_labl = 'Total revenue in [€]';
        plotTableZone('FareTripsFF_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableFareTripsInTotalTime
function tableFareTripsInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with average Egress time
    % in every zone from stations+zones at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.FareTripsTotal_dt = table(ID);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = zeros(zoneF-zoneI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            k = find(list_zone==CarZoneO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
                tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
                %
                % Trip time = Time when user arrives at parking - Time of taking car
                trip = tTrip - tO2Car;
                %
                if tO2Car >= ti && tO2Car < tf
                    aux(k) = aux(k) + trip*param.avgFare;
                end
            end
        end
        % Add column to table
        obj.FareTripsTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.FareTripsTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Total revenue in the system (SB+FF) per zone and hour';
        unit_labl = 'Total revenue in [€]';
        plotTableZone('FareTripsTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableFareTripsInStationAggT
function tableFareTripsInStationAggT(param, xlsfile, sheet, statI, statF, obj)
    % Function to create table with average access time
    % in every zone from stations aggregated by time (mean)

    % Generate first 2 columns with labels
    ID = []; Name = {};
    for istat=statI:statF
        ID(end+1,1) = obj.MyCity.vStations{istat}.ID;
        try
            Name(end+1,1) = obj.MyCity.vStations{istat}.Name;
        catch
            Name(end+1,1) = {''};
        end
    end
    %
    obj.FareTripsSB_AggT = table(ID, Name);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    aux = zeros(statF-statI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
            k = find(list_stat==obj.MyCity.vFinishedUsers{iusr}.StatO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
                tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
                %
                % Trip time = Time when user arrives at parking - Time of taking car
                trip = tTrip - tO2Car;
                %
                aux(k) = aux(k) + trip*param.avgFare;
            end
        end
    end
    
    % Add column to table
    obj.FareTripsSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.FareTripsSB_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Revenue in the Station-Based system (SB) per station';
        unit_labl = 'Total revenue in [€]';
        plotTableStation('FareTripsSB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableFareTripsInZoneAggT
function tableFareTripsInZoneAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with average access time
    % in every zone from zones aggregated by time (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.FareTripsFF_AggT = table(ID);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = zeros(zoneF-zoneI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at FF
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            k = find(list_zone==CarZoneO);
            if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
                tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
                %
                % Trip time = Time when user arrives at parking - Time of taking car
                trip = tTrip - tO2Car;
                %
                aux(k) = aux(k) + trip*param.avgFare;
            end
        end
    end
    
    % Add column to table
    obj.FareTripsFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.FareTripsFF_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Revenue in the Free-Floating system (FF) per zone';
        unit_labl = 'Total revenue in [€]';
        plotTableZone('FareTripsFF_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableFareTripsInTotalAggT
function tableFareTripsInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with average access time
    % in every zone from stations+zones aggregated by time (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.FareTripsTotal_AggT = table(ID);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = zeros(zoneF-zoneI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
        k = find(list_zone==CarZoneO);
        if size(k,1) > 0 && size(k,2) > 0                      % The car zone at origin is in list_zone
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
            %
            % Trip time = Time when user arrives at parking - Time of taking car
            trip = tTrip - tO2Car;
            %
            aux(k) = aux(k) + trip*param.avgFare;
        end
    end

    % Add column to table
    obj.FareTripsTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.FareTripsTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Total revenue in the system (SB+FF) per zone';
        unit_labl = 'Total revenue in [€]';
        plotTableZone('FareTripsTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableFareTripsInStationAggR
function tableFareTripsInStationAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with average access time
    % in every zone from stations at every hour (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.FareTripsSB_AggR = table(Time);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = zeros(thf-thi+1,1);
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
                tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
                %
                % Trip time = Time when user arrives at parking - Time of taking car
                trip = tTrip - tO2Car;
                %
                if tO2Car >= ti && tO2Car < tf
                    aux(th) = aux(th) + trip*param.avgFare;
                end
            end
        end
    end
    % Add column to table
    obj.FareTripsSB_AggR.('FareTripsSB_AggR') = aux;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.FareTripsSB_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Total revenue in the Station-Based system (SB) over time';
        eje_y = 'Revenue [€]';
        plotTableTime('FareTripsSB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableFareTripsInZoneAggR
function tableFareTripsInZoneAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with average access time
    % in every zone from zones at every hour (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.FareTripsFF_AggR = table(Time);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = zeros(thf-thi+1,1);
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            if obj.MyCity.vFinishedUsers{iusr}.StatO == 0          % Origin at station StatO
                tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
                tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
                %
                % Trip time = Time when user arrives at parking - Time of taking car
                trip = tTrip - tO2Car;
                %
                if tO2Car >= ti && tO2Car < tf
                    aux(th) = aux(th) + trip*param.avgFare;
                end
            end
        end
    end
    % Add column to table
    obj.FareTripsFF_AggR.('FareTripsFF_AggR') = aux;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.FareTripsFF_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Total revenue in the Free-Floating system (FF) over time';
        eje_y = 'Revenue [€]';
        plotTableTime('FareTripsFF_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableFareTripsInTotalAggR
function tableFareTripsInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with average access time
    % in every zone from stations+zones at every hour (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.FareTripsTotal_AggR = table(Time);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = zeros(thf-thi+1,1);
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
            %
            % Trip time = Time when user arrives at parking - Time of taking car
            trip = tTrip - tO2Car;
            %
            if tO2Car >= ti && tO2Car < tf
                aux(th) = aux(th) + trip*param.avgFare;
            end
        end
    end
    % Add column to table
    obj.FareTripsTotal_AggR.('FareTripsTotal_AggR') = aux;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.FareTripsTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Total revenue in the system (SB+FF) over time';
        eje_y = 'Revenue [€]';
        plotTableTime('FareTripsTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableDemandInStationSumm
function tableDemandInStationSumm(obj)
    % Function to create tables with origin/destination demand
    % from/to stations in every zone aggregated by region and time (sum)

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Orig = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    Dest = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;       % Time when the user takes the car
            if tO2Car > 0
                Orig(CarZoneO,tO2Car) = Orig(CarZoneO,tO2Car) + 1;
            end
        end
        %
        if obj.MyCity.vFinishedUsers{iusr}.StatD > 0               % Destination at station StatD
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;         % Time when the user parks the car
            if tTrip > 0
                Dest(CarZoneD,tTrip) = Dest(CarZoneD,tTrip) + 1;
            end
        end
    end
    %
    dayO = sum(sum(Orig,1));
    dayD = sum(sum(Dest,1));
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Demand starting (SB)' 'Users' num2str(dayO,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Demand finishing (SB)' 'Users' num2str(dayD,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Demand unbalance (SB)' 'Users' num2str(dayO-dayD,'%4.0f')}];
end

% tableDemandInZoneSumm
function tableDemandInZoneSumm(obj)
    % Function to create tables with origin/destination demand
    % from/to zones in every zone aggregated by region and time (sum)
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Orig = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    Dest = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at station StatO
            CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
            tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;       % Time when the user takes the car
            if tO2Car > 0
                Orig(CarZoneO,tO2Car) = Orig(CarZoneO,tO2Car) + 1;
            end
        end
        %
        if obj.MyCity.vFinishedUsers{iusr}.StatD == 0              % Destination at station StatD
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;         % Time when the user parks the car
            if tTrip > 0
                Dest(CarZoneD,tTrip) = Dest(CarZoneD,tTrip) + 1;
            end
        end
    end
    %
    dayO = sum(sum(Orig,1));
    dayD = sum(sum(Dest,1));
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Demand starting (FF)' 'Users' num2str(dayO,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Demand finishing (FF)' 'Users' num2str(dayD,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Demand imbalance (FF)' 'Users' num2str(dayO-dayD,'%4.0f')}];
end

% tableDemandInTotalSumm
function tableDemandInTotalSumm(obj)
    % Function to create tables with origin/destination demand
    % from/to stations+zones in every zone aggregated by region and time (sum)

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Orig = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    Dest = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        CarZoneO = obj.MyCity.vFinishedUsers{iusr}.CarZoneO;
        tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;       % Time when the user takes the car
        if tO2Car > 0
            Orig(CarZoneO,tO2Car) = Orig(CarZoneO,tO2Car) + 1;
        end
        %
        CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
        tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;         % Time when the user parks the car
        if tTrip > 0
            Dest(CarZoneD,tTrip) = Dest(CarZoneD,tTrip) + 1;
        end
    end
    %
    dayO = sum(sum(Orig,1));
    dayD = sum(sum(Dest,1));
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Demand starting (SB+FF)' 'Users' num2str(dayO,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Demand finishing (SB+FF)' 'Users' num2str(dayD,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Demand unbalance (SB+FF)' 'Users' num2str(dayO-dayD,'%4.0f')}];
end

% tableLostTripsInTotalSumm
function tableLostTripsInTotalSumm(obj)
    % Function to create tables with lost trips from stations+zones 
    % in every zone aggregated by region and time(sum)

    % Generate matrix from notServicedUsers
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Lost = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    for iusr=1:size(obj.MyCity.notServicedUsers,1)
        zoneO = obj.MyCity.notServicedUsers(iusr,1);
        t = obj.MyCity.notServicedUsers(iusr,6);
        Lost(zoneO,t) = Lost(zoneO,t) + 1;
    end
    %
    day = sum(sum(Lost,1));
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Total trips lost' 'Users' num2str(day,'%4.2f')}];
    obj.Summary = [obj.Summary; {'Lost trip percentage' 'Percentage' num2str(100*day/(day+obj.MyCity.numFinishedUsers),'%4.2f')}];
end

% tableAvgAccessInStationSumm
function tableAvgAccessInStationSumm(param, obj)
    % Function to create table with average access time
    % in every zone from stations aggregated by region and time (mean)

    % Generate avg access distance
    aux = [];
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
            %
            % Access time = Time when user takes the car - Time of car reservation
            tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
            %
            aux(end+1) = tAccess*param.WalkSpeed*1000/60;
        end
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. access distance (SB)' 'Meters' num2str(mean(aux),'%6.2f')}];
end

% tableAvgAccessInZoneSumm
function tableAvgAccessInZoneSumm(param, obj)
    % Function to create table with average access time
    % in every zone from zones aggregated by region and time (mean)

    % Generate avg access distance
    aux = [];
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatO == 0              % Origin at FF
            %
            % Access time = Time when user takes the car - Time of car reservation
            tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
            %
            aux(end+1) = tAccess*param.WalkSpeed*1000/60;
        end
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. access distance (FF)' 'Meters' num2str(mean(aux),'%6.2f')}];
end

% tableAvgAccessInTotalSumm
function tableAvgAccessInTotalSumm(param, obj)
    % Function to create table with average access time
    % in every zone from stations+zones aggregated by region and time (mean)

    % Generate avg access time
    aux = [];
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        %
        % Access time = Time when user takes the car - Time of car reservation
        tAccess = obj.MyCity.vFinishedUsers{iusr}.tO2Car - obj.MyCity.vFinishedUsers{iusr}.tCreation;
        %
        aux(end+1) = tAccess*param.WalkSpeed*1000/60;
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. access distance (SB+FF)' 'Meters' num2str(mean(aux),'%6.2f')}];
end

% tableAvgEgressInStationSumm
function tableAvgEgressInStationSumm(param, obj)
    % Function to create table with average Egress time
    % in every zone from stations aggregated by region and time (mean)

    % Generate avg Egress time
    aux = [];
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatD > 0           % Destination at station StatD
            %
            % Egress time = Time when user arrives at destination - Time of car parking
            tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
            %
            aux(end+1) = tEgress*param.WalkSpeed*1000/60;
        end
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. egress distance (SB)' 'Meters' num2str(mean(aux),'%6.2f')}];
end

% tableAvgEgressInZoneSumm
function tableAvgEgressInZoneSumm(param, obj)
    % Function to create table with average Egress time
    % in every zone from zones aggregated by region and time (mean)

    % Generate avg Egress time
    aux = [];
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        if obj.MyCity.vFinishedUsers{iusr}.StatD == 0          % Destination at station StatD
            %
            % Egress time = Time when user arrives at destination - Time of car parking
            tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
            %
            aux(end+1) = tEgress*param.WalkSpeed*1000/60;
        end
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. egress distance (FF)' 'Meters' num2str(mean(aux),'%6.2f')}];
end

% tableAvgEgressInTotalSumm
function tableAvgEgressInTotalSumm(param, obj)
    % Function to create table with average Egress time
    % in every zone from stations+zones aggregated by region and time (mean)

    % Generate avg Egress time
    aux = [];
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        %
        % Egress time = Time when user arrives at destination - Time of car parking
        tEgress = obj.MyCity.vFinishedUsers{iusr}.tCar2D - obj.MyCity.vFinishedUsers{iusr}.tTrip;
        %
        aux(end+1) = tEgress*param.WalkSpeed*1000/60;
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. egress distance (SB+FF)' 'Meters' num2str(mean(aux),'%6.2f')}];
end

% tableAvgTripsInTotalSumm
function tableAvgTripsInTotalSumm(param, obj)
    % Function to create table with average distance and time per trip
    % from stations+zones aggregated by region and time (sum)

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
        aux = aux + trip;
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. travel time' 'Minutes' num2str(aux/obj.MyCity.numFinishedUsers,'%8.2f')}];
    obj.Summary = [obj.Summary; {'Avg. travel distance' 'Kilometers' num2str((aux/obj.MyCity.numFinishedUsers)*param.CarSpeed/60,'%8.2f')}];
end

% tableAvgReservedTimeSumm
function tableAvgReservedTimeSumm(obj)
    % Function to create table with average reserved time per trip

    % Generate avg reserved time
    aux = 0;
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        tCreation = obj.MyCity.vFinishedUsers{iusr}.tCreation;   % Time when user is created (reservation)
        tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;         % Time when user takes the car
        %
        % Reservation time = Time when user arrives at car - Time of
        % creation
        reserv = tO2Car - tCreation;
        %
        aux = aux + reserv;
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. reservation time' 'Minutes' num2str(aux/obj.MyCity.numFinishedUsers,'%8.2f')}];
end

%% MOVED TO outputCosts.m
% % tableFareTripsInStationSumm
% function tableFareTripsInStationSumm(param, obj)
%     % Function to create table with average access time
%     % in every zone from stations aggregated by region and time (sum)
% 
%     % Generate avg access time
%     aux = 0;
%     %
%     for iusr=1:obj.MyCity.numFinishedUsers
%         if obj.MyCity.vFinishedUsers{iusr}.StatO > 0               % Origin at station StatO
%             tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
%             tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
%             %
%             % Trip time = Time when user arrives at parking - Time of taking car
%             trip = tTrip - tO2Car;
%             %
%             aux = aux + trip*param.avgFare;
%         end
%     end
%     % In [€/h]
%     aux = aux/60;
%     %
%     % Add row to table
%     obj.Summary = [obj.Summary; {'Revenue in stations' '€/h' num2str(aux,'%8.2f')}];
% end
% 
% % tableFareTripsInZoneSumm
% function tableFareTripsInZoneSumm(param, obj)
%     % Function to create table with average access time
%     % in every zone from zones aggregated by region and time (sum)
% 
%     % Generate avg access time
%     aux = 0;
%     %
%     for iusr=1:obj.MyCity.numFinishedUsers
%         if obj.MyCity.vFinishedUsers{iusr}.StatO == 0          % Origin at station StatO
%             tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
%             tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
%             %
%             % Trip time = Time when user arrives at parking - Time of taking car
%             trip = tTrip - tO2Car;
%             %
%             aux = aux + trip*param.avgFare;
%         end
%     end
%     % In [€/h]
%     aux = aux/60;
%     %
%     % Add row to table
%     obj.Summary = [obj.Summary; {'Revenue on street' '€/h' num2str(aux,'%8.2f')}];
% end
% 
% % tableFareTripsInTotalSumm
% function tableFareTripsInTotalSumm(param, obj)
%     % Function to create table with average access time
%     % in every zone from stations+zones aggregated by region and time (sum)
% 
%     % Generate avg access time
%     aux = 0;
%     %
%     for iusr=1:obj.MyCity.numFinishedUsers
%         tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
%         tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
%         %
%         % Trip time = Time when user arrives at parking - Time of taking car
%         trip = tTrip - tO2Car;
%         %
%         aux = aux + trip*param.avgFare;
%     end
%     % In [€/h]
%     aux = aux/60;
%     %
%     % Add row to table
%     obj.Summary = [obj.Summary; {'Total system revenue' '€/h' num2str(aux,'%8.2f')}];
% end


