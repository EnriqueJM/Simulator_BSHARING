function outputBattery(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj)
    % Function to generate results (tables & plots) about battery level
    
    if param.verbose
        disp('');
        disp('CREATING BATTERY LEVEL TABLES');
    end
    
    % Create Vehicles folder
    [status, msg, msgID] = mkdir([pwd '/' folder],'BatteryLevel');
    if status == 0
        error('Error: Output folder could not be created');
    end
    
    xlsfile = [folder '/BatteryLevel/Tables_battery.xlsx'];
    if isfile(xlsfile)
        delete(xlsfile);
    end

    %%%%%%%%%%%%%%%%%%%%%%
    %    HOURLY TABLES   % 
    %%%%%%%%%%%%%%%%%%%%%%
    if param.Hourly
        
        % BatteryInStationTime
        if param.verbose
            disp('Creating table BatteryInStationTime');
        end
        %
        sheet = 'BatteryInStationTime';
        tableBatteryInStationTime(param, xlsfile, sheet, thi, thf, StationI, StationF, obj);

        % BatteryInZoneTime
        if param.verbose
            disp('Creating table BatteryInZoneTime');
        end
        %
        sheet = 'BatteryInZoneTime';
        tableBatteryInZoneTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % BatteryInTotalTime
        if param.verbose
            disp('Creating table BatteryInTotalTime');
        end
        %
        sheet = 'BatteryInTotalTime';
        tableBatteryInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %    TIME AGGREGATION   % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggT
        
        % BatteryInStationAggT
        if param.verbose
            disp('Creating table BatteryInStationAggT');
        end
        %
        sheet = 'BatteryInStationAggT';
        tableBatteryInStationAggT(param, xlsfile, sheet, StationI, StationF, obj);

        % BatteryInZoneAggT
        if param.verbose
            disp('Creating table BatteryInZoneAggT');
        end
        %
        sheet = 'BatteryInZoneAggT';
        tableBatteryInZoneAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);

        % BatteryInTotalAggT
        if param.verbose
            disp('Creating table BatteryInTotalAggT');
        end
        %
        sheet = 'BatteryInTotalAggT';
        tableBatteryInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
    end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %   REGION AGGREGATION  % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggR
        
        % BatteryInStationAggR
        if param.verbose
            disp('Creating table BatteryInStationAggR');
        end
        %
        sheet = 'BatteryInStationAggR';
        tableBatteryInStationAggR(param, xlsfile, sheet, thi, thf, obj);

        % BatteryInZoneAggR
        if param.verbose
            disp('Creating table BatteryInZoneAggR');
        end
        %
        sheet = 'BatteryInZoneAggR';
        tableBatteryInZoneAggR(param, xlsfile, sheet, thi, thf, obj);

        % BatteryInTotalAggR
        if param.verbose
            disp('Creating table BatteryInTotalAggR');
        end
        %
        sheet = 'BatteryInTotalAggR';
        tableBatteryInTotalAggR(param, xlsfile, sheet, thi, thf, obj);
    end

    %%%%%%%%%%%%%%
    %   SUMMARY  %
    %%%%%%%%%%%%%%

    % BatteryInStationSumm
    if param.verbose
        disp('Creating table BatteryInStationSumm');
    end
    %
    tableBatteryInStationSumm(obj);

    % BatteryInZoneSumm
    if param.verbose
        disp('Creating table BatteryInZoneSumm');
    end
    %
    tableBatteryInZoneSumm(obj);

    % BatteryInTotalSumm
    if param.verbose
        disp('Creating table BatteryInTotalSumm');
    end
    %
    tableBatteryInTotalSumm(obj);

end

