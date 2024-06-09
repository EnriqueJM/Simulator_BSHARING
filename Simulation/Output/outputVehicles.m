function outputVehicles(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj)
    % Function to generate results (tables & plots) about vehicles
    
    if param.verbose
        disp('');
        disp('CREATING VEHICLE TABLES');
    end
    
    % Create Vehicles folder
    [status, msg, msgID] = mkdir([pwd '/' folder],'Vehicles');
    if status == 0
        error('Error: Output folder could not be created');
    end
    
    xlsfile = [folder '/Vehicles/Tables_vehicles.xlsx'];            
    if isfile(xlsfile)
        delete(xlsfile);
    end

%%  %%%%%%%%%%%%%%%%%%%%%%
    %    HOURLY TABLES   % 
    %%%%%%%%%%%%%%%%%%%%%%
    if param.Hourly
        
        % CarsInStationTime
        if param.verbose
            disp('Creating table CarsInStationTime');
        end
        %
        sheet = 'CarsInStationTime';
        tableCarsInStationTime(param, xlsfile, sheet, thi, thf, StationI, StationF, obj);

        % CarsInZoneTime
        if param.verbose
            disp('Creating table CarsInZoneTime');
        end
        %
        sheet = 'CarsInZoneTime';
        tableCarsInZoneTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % CarsInTotalTime
        if param.verbose
            disp('Creating table CarsInTotalTime');
        end
        %
        sheet = 'CarsInTotalTime';
        tableCarsInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % CarStatusTime
        if param.verbose
            disp('Creating table CarsStatusTime');
        end
        %
        sheet = 'CarStatusTime';
        tableCarStatusTime(param, xlsfile, sheet, thi, thf, obj);
    end
    
%%  %%%%%%%%%%%%%%%%%%%%%%%%%
    %    TIME AGGREGATION   % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggT
        
        % CarsInStationAggT
        if param.verbose
            disp('Creating table CarsInStationAggT');
        end
        %
        sheet = 'CarsInStationAggT';
        tableCarsInStationAggT(param, xlsfile, sheet, StationI, StationF, obj);

        % CarsInZoneAggT
        if param.verbose
            disp('Creating table CarsInZoneAggT');
        end
        %
        sheet = 'CarsInZoneAggT';
        tableCarsInZoneAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);

        % CarsInTotalTime
        if param.verbose
            disp('Creating table CarsInTotalAggT');
        end
        %
        sheet = 'CarsInTotalAggT';
        tableCarsInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);

        % CarStatusAggT
        if param.verbose
            disp('Creating table CarsStatusAggT');
        end
        %
        sheet = 'CarStatusAggT';
        tableCarStatusAggT(param, xlsfile, sheet, obj);
    end

%%  %%%%%%%%%%%%%%%%%%%%%%%%%
    %   REGION AGGREGATION  % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggR
        
        % CarsInStationAggR
        if param.verbose
            disp('Creating table CarsInStationAggR');
        end
        %
        sheet = 'CarsInStationAggR';
        tableCarsInStationAggR(param, xlsfile, sheet, thi, thf, obj);

        % CarsInZoneAggR
        if param.verbose
            disp('Creating table CarsInZoneAggR');
        end
        %
        sheet = 'CarsInZoneAggR';
        tableCarsInZoneAggR(param, xlsfile, sheet, thi, thf, obj);

        % CarsInTotalAggR
        if param.verbose
            disp('Creating table CarsInTotalAggR');
        end
        %
        sheet = 'CarsInTotalAggR';
        tableCarsInTotalAggR(param, xlsfile, sheet, thi, thf, obj);
    end
    
