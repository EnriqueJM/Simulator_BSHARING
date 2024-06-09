function outputUnbalance(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj)
    % Function to generate results (tables & plots) about unbalance of cars
    
    if param.verbose
        disp('');
        disp('CREATING UNBALANCE TABLES');
    end
    
    % Create Vehicles folder
    [status, msg, msgID] = mkdir([pwd '/' folder],'Unbalance');
    if status == 0
        error('Error: Output folder could not be created');
    end
    
    xlsfile = [folder '/Unbalance/Tables_unbalance.xlsx'];            
    if isfile(xlsfile)
        delete(xlsfile);
    end

    %%%%%%%%%%%%%%%%%%%%%%
    %    HOURLY TABLES   % 
    %%%%%%%%%%%%%%%%%%%%%%
    if param.Hourly
        
        % UnbalanceCarsInStationTime
        if param.verbose
            disp('Creating table UnbalanceCarsInStationTime');
        end
        %
        sheet = 'UnbalanceCarsInStationTime';
        tableUnbalanceCarsInStationTime(param, xlsfile, sheet, thi, thf, StationI, StationF, obj);

        % UnbalanceCarsInZoneTime
        if param.verbose
            disp('Creating table UnbalanceCarsInZoneTime');
        end
        %
        sheet = 'UnbalanceCarsInZoneTime';
        tableUnbalanceCarsInZoneTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % UnbalanceCarsInTotalTime
        if param.verbose
            disp('Creating table UnbalanceCarsInTotalTime');
        end
        %
        sheet = 'UnbalanceCarsInTotalTime';
        tableUnbalanceCarsInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %    TIME AGGREGATION   % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggT
        
         % UnbalanceCarsInStationAggT
         if param.verbose
             disp('Creating table UnbalanceCarsInStationAggT');
         end
         %
         sheet = 'UnbalanceCarsInStationAggT';
         tableUnbalanceCarsInStationAggT(param, xlsfile, sheet, StationI, StationF, obj);

         % UnbalanceCarsInZoneAggT
         if param.verbose
             disp('Creating table UnbalanceCarsInZoneAggT');
         end
         %
         sheet = 'UnbalanceCarsInZoneAggT';
         tableUnbalanceCarsInZoneAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);

         % UnbalanceCarsInTotalTime
         if param.verbose
             disp('Creating table UnbalanceCarsInTotalAggT');
         end
         %
         sheet = 'UnbalanceCarsInTotalAggT';
         tableUnbalanceCarsInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %   REGION AGGREGATION  % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggR
        
         % UnbalanceCarsInStationAggR
         if param.verbose
             disp('Creating table UnbalanceCarsInStationAggR');
         end
         %
         sheet = 'UnbalanceCarsInStationAggR';
         tableUnbalanceCarsInStationAggR(param, xlsfile, sheet, thi, thf, obj);

         % UnbalanceCarsInZoneAggR
         if param.verbose
             disp('Creating table UnbalanceCarsInZoneAggR');
         end
         %
         sheet = 'UnbalanceCarsInZoneAggR';
         tableUnbalanceCarsInZoneAggR(param, xlsfile, sheet, thi, thf, obj);

         % UnbalanceCarsInTotalAggR
         if param.verbose
             disp('Creating table UnbalanceCarsInTotalAggR');
         end
         %
         sheet = 'UnbalanceCarsInTotalAggR';
         tableUnbalanceCarsInTotalAggR(param, xlsfile, sheet, thi, thf, obj);
    end
    
    %%%%%%%%%%%%%
    %  SUMMARY  %
    %%%%%%%%%%%%%
        
     % UnbalanceCarsInStationSumm
     if param.verbose
         disp('Creating table UnbalanceCarsInStationSumm');
     end
     %
     tableUnbalanceCarsInStationSumm(obj);

     % UnbalanceCarsInZoneSumm
     if param.verbose
         disp('Creating table UnbalanceCarsInZoneSumm');
     end
     %
     tableUnbalanceCarsInZoneSumm(obj);

     % UnbalanceCarsInTotalSumm
     if param.verbose
         disp('Creating table UnbalanceCarsInTotalSumm');
     end
     %
     tableUnbalanceCarsInTotalSumm(obj);