% tableBatteryInStationTime
function tableBatteryInStationTime(param, xlsfile, sheet, thi, thf, statI, statF, obj)
    % Function to create table with battery level of eCars in every station
    % at every hour (mean)

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
    obj.BatterySB_dt = table(ID, Name);

    % Generate battery level of ecars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = zeros(statF-statI+1, 1);
        %
        for istat=1:size(list_stat,2)
            aux2 = [];
            for t=ti:tf
                % Add battery level of ecars at station list_stat(istat) at time t
                list_cars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
                %
                for icar=1:size(list_cars,2)
                    if obj.MyCity.vCars{list_cars(icar)}.isElectric
                        aux2(end+1) = obj.MyCity.vCars{list_cars(icar)}.batteryLevel(t);
                    end
                end
            end
            %
            aux(istat,1) = mean(aux2);
        end

        % Add column to table
        obj.BatterySB_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux;
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.BatterySB_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg battery level of cars in stations (SB) per hour';
        unit_labl = 'Battery level [%]';
        plotTableStation('BatterySB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableBatteryInZoneTime
function tableBatteryInZoneTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with battery level of eCars in every
    % zone at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.BatteryFF_dt = table(ID);

    % Generate battery level of ecars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = zeros(zoneF-zoneI+1, 1);
        %
        for izone=1:size(list_zone,2)
            aux2 = [];
            for t=ti:tf
                % Add battery level of ecars at zone list_zone(izone) at time t
                list_cars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{t};
                %
                for icar=1:size(list_cars,2)
                    if obj.MyCity.vCars{list_cars(icar)}.isElectric
                        aux2(end+1) = obj.MyCity.vCars{list_cars(icar)}.batteryLevel(t);
                    end
                end
            end
            %
            aux(izone,1) = mean(aux2);
        end

        % Add column to table
        obj.BatteryFF_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux;
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.BatteryFF_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Avg battery level of cars on street (FF) per hour';
        unit_labl = 'Battery level [%]';
        plotTableZone('BatteryFF_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableBatteryInTotalTime
function tableBatteryInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with battery level of eCars in every
    % station+zone at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.BatteryTotal_dt = table(ID);

    % Generate battery level of ecars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = zeros(zoneF-zoneI+1, 1);
        %
        for izone=1:size(list_zone,2)
            aux2 = [];
            for t=ti:tf
                % Add battery level of ecars at station list_stat(istat) at time t
                list_cars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{t};
                for icar=1:size(list_cars,2)
                    if obj.MyCity.vCars{list_cars(icar)}.isElectric
                        aux2(end+1) = obj.MyCity.vCars{list_cars(icar)}.batteryLevel(t);
                    end
                end
                
                % Add battery level of cars in station (inside zone) at time t
                list_stat = obj.MyCity.vFreeFloatZones{list_zone(izone)}.listStations;
                for istat=1:size(list_stat,2)
                    list_cars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
                    for icar=1:size(list_cars,2)
                        if obj.MyCity.vCars{list_cars(icar)}.isElectric 
                            aux2(end+1) = obj.MyCity.vCars{list_cars(icar)}.batteryLevel(t);
                        end
                    end
                end
            end
            %
            aux(izone,1) = mean(aux2);
        end

        % Add column to table
        obj.BatteryTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux;
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.BatteryTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Avg battery level of cars in the system (FF+SB) per hour';
        unit_labl = 'Battery level [%]';
        plotTableZone('BatteryTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableBatteryInStationAggT
function tableBatteryInStationAggT(param, xlsfile, sheet, statI, statF, obj)
    % Function to create table with battery level in every station
    % (mean of total time)

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
    obj.BatterySB_AggT = table(ID, Name);
    %
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    aux = zeros(statF-statI+1, 1);
    %
    % Battery level of cars in station at time t
    for istat=1:size(list_stat,2)
        aux2 = [];
        for t=1:TotalTime
            %
            listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.isElectric 
                    aux2(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel(t);
                end
            end
        end
        %
        aux(istat) = mean(aux2);
    end

    % Add column to table
    obj.BatterySB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.BatterySB_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg battery level of cars in stations (SB)';
        unit_labl = 'Battery level [%]';
        plotTableStation('BatterySB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableBatteryInZoneAggT
function tableBatteryInZoneAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with battery level in every zone
    % (mean of total time)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.BatteryFF_AggT = table(ID);
    %
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = zeros(zoneF-zoneI+1, 1);
    %
    % Battery level of cars in station at time t
    for izone=1:size(list_zone,2)
        aux2 = [];
        for t=1:TotalTime
            %
            listCars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.isElectric 
                    aux2(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel(t);
                end
            end
        end
        %
        aux(izone) = mean(aux2);
    end

    % Add column to table
    obj.BatteryFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.BatteryFF_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg battery level of cars on street (FF)';
        unit_labl = 'Battery level [%]';
        plotTableZone('BatteryFF_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableBatteryInTotalAggT
function tableBatteryInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with battery level in every zone+station
    % (mean of total time)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.BatteryTotal_AggT = table(ID);
    %
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = zeros(zoneF-zoneI+1, 1);
    %
    % Battery level of cars in station at time t
    for izone=1:size(list_zone,2)
        aux2 = [];
        for t=1:TotalTime
            %
            listCars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.isElectric 
                    aux2(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel(t);
                end
            end
            %
            list_stat = obj.MyCity.vFreeFloatZones{list_zone(izone)}.listStations;
            for istat=1:size(list_stat,2)
                listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.isElectric 
                        aux2(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel(t);
                    end
                end
            end
        end
        %
        aux(izone) = mean(aux2);
    end

    % Add column to table
    obj.BatteryTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.BatteryTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg battery level of cars in the system (FF+SB)';
        unit_labl = 'Battery level [%]';
        plotTableZone('BatteryTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableBatteryInStationAggR
function tableBatteryInStationAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with battery level aggregated by station
    % at every hour (mean of 60min)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.BatterySB_AggR = table(Time);

    % Generate battery level aggregated by station in every hour as mean of
    % 60min
    %
    day = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        for t=1:tf-ti
            % Battery level of cars in station at time t
            aux2 = [];
            for istat=1:obj.MyCity.numStations
                listCars = obj.MyCity.vStations{istat}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.isElectric 
                        aux2(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel((th-1)*60+t);
                    end
                end
            end
        end
        %
        day(th) = mean(aux2);
    end
    % Add column to table
    obj.BatterySB_AggR.('BatterySB_AggR') = day;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.BatterySB_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg battery level of cars in stations (SB) over time';
        eje_y = 'Battery level [%]';
        plotTableTime('BatterySB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableBatteryInZoneAggR
function tableBatteryInZoneAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with battery level aggregated by zone
    % at every hour (mean of 60min)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.BatteryFF_AggR = table(Time);

    % Generate battery level aggregated by zone in every hour as mean of
    % 60min
    %
    day = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        for t=1:tf-ti
            % Count number of cars in station at time t
            aux2 = [];
            for izone=1:obj.MyCity.numFreeFloatZones
                listCars = obj.MyCity.vFreeFloatZones{izone}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.isElectric
                        aux2(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel((th-1)*60+t);
                    end
                end
            end
        end
        %
        day(th) = mean(aux2);
    end
    % Add column to table
    obj.BatteryFF_AggR.('BatteryFF_AggR') = day;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.BatteryFF_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg battery level of cars on street (FF) over time';
        eje_y = 'Battery level [%]';
        plotTableTime('BatteryFF_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableBatteryInTotalAggR
function tableBatteryInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with battery level aggregated by
    % zone+station at every hour (mean of 60min)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.BatteryTotal_AggR = table(Time);

    % Generate battery level aggregated by zone in every hour as mean of
    % 60min
    %
    day = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        for t=1:tf-ti
            % Battery level of cars in zone at time t
            aux2 = [];
            for izone=1:obj.MyCity.numFreeFloatZones
                listCars = obj.MyCity.vFreeFloatZones{izone}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.isElectric 
                        aux2(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel((th-1)*60+t);
                    end
                end

                % Battery level of cars in station (inside zone) at time t
                list_stat = obj.MyCity.vFreeFloatZones{izone}.listStations;
                for istat=1:size(list_stat,2)
                    listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{(th-1)*60+t};
                    numCars = size(listCars,2);
                    for iCar=1:numCars
                        if obj.MyCity.vCars{listCars(iCar)}.isElectric
                            aux2(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel((th-1)*60+t);
                        end
                    end
                end
            end
        end
        %
        day(th) = mean(aux2);
    end
    % Add column to table
    obj.BatteryTotal_AggR.('BatteryTotal_AggR') = day;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.BatteryTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg battery level of cars in the system (SB+FF) over time';
        eje_y = 'Battery level [%]';
        plotTableTime('BatteryTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableBatteryInStationSumm
function tableBatteryInStationSumm(obj)
    % Function to create table with battery level aggregated by station
    % and time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for t=1:TotalTime
        % Battery level of cars in station at time t
        aux = [];
        for istat=1:obj.MyCity.numStations
            listCars = obj.MyCity.vStations{istat}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.isElectric 
                    aux(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel(t);
                end
            end
        end
    end
    
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. battery level (SB)' 'Percentage' num2str(mean(aux),'%6.2f')}];
end

% tableBatteryInZoneSumm
function tableBatteryInZoneSumm(obj)
    % Function to create table with battery level aggregated by zone
    % and time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for t=1:TotalTime
        % Count number of cars in station at time t
        aux = [];
        for izone=1:obj.MyCity.numFreeFloatZones
            listCars = obj.MyCity.vFreeFloatZones{izone}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.isElectric
                    aux(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel(t);
                end
            end
        end
    end

    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. battery level (FF)' 'Percentage' num2str(mean(aux),'%6.2f')}];
end

% tableBatteryInTotalSumm
function tableBatteryInTotalSumm(obj)
    % Function to create table with battery level aggregated by
    % zone+station and time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for t=1:TotalTime
        % Battery level of cars in zone at time t
        aux = [];
        for izone=1:obj.MyCity.numFreeFloatZones
            listCars = obj.MyCity.vFreeFloatZones{izone}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.isElectric 
                    aux(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel(t);
                end
            end

            % Battery level of cars in station (inside zone) at time t
            list_stat = obj.MyCity.vFreeFloatZones{izone}.listStations;
            for istat=1:size(list_stat,2)
                listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.isElectric
                        aux(end+1) = obj.MyCity.vCars{listCars(iCar)}.batteryLevel(t);
                    end
                end
            end
        end
    end
        
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. battery level (SB+FF)' 'Percentage' num2str(mean(aux),'%6.2f')}];
end