%%  %%%%%%%%%%%%%%%
    %   SUMMARY   %
    %%%%%%%%%%%%%%%
    
    % CarsInStationSumm
    if param.verbose
        disp('Creating table CarsInStationSumm');
    end
    %
    tableCarsInStationSumm(obj);

    % CarsInZoneSumm
    if param.verbose
        disp('Creating table CarsInZoneSumm');
    end
    %
    tableCarsInZoneSumm(obj);

    % CarsInTotalSumm
    if param.verbose
        disp('Creating table CarsInTotalSumm');
    end
    %
    tableCarsInTotalSumm(obj);

    % CarsStatusSumm
    if param.verbose
        disp('Creating table CarsStatusSumm');
    end
    %
    tableCarStatusSumm(obj);

    % eCarsRechargingSumm
    if param.verbose
        disp('Creating table eCarsRechargingSumm');
    end
    %
    tableeCarsRechargingSumm(obj);
    
    % AvgTripsInTotalSumm
    if param.verbose
        disp('Creating table AvgTripsInTotalSumm');
    end
    %
    tableAvgTripsInTotalSumm(param, obj);

end

% tableCarsInStationTime
function tableCarsInStationTime(param, xlsfile, sheet, thi, thf, statI, statF, obj)
    % Function to create table with number of cars in every station
    % at every hour (mean of 60min)

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
    obj.CarsSB_dt = table(ID, Name);

    % Generate number of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux = zeros(statF-statI+1, tf-ti);
        %
        for t=1:tf-ti
            % Count number of cars in station at time t
            for istat=1:size(list_stat,2)
                listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0 % Free cars
                        aux(istat,t) = aux(istat,t) + 1;
                    end
                end
            end
        end

        % Add column to table
        obj.CarsSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux,2);
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarsSB_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg available fleet in stations (SB) per hour';
        unit_labl = '[vehicles]';
        plotTableStation('CarsSB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableCarsInZoneTime
function tableCarsInZoneTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with number of cars in every zone
    % at every hour (mean of 60min)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.CarsFF_dt = table(ID);

    % Generate number of cars per zone at every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux = zeros(zoneF-zoneI+1, tf-ti);
        %
        for t=1:tf-ti
            % Count number of cars in zone at time t
            for izone=1:size(list_zone,2)
                listCars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0 % Free cars
                        aux(izone,t) = aux(izone,t) + 1;
                    end
                end
            end
        end
            
         % Add column to table
        obj.CarsFF_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux,2);
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarsFF_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Avg available fleet on street (FF) per hour';
        unit_labl = '[vehicles]';
        plotTableZone('CarsFF_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableCarsInZoneTime
function tableCarsInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with number of cars in every zone + station
    % at every hour (mean of 60min)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.CarsTotal_dt = table(ID);

    % Generate number of cars per zone at every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux = zeros(zoneF-zoneI+1, tf-ti);
        %
        for t=1:tf-ti
            % Count number of cars in zone at time t
            for izone=1:size(list_zone,2)
                listCars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0 % Free cars
                        aux(izone,t) = aux(izone,t) + 1;
                    end
                end
            
                % Count number of cars in station (inside zone) at time t
                list_stat = obj.MyCity.vFreeFloatZones{list_zone(izone)}.listStations;
                for istat=1:size(list_stat,2)
                    listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{(th-1)*60+t};
                    numCars = size(listCars,2);
                    for iCar=1:numCars
                        if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0 % Free cars
                            aux(izone,t) = aux(izone,t) + 1;
                        end
                    end
                end
            end
        end
            
        % Add column to table
        obj.CarsTotal_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux,2);
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarsTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Avg available fleet in the system (SB+FF) per hour';
        unit_labl = '[vehicles]';
        plotTableZone('CarsTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableCarStatusTime
function tableCarStatusTime(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with number of cars per status at
    % every hour (mean of 60min)

    % Generate first column with status
    Status = {'Free'; 'Reserved'; 'On trip'; 'Repositioning'; 'Not enough battery'};
    obj.CarStatus_dt = table(Status);

    % Generate number of cars per status at every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux = zeros(size(Status,1), tf-ti);
        %
        for t=1:tf-ti

            % Count number of cars per status at time t
            for icar=1:obj.MyCity.numCars
                st = obj.MyCity.vCars{icar}.status((th-1)*60+t);
                aux(st+1,t) = aux(st+1,t) + 1;                             % Car status starts from 0 !!!
            end
        end

        % Add column to table
        obj.CarStatus_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux,2);
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarStatus_dt, xlsfile, 'Sheet', sheet);
    
    % Plot table graphically in pie chart
    if param.GeneratePlots
        titulo = 'Average car status share per hour';
        plotPieChart('CarStatus_dt', xlsfile, obj, titulo);
    end