end

% tableUnbalanceCarsInStationTime
function tableUnbalanceCarsInStationTime(param, xlsfile, sheet, thi, thf, statI, statF, obj)
    % Function to create table with unbalance of cars in every station
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
    obj.UnbalanceCarsSB_dt = table(ID, Name);

    % Generate unbalance of cars per station in every hour as mean of
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
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0
                        aux(istat,t) = aux(istat,t) + 1;
                    end
                end
                % Substract optimal number of cars
                aux(istat,t) = aux(istat,t) - obj.MyCity.vStations{list_stat(istat)}.optCars((th-1)*60+t);
            end
        end

        % Add column to table
        obj.UnbalanceCarsSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux,2);
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.UnbalanceCarsSB_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo ='Average deviation from optimal station inventory level per hour (positive = excess of cars)';
        unit_labl = '[vehicles]';
        plotTableStation('UnbalanceCarsSB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableUnbalanceCarsInZoneTime
function tableUnbalanceCarsInZoneTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with unbalance of cars in every zone
    % at every hour (mean of 60min)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.UnbalanceCarsFF_dt = table(ID);

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
            % Count unbalance of cars in zone at time t
            for izone=1:size(list_zone,2)
                listCars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0
                        aux(izone,t) = aux(izone,t) + 1;
                    end
                end
                % Substract optimal number of cars
                aux(izone,t) = aux(izone,t) - obj.MyCity.vFreeFloatZones{list_zone(izone)}.optCars((th-1)*60+t);
            end
        end
            
         % Add column to table
        obj.UnbalanceCarsFF_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux,2);
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.UnbalanceCarsFF_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo ='Average deviation from optimal on-street inventory level per hour (positive = excess of cars)';
        unit_labl = '[vehicles]';
        plotTableZone('UnbalanceCarsFF_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableUnbalanceCarsInTotalTime
function tableUnbalanceCarsInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with unbalance of cars in every zone + station
    % at every hour (mean of 60min)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.UnbalanceCarsTotal_dt = table(ID);

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
            % Count unbalance of cars in zone at time t
            for izone=1:size(list_zone,2)
                listCars = obj.MyCity.vFreeFloatZones{list_zone(izone)}.vlistCars{(th-1)*60+t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0
                        aux(izone,t) = aux(izone,t) + 1;
                    end
                end
                % Substract optimal number of cars
                aux(izone,t) = aux(izone,t) - obj.MyCity.vFreeFloatZones{list_zone(izone)}.optCars((th-1)*60+t);
            
                % Count unbalance of cars in station (inside zone) at time t
                list_stat = obj.MyCity.vFreeFloatZones{list_zone(izone)}.listStations;
                for istat=1:size(list_stat,2)
                    listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{(th-1)*60+t};
                    numCars = size(listCars,2);
                    for iCar=1:numCars
                        if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0
                            aux(izone,t) = aux(izone,t) + 1;
                        end
                    end
                    % Substract optimal number of cars
                    aux(izone,t) = aux(izone,t) - obj.MyCity.vStations{list_stat(istat)}.optCars((th-1)*60+t);
                end
            end
        end
            
        % Add column to table
        obj.UnbalanceCarsTotal_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux,2);
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.UnbalanceCarsTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo ='Average deviation from optimal inventory level per hour (positive = excess of cars)';
        unit_labl = '[vehicles]';
        plotTableZone('UnbalanceCarsTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableUnbalanceCarsInStationAggT
function tableUnbalanceCarsInStationAggT(param, xlsfile, sheet, statI, statF, obj)
    % Function to create table with unbalance of cars in every station
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
    obj.UnbalanceCarsSB_AggT = table(ID, Name);

    % Generate unbalance of cars per station in every hour as mean of
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
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0
                    aux(istat,t) = aux(istat,t) + 1;
                end
            end
            % Substract optimal number of cars
            aux(istat,t) = aux(istat,t) - obj.MyCity.vStations{list_stat(istat)}.optCars(t);
        end
    end

    % Add column to table
    obj.UnbalanceCarsSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux,2);
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.UnbalanceCarsSB_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo ='Average deviation from optimal station inventory level (positive = excess of cars)';
        unit_labl = '[vehicles]';
        plotTableStation('UnbalanceCarsSB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableUnbalanceCarsInZoneAggT
function tableUnbalanceCarsInZoneAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with unbalance of cars in every zone
    % (mean of Total Time)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.UnbalanceCarsFF_AggT = table(ID);

    % Generate unbalance of cars per zone at every hour as mean of TotalTime
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
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0
                    aux(izone,t) = aux(izone,t) + 1;
                end
            end
            % Substract optimal number of cars
            aux(izone,t) = aux(izone,t) - obj.MyCity.vFreeFloatZones{list_zone(izone)}.optCars(t);
        end
    end

     % Add column to table
    obj.UnbalanceCarsFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux,2);
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.UnbalanceCarsFF_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo ='Average deviation from optimal on-street inventory level (positive = excess of cars)';
        unit_labl = '[vehicles]';
        plotTableZone('UnbalanceCarsFF_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableUnbalanceCarsInZoneAggT
function tableUnbalanceCarsInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with unbalance of cars in every zone + station
    % (mean of TotalTime)

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.UnbalanceCarsTotal_AggT = table(ID);

    % Generate unbalance of cars per zone at every hour as mean of TotalTime
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
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0
                    aux(izone,t) = aux(izone,t) + 1;
                end
            end
            % Substract optimal number of cars
            aux(izone,t) = aux(izone,t) - obj.MyCity.vFreeFloatZones{list_zone(izone)}.optCars(t);

            % Count number of cars in station (inside zone) at time t
            list_stat = obj.MyCity.vFreeFloatZones{list_zone(izone)}.listStations;
            for istat=1:size(list_stat,2)
                listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0
                        aux(izone,t) = aux(izone,t) + 1;
                    end
                end
                % Substract optimal number of cars
                aux(izone,t) = aux(izone,t) - obj.MyCity.vStations{list_stat(istat)}.optCars(t);
            end
        end
    end

    % Add column to table
    obj.UnbalanceCarsTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux,2);
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.UnbalanceCarsTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo ='Average deviation from optimal inventory level (positive = excess of cars)';
        unit_labl = '[vehicles]';
        plotTableZone('UnbalanceCarsTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableUnbalanceCarsInStationAggR
function tableUnbalanceCarsInStationAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with unbalance of cars aggregated by station
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
    obj.UnbalanceCarsSB_AggR = table(Time);

    % Generate unbalance of cars aggregated by station in every hour as mean of
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
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0
                        aux(t) = aux(t) + 1;
                    end
                end
                % Substract optimal number of cars
                aux(t) = aux(t) - obj.MyCity.vStations{istat}.optCars((th-1)*60+t);
            end
        end
        %
        day(th) = mean(aux);
    end
    % Add column to table
    obj.UnbalanceCarsSB_AggR.('UnbalanceCarsSB_AggR') = day;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.UnbalanceCarsSB_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo ='Average deviation from optimal station inventory level';
        eje_y = 'Deviation (positive = excess of cars) [vehicles]';
        plotTableTime('UnbalanceCarsSB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableUnbalanceCarsInZoneAggR
function tableUnbalanceCarsInZoneAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with unbalance of cars aggregated by zone
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
    obj.UnbalanceCarsFF_AggR = table(Time);

    % Generate unbalance of cars aggregated by zone in every hour as mean of
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
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0
                        aux(t) = aux(t) + 1;
                    end
                end
                % Substract optimal number of cars
                aux(t) = aux(t) - obj.MyCity.vFreeFloatZones{izone}.optCars((th-1)*60+t);
            end
        end
        %
        day(th) = mean(aux);
    end
    % Add column to table
    obj.UnbalanceCarsFF_AggR.('UnbalanceCarsFF_AggR') = day;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.UnbalanceCarsFF_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo ='Average deviation from optimal on-street inventory level';
        eje_y = 'Deviation (positive = excess of cars) [vehicles]';
        plotTableTime('UnbalanceCarsFF_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableUnbalanceCarsInTotalAggR
function tableUnbalanceCarsInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
    % Function to create table with unbalance of total cars aggregated by zone
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
    obj.UnbalanceCarsTotal_AggR = table(Time);

    % Generate unbalance of total cars aggregated by zone in every hour as mean of
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
                    if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0
                        aux(t) = aux(t) + 1;
                    end
                end
                % Substract optimal number of cars
                aux(t) = aux(t) - obj.MyCity.vFreeFloatZones{izone}.optCars((th-1)*60+t);

                % Count number of cars in station (inside zone) at time t
                list_stat = obj.MyCity.vFreeFloatZones{izone}.listStations;
                for istat=1:size(list_stat,2)
                    listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{(th-1)*60+t};
                    numCars = size(listCars,2);
                    for iCar=1:numCars
                        if obj.MyCity.vCars{listCars(iCar)}.status((th-1)*60+t) == 0
                            aux(t) = aux(t) + 1;
                        end
                    end
                    % Substract optimal number of cars
                    aux(t) = aux(t) - obj.MyCity.vStations{list_stat(istat)}.optCars((th-1)*60+t);
                end
            end
        end
        %
        day(th) = mean(aux);
    end
    % Add column to table
    obj.UnbalanceCarsTotal_AggR.('UnbalanceCarsTotal_AggR') = day;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.UnbalanceCarsTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo ='Average deviation from optimal inventory level';
        eje_y = 'Deviation (positive = excess of cars) [vehicles]';
        plotTableTime('UnbalanceCarsTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableUnbalanceCarsInStationSumm
function tableUnbalanceCarsInStationSumm(obj)
    % Function to create table with unbalance of cars aggregated by station
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
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0
                    aux(t) = aux(t) + 1;
                end
            end
            % Substract optimal number of cars
            aux(t) = aux(t) - obj.MyCity.vStations{istat}.optCars(t);
        end
    end
        
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. deviation from optimum (SB)' 'Cars' num2str(mean(aux),'%6.2f')}];
end

% tableUnbalanceCarsInZoneSumm
function tableUnbalanceCarsInZoneSumm(obj)
    % Function to create table with unbalance of cars aggregated by zone
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
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0
                    aux(t) = aux(t) + 1;
                end
            end
            % Substract optimal number of cars
            aux(t) = aux(t) - obj.MyCity.vFreeFloatZones{izone}.optCars(t);
        end
    end
    
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. deviation from optimum (FF)' 'Cars' num2str(mean(aux),'%6.2f')}];
end

% tableUnbalanceCarsInTotalSumm
function tableUnbalanceCarsInTotalSumm(obj)
    % Function to create table with unbalance of total cars aggregated by zone
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
                if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0
                    aux(t) = aux(t) + 1;
                end
            end
            % Substract optimal number of cars
            aux(t) = aux(t) - obj.MyCity.vFreeFloatZones{izone}.optCars(t);

            % Count number of cars in station (inside zone) at time t
            list_stat = obj.MyCity.vFreeFloatZones{izone}.listStations;
            for istat=1:size(list_stat,2)
                listCars = obj.MyCity.vStations{list_stat(istat)}.vlistCars{t};
                numCars = size(listCars,2);
                for iCar=1:numCars
                    if obj.MyCity.vCars{listCars(iCar)}.status(t) == 0
                        aux(t) = aux(t) + 1;
                    end
                end
                % Substract optimal number of cars
                aux(t) = aux(t) - obj.MyCity.vStations{list_stat(istat)}.optCars(t);
            end
        end
    end
    
     % Add row to table
    obj.Summary = [obj.Summary; {'Avg. deviation from optimum (SB+FF)' 'Cars' num2str(mean(aux),'%6.2f')}];
end