end

% tableCarsInStationAggT
function tableCarsInStationAggT(param, xlsfile, sheet, statI, statF, obj)
    % Function to create table with number of cars in every station
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
    obj.CarsSB_AggT = table(ID, Name);

    % Generate number of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    aux = zeros(statF-statI+1, TotalTime);
    %
    for t=1:TotalTime
        % Count number of cars in station at time t
        for istat=1:size(list_stat,2)
            listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0 % Free cars
                    aux(istat,t) = aux(istat,t) + 1;
                end
            end
        end
    end

    % Add column to table
    obj.CarsSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux,2);
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarsSB_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg available fleet in stations (SB)';
        unit_labl = '[vehicles]';
        plotTableStation('CarsSB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableCarsInZoneAggT
function tableCarsInZoneAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with number of cars in every zone
    % (mean of Total Time)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.CarsFF_AggT = table(ID);

    % Generate number of cars per zone at every hour as mean of TotalTime
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = zeros(zoneF-zoneI+1, TotalTime);
    %
    for t=1:TotalTime
        % Count number of cars in zone at time t
        for izone=1:size(list_zone,2)
            listCars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0 % Free cars
                    aux(izone,t) = aux(izone,t) + 1;
                end
            end
        end
    end

     % Add column to table
    obj.CarsFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux,2);
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarsFF_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Avg available fleet on street (FF)';
        unit_labl = '[vehicles]';
        plotTableZone('CarsFF_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableCarsInZoneAggT
function tableCarsInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with number of cars in every zone + station
    % (mean of TotalTime)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.CarsTotal_AggT = table(ID);

    % Generate number of cars per zone at every hour as mean of TotalTime
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = zeros(zoneF-zoneI+1, TotalTime);
    %
    for t=1:TotalTime
        % Count number of cars in zone at time t
        for izone=1:size(list_zone,2)
            listCars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0 % Free cars
                    aux(izone,t) = aux(izone,t) + 1;
                end
            end

            % Count number of cars in station (inside zone) at time t
            list_stat = obj.MyCity.vFreeFloatZones{list_zone(izone)}.listStations;
            for istat=1:size(list_stat,2)
                listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0 % Free cars
                        aux(izone,t) = aux(izone,t) + 1;
                    end
                end
            end
        end
    end

    % Add column to table
    obj.CarsTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux,2);
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarsTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Avg available fleet in the system (SB+FF)';
        unit_labl = '[vehicles]';
        plotTableZone('CarsTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableCarStatusAggT
function tableCarStatusAggT(param, xlsfile, sheet, obj)
    % Function to create table with number of cars per status (mean of Total Time)

    % Generate first column with status
    Status = {'Free'; 'Reserved'; 'On trip'; 'Repositioning'; 'Not enough battery'};
    obj.CarStatus_AggT = table(Status);

    % Generate number of cars per status at every hour as mean of
    % TotalTime
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = zeros(size(Status,1), TotalTime);
    %
    for t=1:TotalTime

        % Count number of cars per status at time t
        for icar=1:obj.MyCity.numCars
            st = obj.MyCity.vCars{icar}.status(t);
            aux(st+1,t) = aux(st+1,t) + 1;                             % Car status starts from 0 !!!
        end
    end

    % Add column to table
    obj.CarStatus_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux,2);
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarStatus_AggT, xlsfile, 'Sheet', sheet);
    
    % Plot table graphically in pie chart
    if param.GeneratePlots
        titulo = 'Average car status share';
        plotPieChart('CarStatus_AggT', xlsfile, obj, titulo);
    end
end

% tableCarsInStationAggR
function tableCarsInStationAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with number of cars aggregated by station
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
    obj.CarsSB_AggR = table(Time);

    % Generate number of cars aggregated by station in every hour as mean of
    % 60min
    %
    day = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux = zeros(tf-ti, 1);
        %
        for t=1:tf-ti
            % Count number of cars in station at time t
            for istat=1:obj.MyCity.numStations
                listCars = obj.MyCity.vStations{istat}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0 % Free cars
                        aux(t) = aux(t) + 1;
                    end
                end
            end
        end
        %
        day(th) = mean(aux);
    end
    % Add column to table
    obj.CarsSB_AggR.('CarsSB_AggR') = day;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarsSB_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg available fleet in stations (SB) over time';
        eje_y = 'Number of available cars [vehicles]';
        plotTableTime('CarsSB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableCarsInZoneAggR
function tableCarsInZoneAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with number of cars aggregated by zone
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
    obj.CarsFF_AggR = table(Time);

    % Generate number of cars aggregated by zone in every hour as mean of
    % 60min
    %
    day = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux = zeros(tf-ti, 1);
        %
        for t=1:tf-ti
            % Count number of cars in station at time t
            for izone=1:obj.MyCity.numFreeFloatZones
                listCars = obj.MyCity.vFreeFloatZones{izone}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0 % Free cars
                        aux(t) = aux(t) + 1;
                    end
                end
            end
        end
        %
        day(th) = mean(aux);
    end
    % Add column to table
    obj.CarsFF_AggR.('CarsFF_AggR') = day;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarsFF_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg available fleet on street (FF) over time';
        eje_y = 'Number of available cars [vehicles]';
        plotTableTime('CarsFF_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableCarsInTotalAggR
function tableCarsInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with number of total cars aggregated by zone
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
    obj.CarsTotal_AggR = table(Time);

    % Generate number of total cars aggregated by zone in every hour as mean of
    % 60min
    %
    day = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux = zeros(tf-ti, 1);
        %
        for t=1:tf-ti
            % Count number of cars in station at time t
            for izone=1:obj.MyCity.numFreeFloatZones
                listCars = obj.MyCity.vFreeFloatZones{izone}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0 % Free cars
                        aux(t) = aux(t) + 1;
                    end
                end

                % Count number of cars in station (inside zone) at time t
                list_stat = obj.MyCity.vFreeFloatZones{izone}.listStations;
                for istat=1:size(list_stat,2)
                    listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{(th-1)*60+t};
                    numCars = size(listCars,2);
                    for iCar=1:numCars
                        if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0 % Free cars
                            aux(t) = aux(t) + 1;
                        end
                    end
                end
            end
        end
        %
        day(th) = mean(aux);
    end
    % Add column to table
    obj.CarsTotal_AggR.('CarsTotal_AggR') = day;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.CarsTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Avg available fleet in the system (SB+FF) over time';
        eje_y = 'Number of available cars [vehicles]';
        plotTableTime('CarsTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableCarsInStationSumm
function tableCarsInStationSumm(obj)
    % Function to create table with number of cars aggregated by station
    % and time

    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = zeros(TotalTime, 1);
    %
    for t=1:TotalTime
        % Count number of cars in station at time t
        for istat=1:obj.MyCity.numStations
            listCars = obj.MyCity.vStations{istat}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0 % Free cars
                    aux(t) = aux(t) + 1;
                end
            end
        end
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg available fleet (SB)' 'Cars' num2str(mean(aux),'%6.2f')}];
end

% tableCarsInZoneSumm
function tableCarsInZoneSumm(obj)
    % Function to create table with number of cars aggregated by zone
    % and time

    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = zeros(TotalTime, 1);
    %
    for t=1:TotalTime
        % Count number of cars in station at time t
        for izone=1:obj.MyCity.numFreeFloatZones
            listCars = obj.MyCity.vFreeFloatZones{izone}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0 % Free cars
                    aux(t) = aux(t) + 1;
                end
            end
        end
    end
    % Add column to table
    obj.Summary = [obj.Summary; {'Avg available fleet (FF)' 'Cars' num2str(mean(aux),'%6.2f')}];
end

% tableCarsInTotalSumm
function tableCarsInTotalSumm(obj)
    % Function to create table with number of total cars aggregated by zone
    % and time

    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = zeros(TotalTime, 1);
    %
    for t=1:TotalTime
        % Count number of cars in station at time t
        for izone=1:obj.MyCity.numFreeFloatZones
            listCars = obj.MyCity.vFreeFloatZones{izone}.vlistCars{t};
            numCars = size(listCars,2);
            for iCar=1:numCars
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0 % Free cars
                    aux(t) = aux(t) + 1;
                end
            end

            % Count number of cars in station (inside zone) at time t
            list_stat = obj.MyCity.vFreeFloatZones{izone}.listStations;
            for istat=1:size(list_stat,2)
                listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0 % Free cars
                        aux(t) = aux(t) + 1;
                    end
                end
            end
        end
    end
    % Add column to table
    obj.Summary = [obj.Summary; {'Avg available fleet (SB+FF)' 'Cars' num2str(mean(aux),'%6.2f')}];
end

% tableCarStatusSumm
function tableCarStatusSumm(obj)
    % Function to create table with number of cars per status
    Status = {'Free'; 'Reserved'; 'On trip'; 'Repositioning'; 'Not enough battery'};
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    aux = zeros(size(Status,1), TotalTime);
    %
    for t=1:TotalTime
        % Count number of cars per status at time t
        for icar=1:obj.MyCity.numCars
            st = obj.MyCity.vCars{icar}.status(t);
            aux(st+1,t) = aux(st+1,t) + 1;                             % Car status starts from 0 !!!
        end
    end
    % Add column to table
    auxx = mean(aux,2);
    totalCars = sum(auxx);
    for istat=1:size(Status,1)
        obj.Summary = [obj.Summary; {['Car status - ' Status{istat}] 'Percentage' num2str(100*auxx(istat)/totalCars,'%6.2f')}];
    end
end

% tableeCarsRechargingSumm
function tableeCarsRechargingSumm(obj)
    % Function to create table with ecars recharging
    eCars = 0;
    for icar=1:obj.MyCity.numCars
        if obj.MyCity.vCars{icar}.isElectric
            eCars = eCars + 1;
        end
    end
    %
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    TotalTime_eCars = TotalTime * eCars;
    %
    aux = 0;
    for t=1:TotalTime
        % Count number of ecars recharging at time t
        for istat=1:obj.MyCity.numStations
            aux = aux + size(obj.MyCity.vStations{istat}.vlistCharging{t},2);
        end
    end
    %
    % Add column to table
    obj.Summary = [obj.Summary; {'eCars - Recharging' 'Percentage' num2str(100*aux/TotalTime_eCars,'%6.2f')}];
end

% tableAvgTripsInTotalSumm
function tableAvgTripsInTotalSumm(param, obj)
    % Function to create table with average access time
    % in every zone from stations+zones aggregated by region and time (sum)

    % Generate avg access time
    aux1 = 0; % Distance
    aux2 = 0; % Number of trips
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        tO2Car = obj.MyCity.vFinishedUsers{iusr}.tO2Car;   % Time when user takes the car
        tTrip = obj.MyCity.vFinishedUsers{iusr}.tTrip;     % Time when user ends driving
        %
        % Trip time = Time when user arrives at parking - Time of taking car
        trip = tTrip - tO2Car;
        %
        aux1 = aux1 + trip*param.CarSpeed/60;
        aux2 = aux2 + 1;
    end
    
    aux1 = aux1/60;
    aux2 = aux2/60;
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg distance travelled' 'km/veh·h' num2str(aux1/obj.MyCity.numCars,'%8.2f')}];
    obj.Summary = [obj.Summary; {'Avg number of trips served' 'Trips/veh·h' num2str(aux2/obj.MyCity.numCars,'%8.2f')}];
end

