function outputUserLOS_reduced(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj)
    % Function to generate results (tables & plots) about demand
    
    if param.verbose
        disp('');
        disp('CREATING USER LEVEL OF SERVICE TABLES');
    end
    
    % Create Vehicles folder
    [status, msg, msgID] = mkdir([pwd '/' folder],'User_LOS');
    if status == 0
        error('Error: Output folder could not be created');
    end
    
    xlsfile = [folder '/User_LOS/Tables_userLOS.xlsx'];
    if isfile(xlsfile)
        delete(xlsfile);
    end

    %%%%%%%%%%%%%%%%%%%%%%
    %    HOURLY TABLES   % 
    %%%%%%%%%%%%%%%%%%%%%%
    if param.Hourly

        % DemandLostInTotalTime
        if param.verbose
            disp('Creating table DemandLostInTotalTime');
        end
        %
        sheet1 = 'DemandLostOrigInTotalTime';
        sheet2 = 'DemandLostDestInTotalTime';
        tableDemandLostInTotalTime(param, xlsfile, sheet1, sheet2, thi, thf, ZoneI, ZoneF, obj);

        % AvgAccessInTotalTime
        if param.verbose
            disp('Creating table DestinationFullInTotalTime');
        end
        %
        sheet = 'DestinationFullInTotalTime';
        tableDestinationFullInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % AvgTripIncreaseInTotalTime
        if param.verbose
            disp('Creating table AvgTripIncreaseInTotalTime');
        end
        %
        sheet = 'AvgTripIncreaseInTotalTime';
        tableAvgTripIncreaseInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);

        % FareTripsInTotalTime
        if param.verbose
            disp('Creating table AvgDistIncreaseInTotalTime');
        end
        %
        sheet = 'AvgDistIncreaseInTotalTime';
        tableAvgDistIncreaseInTotalTime(param, xlsfile, sheet, thi, thf, ZoneI, ZoneF, obj);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %    TIME AGGREGATION   % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggT

        % DemandLostInTotalAggT
        if param.verbose
            disp('Creating table DemandLostInTotalAggT');
        end
        %
        sheet1 = 'DemandLostOrigInTotalAggT';
        sheet2 = 'DemandLostDestInTotalAggT';
        tableDemandLostInTotalAggT(param, xlsfile, sheet1, sheet2, ZoneI, ZoneF, obj);

        % AvgAccessInTotalAggT
        if param.verbose
            disp('Creating table DestinationFullInTotalAggT');
        end
        %
        sheet = 'DestinationFullInTotalAggT';
        tableDestinationFullInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);

        % AvgTripIncreaseInTotalAggT
        if param.verbose
            disp('Creating table AvgTripIncreaseInTotalAggT');
        end
        %
        sheet = 'AvgTripIncreaseInTotalAggT';
        tableAvgTripIncreaseInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);

        % FareTripsInTotalAggT
        if param.verbose
            disp('Creating table AvgDistIncreaseInTotalAggT');
        end
        %
        sheet = 'AvgDistIncreaseInTotalAggT';
        tableAvgDistIncreaseInTotalAggT(param, xlsfile, sheet, ZoneI, ZoneF, obj);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %   REGION AGGREGATION  % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggR
        
        % DemandLostInTotalAggR
        if param.verbose
            disp('Creating table DemandLostInTotalAggR');
        end
        %
        sheet1 = 'DemandLostOrigInTotalAggR';
        sheet2 = 'DemandLostDestInTotalAggR';
        tableDemandLostInTotalAggR(param, xlsfile, sheet1, sheet2, thi, thf, obj);

        % DestinationFullInTotalAggR
        if param.verbose
            disp('Creating table DestinationFullInTotalAggR');
        end
        %
        sheet = 'DestinationFullInTotalAggR';
        tableDestinationFullInTotalAggR(param, xlsfile, sheet, thi, thf, obj);

        % AvgTripIncreaseInTotalAggR
        if param.verbose
            disp('Creating table AvgTripIncreaseInTotalAggR');
        end
        %
        sheet = 'AvgTripIncreaseInTotalAggR';
        tableAvgTripIncreaseInTotalAggR(param, xlsfile, sheet, thi, thf, obj);
        
        % AvgDistIncreaseInTotalAggR
        if param.verbose
            disp('Creating table AvgDistIncreaseInTotalAggR');
        end
        %
        sheet = 'AvgDistIncreaseInTotalAggR';
        tableAvgDistIncreaseInTotalAggR(param, xlsfile, sheet, thi, thf, obj);
    end

    %%%%%%%%%%%%%
    %  SUMMARY  %
    %%%%%%%%%%%%%
    
    % DemandLostInTotalSumm
    if param.verbose
        disp('Creating table DemandLostInTotalSumm');
    end
    %
    tableDemandLostInTotalSumm(obj);

    % DestinationFullInTotalSumm
    if param.verbose
        disp('Creating table DestinationFullInTotalSumm');
    end
    %
    tableDestinationFullInTotalSumm(obj);

    % AvgTripIncreaseInTotalSumm
    if param.verbose
        disp('Creating table AvgTripIncreaseInTotalSumm');
    end
    %
    tableAvgTripIncreaseInTotalSumm(param, obj);

    % AvgDistIncreaseInTotalSumm
    if param.verbose
        disp('Creating table AvgDistIncreaseInTotalSumm');
    end
    %
    tableAvgDistIncreaseInTotalSumm(param, obj);
    
    % RepoUtilitiesInTotalSumm
    if param.verbose
        disp('Creating table RepoUtilitiesInTotalSumm');
    end
    %
    tableRepoUtilitiesInTotalSumm(param, obj)

end

% tableDemandLostInTotalTime
function tableDemandLostInTotalTime(param, xlsfile, sheet1, sheet2, thi, thf, zoneI, zoneF, obj)
    % Function to create tables with origin/destination demand
    % from/to station+zones in every zone at every hour (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.DemandLostOrigZoneTotal_dt = table(ID);
    obj.DemandLostDestZoneTotal_dt = table(ID);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    Orig = zeros(zoneF-zoneI+1, TotalTime);
    Dest = zeros(zoneF-zoneI+1, TotalTime);
    TotO = zeros(zoneF-zoneI+1, TotalTime);
    TotD = zeros(zoneF-zoneI+1, TotalTime);
    %
    %%% Total Users
    for iusr=1:numel(obj.MyCity.vFinishedUsers)
        t = obj.MyCity.vFinishedUsers{iusr}.tCreation;
        if t>0
            ZoneO = obj.MyCity.vFinishedUsers{iusr}.ZoneO;
            k1 = find(list_zone==ZoneO);
            TotO(k1,t) = TotO(k1,t) + 1;
            
            ZoneD = obj.MyCity.vFinishedUsers{iusr}.ZoneD;
            k2 = find(list_zone==ZoneD);
            TotD(k2,t) = TotD(k2,t) + 1;
        end        
    end
    for iusr=1:numel(obj.MyCity.vUsers)
        t = obj.MyCity.vUsers{iusr}.tCreation;
        if t>0
            ZoneO = obj.MyCity.vUsers{iusr}.ZoneO;
            k1 = find(list_zone==ZoneO);
            TotO(k1,t) = TotO(k1,t) + 1;
            
            ZoneD = obj.MyCity.vUsers{iusr}.ZoneD;
            k2 = find(list_zone==ZoneD);
            TotD(k2,t) = TotD(k2,t) + 1;
        end        
    end
    
    %%% Dead Users
    users_dead = obj.MyCity.notServicedUsers;
    for iusr=1:size(users_dead,1)
        t = users_dead(iusr,6); % Creation time
        if users_dead(iusr,5) > 0                                          % Has station on destination
                                                                           % The user didn't find car at origin
            k = find(list_zone==users_dead(iusr,1)); % ZoneO
            Orig(k,t) = Orig(k,t) + 1;
            TotO(k,t) = TotO(k,t) + 1;
        else                                                               % The user has no station on destination
                                                                           % Trip lost due to lack of coverage
            k = find(list_zone==users_dead(iusr,2)); % ZoneD
            Dest(k,t) = Dest(k,t) + 1;
            TotD(k,t) = TotD(k,t) + 1;
        end
    end
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux1 = sum(Orig(:,ti:tf),2)/sum(TotO(:,ti:tf),2)*100;
        aux1(isnan(aux1)) = 0;
        aux2 = sum(Dest(:,ti:tf),2)/sum(TotD(:,ti:tf),2)*100;
        aux2(isnan(aux2)) = 0;

        % Add column to table
        obj.DemandLostOrigZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux1;
        obj.DemandLostDestZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandLostOrigZoneTotal_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandLostDestZoneTotal_dt, xlsfile, 'Sheet', sheet2);

    % Plot table graphically by zones
    if param.GeneratePlots
        unit_labl = '[%]';
        titulo = 'Trips lost due to lack of vehicles per zone and hour (SB+FF)';
        plotTableZone('DemandLostOrigZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Trips lost due to lack of coverage per zone and hour (SB+FF)';
        plotTableZone('DemandLostDestZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDemandLostInTotalAggT
function tableDemandLostInTotalAggT(param, xlsfile, sheet1, sheet2, zoneI, zoneF, obj)
    % Function to create tables with origin/destination demand
    % from/to station+zones in every zone aggregated by time (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.DemandLostOrigZoneTotal_AggT = table(ID);
    obj.DemandLostDestZoneTotal_AggT = table(ID);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    Orig = zeros(zoneF-zoneI+1, TotalTime);
    Dest = zeros(zoneF-zoneI+1, TotalTime);
    TotO = zeros(zoneF-zoneI+1, TotalTime);
    TotD = zeros(zoneF-zoneI+1, TotalTime);
    %
    %%% Total Users
    for iusr=1:numel(obj.MyCity.vFinishedUsers)
        t = obj.MyCity.vFinishedUsers{iusr}.tCreation;
        if t>0
            ZoneO = obj.MyCity.vFinishedUsers{iusr}.ZoneO;
            k1 = find(list_zone==ZoneO);
            TotO(k1,t) = TotO(k1,t) + 1;
            
            ZoneD = obj.MyCity.vFinishedUsers{iusr}.ZoneD;
            k2 = find(list_zone==ZoneD);
            TotD(k2,t) = TotD(k2,t) + 1;
        end        
    end
    for iusr=1:numel(obj.MyCity.vUsers)
        t = obj.MyCity.vUsers{iusr}.tCreation;
        if t>0
            ZoneO = obj.MyCity.vUsers{iusr}.ZoneO;
            k1 = find(list_zone==ZoneO);
            TotO(k1,t) = TotO(k1,t) + 1;
            
            ZoneD = obj.MyCity.vUsers{iusr}.ZoneD;
            k2 = find(list_zone==ZoneD);
            TotD(k2,t) = TotD(k2,t) + 1;
        end        
    end

    users_dead = obj.MyCity.notServicedUsers;
    for iusr=1:size(users_dead,1)
        t = users_dead(iusr,6); % Creation time
        if users_dead(iusr,5) > 0                                          % Has station on destination
                                                                           % The user didn't find car at origin
            k = find(list_zone==users_dead(iusr,1)); % ZoneO
            Orig(k,t) = Orig(k,t) + 1;
            TotO(k1,t) = TotO(k1,t) + 1;
        else                                                               % The user has no station on destination
                                                                           % Trip lost due to lack of coverage
            k = find(list_zone==users_dead(iusr,2)); % ZoneD
            Dest(k,t) = Dest(k,t) + 1;
            TotD(k2,t) = TotD(k2,t) + 1;
        end
    end
    aux1 = sum(Orig,2)/sum(TotO,2)*100;
    aux1(isnan(aux1)) = 0;
    aux2 = sum(Dest,2)/sum(TotD,2)*100;
    aux2(isnan(aux2)) = 0;
    %
    % Add column to table
    obj.DemandLostOrigZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1;
    obj.DemandLostDestZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandLostOrigZoneTotal_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandLostDestZoneTotal_AggT, xlsfile, 'Sheet', sheet2);

    % Plot table graphically by zones
    if param.GeneratePlots
        unit_labl = '[%]';
        titulo = 'Trips lost due to lack of vehicles per zone (SB+FF)';
        plotTableZone('DemandLostOrigZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Trips lost due to lack of coverage per zone (SB+FF)';
        plotTableZone('DemandLostDestZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDemandLostInTotalAggR
function tableDemandLostInTotalAggR(param, xlsfile, sheet1, sheet2, thi, thf, obj)
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
    obj.DemandLostOrigZoneTotal_AggR = table(Time);
    obj.DemandLostDestZoneTotal_AggR = table(Time);

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Orig = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    Dest = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    TotO = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    TotD = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    %%% Total Users
    for iusr=1:numel(obj.MyCity.vFinishedUsers)
        t = obj.MyCity.vFinishedUsers{iusr}.tCreation;
        if t>0
            ZoneO = obj.MyCity.vFinishedUsers{iusr}.ZoneO;
            TotO(ZoneO,t:end) = TotO(ZoneO,t:end) + 1;
            
            ZoneD = obj.MyCity.vFinishedUsers{iusr}.ZoneD;
            TotD(ZoneD,t:end) = TotD(ZoneD,t) + 1;
        end        
    end
    for iusr=1:numel(obj.MyCity.vUsers)
        t = obj.MyCity.vUsers{iusr}.tCreation;
        if t>0
            ZoneO = obj.MyCity.vUsers{iusr}.ZoneO;
            TotO(ZoneO,t:end) = TotO(ZoneO,t:end) + 1;
            
            ZoneD = obj.MyCity.vUsers{iusr}.ZoneO;
            TotD(ZoneD,t:end) = TotD(ZoneD,t:end) + 1;
        end        
    end
    % Dead users
    users_dead = obj.MyCity.notServicedUsers;
    for iusr=1:size(users_dead,1)
        t = users_dead(iusr,6); % Creation time
        if users_dead(iusr,5) > 0                                          % Has station on destination
                                                                           % The user didn't find car at origin
            k = users_dead(iusr,1); % ZoneO
            Orig(k,t:end) = Orig(k,t:end) + 1;
            TotO(k,t:end) = TotO(k,t:end) + 1;
        else                                                               % The user has no station on destination
                                                                           % Trip lost due to lack of coverage
            k = users_dead(iusr,2); % ZoneD
            Dest(k,t:end) = Dest(k,t:end) + 1;
            TotD(k,t:end) = TotD(k,t) + 1;
        end
    end

    %
    dayO = zeros(thf-thi+1,1);
    dayD = zeros(thf-thi+1,1);
    total_O = sum(sum(TotO));
    total_D = sum(sum(TotD));
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        dayO(th) = sum(sum(Orig(:,ti:tf),1))/total_O*100;
        dayD(th) = sum(sum(Dest(:,ti:tf),1))/total_D*100;
    end
    dayO(isnan(dayO)) = 0;
    dayD(isnan(dayD)) = 0;
    % Add column to table
    obj.DemandLostOrigZoneTotal_AggR.('DemandLostOrigZoneTotal_AggR') = dayO;
    obj.DemandLostDestZoneTotal_AggR.('DemandLostDestZoneTotal_AggR') = dayD;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DemandLostOrigZoneTotal_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.DemandLostDestZoneTotal_AggR, xlsfile, 'Sheet', sheet2);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total trips starting over time (SB+FF)';
        eje_y = 'Total trips starting [trips]';
        plotTableTime('DemandLostOrigZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Total trips finishing over time (SB+FF)';
        eje_y = 'Total trips finishing [trips]';
        plotTableTime('DemandLostDestZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableDestinationFullInTotalTime
function tableDestinationFullInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create tables with lost trips from stations+zones 
    % in every zone at every hour (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.DestinationFullZoneTotal_dt = table(ID);

    % Generate matrix from notServicedUsers
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    FullSt = zeros(zoneF-zoneI+1, TotalTime);
    TotSt = zeros(zoneF-zoneI+1, TotalTime);
    %
    for iusr=1:numel(obj.MyCity.vFinishedUsers)
        t = obj.MyCity.vFinishedUsers{iusr}.tTrip;
        if t > 0
            StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
            if StatD_min>0
                CarZoneP = obj.MyCity.vStations{StatD_min}.zoneID;
                k = find(list_zone==CarZoneP);
                FullSt(k,t) = FullSt(k,t) + 1;
                TotSt(k,t) = TotSt(k,t) + 1;
            else
                CarZoneP = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
                k = find(list_zone==CarZoneP);
                TotSt(k,t) = TotSt(k,t) + 1;
            end
        end
    end
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = sum(FullSt(:,ti:tf),2)./sum(TotSt(:,ti:tf),2);
        aux(isnan(aux)) = 0;

        % Add column to table
        obj.DestinationFullZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DestinationFullZoneTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Users unable to park per zone and hour';
        unit_labl = '[%]';
        plotTableZone('DestinationFullZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDestinationFullInTotalAggT
function tableDestinationFullInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create tables with lost trips from stations+zones 
    % in every zone aggregated by time (sum)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.DestinationFullZoneTotal_AggT = table(ID);

    % Generate matrix from vFinishedUsers
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    FullSt = zeros(zoneF-zoneI+1, TotalTime);
    TotSt = zeros(zoneF-zoneI+1, TotalTime);
    %
    for iusr=1:numel(obj.MyCity.vFinishedUsers)
        t = obj.MyCity.vFinishedUsers{iusr}.tTrip;
        if t > 0
            StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
            if StatD_min>0
                CarZoneP = obj.MyCity.vStations{StatD_min}.zoneID;
                k = find(list_zone==CarZoneP);
                FullSt(k,t) = FullSt(k,t) + 1;
                TotSt(k,t) = TotSt(k,t) + 1;
            else
                CarZoneP = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
                k = find(list_zone==CarZoneP);
                TotSt(k,t) = TotSt(k,t) + 1;
            end
        end
    end

    %
    aux = sum(FullSt(:,1:TotalTime),2)./sum(TotSt(:,1:TotalTime),2);
    aux(isnan(aux)) = 0;

    % Add column to table
    obj.DestinationFullZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DestinationFullZoneTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total lost trips per zone';
        unit_labl = '[trips]';
        plotTableZone('DestinationFullZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableDestinationFullInTotalAggR
function tableDestinationFullInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
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
    obj.DestinationFullZoneTotal_AggR = table(Time);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    FullSt = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    TotSt = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    %%% Total Users
    for iusr=1:numel(obj.MyCity.vFinishedUsers)
        t = obj.MyCity.vFinishedUsers{iusr}.tTrip;
        if t > 0
            StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
            if StatD_min>0
                k = obj.MyCity.vStations{StatD_min}.zoneID;
                FullSt(k,t:end) = FullSt(k,t:end) + 1;
                TotSt(k,t:end) = TotSt(k,t:end) + 1;
            else
                k = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
                TotSt(k,t:end) = TotSt(k,t:end) + 1;
            end
        end      
    end
    
    %
    dayF = zeros(thf-thi+1,1);
    tot_trips = sum(sum(TotSt));
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        dayF(th) = sum(sum(FullSt(:,ti:tf),1))/tot_trips*100;
    end
    dayF(isnan(dayF)) = 0;
    % Add column to table
    obj.DestinationFullZoneTotal_AggR.('DestinationFullZoneTotal_AggR') = dayF;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.DestinationFullZoneTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average access distance in the system (SB+FF) over time';
        eje_y = '[%]';
        plotTableTime('DestinationFullZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableAvgTripIncreaseInTotalTime
function tableAvgTripIncreaseInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with average access time
    % in every zone from stations+zones at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgTripIncreaseZoneTotal_dt = table(ID);

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
            t = obj.MyCity.vFinishedUsers{iusr}.tTrip;
            StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
            if StatD_min>0
                CarZoneP = obj.MyCity.vStations{StatD_min}.zoneID;
                k = find(list_zone==CarZoneP);
                if t >= ti && t < tf
                    tParkAdd = obj.MyCity.vFinishedUsers{iusr}.tParkAdd;
                    aux{k}(end+1) = tParkAdd;
                end
            else
                CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
                k = find(list_zone==CarZoneD);
                if t >= ti && t < tf
                    aux{k}(end+1) = 0;
                end 
            end
        end
        %
        aux2 = zeros(zoneF-zoneI+1,1);
        for i=1:zoneF-zoneI+1
            aux2(i) = mean(aux{i});
        end

        % Add column to table
        obj.AvgTripIncreaseZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgTripIncreaseZoneTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average trip increase due lack of parking in the system (SB+FF) per zone and hour';
        unit_labl = '[minutes]';
        plotTableZone('AvgTripIncreaseZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgTripIncreaseInTotalAggT
function tableAvgTripIncreaseInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with average access time
    % in every zone from stations+zones aggregated by time (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgTripIncreaseZoneTotal_AggT = table(ID);

    % Generate avg access time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = cell(zoneF-zoneI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
        if StatD_min>0
            CarZoneP = obj.MyCity.vStations{StatD_min}.zoneID;
            k = find(list_zone==CarZoneP);
            tParkAdd = obj.MyCity.vFinishedUsers{iusr}.tParkAdd;
            aux{k}(end+1) = tParkAdd;
        else
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            k = find(list_zone==CarZoneD);
            aux{k}(end+1) = 0;
        end
    end
    %
    aux2 = zeros(zoneF-zoneI+1,1);
    for i=1:zoneF-zoneI+1
        aux2(i) = mean(aux{i});
    end

    % Add column to table
    obj.AvgTripIncreaseZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgTripIncreaseZoneTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average trip increase due to in the system (SB+FF) per zone';
        unit_labl = '[minutes]';
        plotTableZone('AvgTripIncreaseZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgTripIncreaseInTotalAggR
function tableAvgTripIncreaseInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
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
    obj.AvgTripIncreaseZoneTotal_AggR = table(Time);

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
            t = obj.MyCity.vFinishedUsers{iusr}.tTrip;
            if t >= ti && t < tf
                StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
                if StatD_min>0
                    tParkAdd = obj.MyCity.vFinishedUsers{iusr}.tParkAdd;
                    aux{th}(end+1) = tParkAdd;
                else
                    aux{th}(end+1) = 0;
                end
            end
        end
        %
        aux2(th) = mean(aux{th});
    end
    % Add column to table
    obj.AvgTripIncreaseZoneTotal_AggR.('AvgTripIncreaseZoneTotal_AggR') = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgTripIncreaseZoneTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average trip increase due to lack of parking in the system (SB+FF) over time';
        eje_y = '[minutes]';
        plotTableTime('AvgTripIncreaseZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableAvgDistIncreaseInTotalTime
function tableAvgDistIncreaseInTotalTime(param, xlsfile, sheet, thi, thf, zoneI, zoneF, obj)
    % Function to create table with average Egress time
    % in every zone from stations+zones at every hour (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgDistIncreaseZoneTotal_dt = table(ID);

    % Generate avg Increased Distance
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    for th=thi:thf
        ti = (th-1)*60+1;
        tf = min(TotalTime,th*60);
        aux = cell(zoneF-zoneI+1,1);
        %
        for iusr=1:obj.MyCity.numFinishedUsers
            XD = obj.MyCity.vFinishedUsers{iusr}.XD;
            YD = obj.MyCity.vFinishedUsers{iusr}.YD;
            t = obj.MyCity.vFinishedUsers{iusr}.tTrip;
            StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
            if StatD_min>0
                Xpark = obj.MyCity.vStations{StatD_min}.X;
                Ypark = obj.MyCity.vStations{StatD_min}.Y;
                CarZoneP = obj.MyCity.vStations{StatD_min}.zoneID;
                k = find(list_zone==CarZoneP);
                if t >= ti && t < tf
                    aux{k}(end+1) = sim_dist(XD, YD, Xpark, Ypark);
                end
            else
                CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
                k = find(list_zone==CarZoneD);
                if t >= ti && t < tf
                    aux{k}(end+1) = 0;
                end 
            end
        end
        %
        aux2 = zeros(zoneF-zoneI+1,1);
        for i=1:zoneF-zoneI+1
            aux2(i) = mean(aux{i});
        end

        % Add column to table
        obj.AvgDistIncreaseZoneTotal_dt.(['T' num2str(ti) '-' num2str(tf)]) = aux2;
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgDistIncreaseZoneTotal_dt, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance increase in the system (SB+FF) per zone and hour';
        unit_labl = '[meters]';
        plotTableZone('AvgDistIncreaseZoneTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgDistIncreaseInTotalAggT
function tableAvgDistIncreaseInTotalAggT(param, xlsfile, sheet, zoneI, zoneF, obj)
    % Function to create table with average Egress time
    % in every zone from stations+zones aggregated by time (mean)

    % Generate first column with labels
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.AvgDistIncreaseZoneTotal_AggT = table(ID);

    % Generate avg Egress time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_zone = zoneI:zoneF;
    %
    aux = cell(zoneF-zoneI+1,1);
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        XD = obj.MyCity.vFinishedUsers{iusr}.XD;
        YD = obj.MyCity.vFinishedUsers{iusr}.YD;
        StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
        if StatD_min>0
            Xpark = obj.MyCity.vStations{StatD_min}.X;
            Ypark = obj.MyCity.vStations{StatD_min}.Y;
            CarZoneP = obj.MyCity.vStations{StatD_min}.zoneID;
            k = find(list_zone==CarZoneP);
            aux{k}(end+1) = sim_dist(XD, YD, Xpark, Ypark);
        else
            CarZoneD = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
            k = find(list_zone==CarZoneD);
            aux{k}(end+1) = 0;
        end
    end
    %
    aux2 = zeros(zoneF-zoneI+1,1);
    for i=1:zoneF-zoneI+1
        aux2(i) = mean(aux{i});
    end

    % Add column to table
    obj.AvgDistIncreaseZoneTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgDistIncreaseZoneTotal_AggT, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average distance increase in the system (SB+FF) per zone [meters]';
        unit_labl = '[meters]';
        plotTableZone('AvgDistIncreaseZoneTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableAvgDistIncreaseInTotalAggR
function tableAvgDistIncreaseInTotalAggR(param, xlsfile, sheet, thi, thf, obj)
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
    obj.AvgDistIncreaseZoneTotal_AggR = table(Time);

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
            t = obj.MyCity.vFinishedUsers{iusr}.tTrip;
            XD = obj.MyCity.vFinishedUsers{iusr}.XD;
            YD = obj.MyCity.vFinishedUsers{iusr}.YD;
            StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
            if t >= ti && t < tf
                if StatD_min>0
                    Xpark = obj.MyCity.vStations{StatD_min}.X;
                    Ypark = obj.MyCity.vStations{StatD_min}.Y;
                    aux{th}(end+1) = sim_dist(XD, YD, Xpark, Ypark);
                else
                    aux{th}(end+1) = 0;
                end
            end
        end
        %
        aux2(th) = mean(aux{th});
    end
    % Add column to table
    obj.AvgDistIncreaseZoneTotal_AggR.('AvgDistIncreaseZoneTotal_AggR') = aux2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.AvgDistIncreaseZoneTotal_AggR, xlsfile, 'Sheet', sheet);

    % Plot table graphically by zones
    if param.GeneratePlots
        titulo = 'Average egress distance increase in the system (SB+FF) over time';
        eje_y = 'Distance [meters]';
        plotTableTime('AvgDistIncreaseZoneTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableDemandLostInTotalSumm
function tableDemandLostInTotalSumm(obj)
    % Function to create tables with origin/destination demand
    % from/to stations+zones in every zone aggregated by region and time (sum)

    % Generate O/D matrix from/to stations
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Orig = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    Dest = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    TotO = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    TotD = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
        %%% Total Users
    for iusr=1:numel(obj.MyCity.vFinishedUsers)
        t = obj.MyCity.vFinishedUsers{iusr}.tCreation;
        if t>0
            k1 = obj.MyCity.vFinishedUsers{iusr}.ZoneO;
            TotO(k1,t) = TotO(k1,t) + 1;
            
            k2 = obj.MyCity.vFinishedUsers{iusr}.ZoneD;
            TotD(k2,t) = TotD(k2,t) + 1;
        end        
    end
    for iusr=1:numel(obj.MyCity.vUsers)
        t = obj.MyCity.vUsers{iusr}.tCreation;
        if t>0
            k1 = obj.MyCity.vUsers{iusr}.ZoneO;
            TotO(k1,t) = TotO(k1,t) + 1;
            
            k2 = obj.MyCity.vUsers{iusr}.ZoneD;
            TotD(k2,t) = TotD(k2,t) + 1;
        end        
    end
    % Dead users
    users_dead = obj.MyCity.notServicedUsers;
    for iusr=1:size(users_dead,1)
        t = users_dead(iusr,6); % Creation time
        if users_dead(iusr,5) > 0                                          % Has station on destination
                                                                           % The user didn't find car at origin
            % Account one dead user at origin.
            k1 = users_dead(iusr,1); % ZoneO
            Orig(k1,t) = Orig(k1,t) + 1;
            TotO(k1,t) = TotO(k1,t) + 1;
            % Account one user at destination total.
            k2 = users_dead(iusr,2); % ZoneD
            TotD(k2,t) = TotD(k2,t) + 1;
        else                                                               % The user has no station on destination
                                                                           % Trip lost due to lack of coverage
            % Account one dead user because of destination.
            k2 = users_dead(iusr,2); % ZoneD
            Dest(k2,t) = Dest(k2,t) + 1;
            TotD(k2,t) = TotD(k2,t) + 1;
            % Account one user at origin total.
            k1 = users_dead(iusr,1); % ZoneO
            TotO(k1,t) = TotO(k1,t) + 1;
        end
    end
    %
    dayO = sum(sum(Orig,1))/sum(sum(TotO,1))*100;
    dayD = sum(sum(Dest,1))/sum(sum(TotD,1))*100;
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Demand lost on origin' 'Users' num2str(sum(sum(Orig,1)),'%4.2f')}];
    obj.Summary = [obj.Summary; {'Demand lost on origin' '%' num2str(dayO,'%4.2f')}];
    obj.Summary = [obj.Summary; {'Demand lost due to lack of coverage' 'Users' num2str(sum(sum(Dest,1)),'%4.2f')}];
    obj.Summary = [obj.Summary; {'Demand lost due to lack of coverage' '%' num2str(dayD,'%4.2f')}];
end

% tableDestinationFullInTotalSumm
function tableDestinationFullInTotalSumm(obj)
    % Function to create tables with lost trips from stations+zones 
    % in every zone aggregated by region and time(sum)

    % Generate matrix from notServicedUsers
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    FullSt = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    TotSt = zeros(obj.MyCity.numFreeFloatZones, TotalTime);
    %
    for iusr=1:numel(obj.MyCity.vFinishedUsers)
        t = obj.MyCity.vFinishedUsers{iusr}.tTrip;
        if t > 0
            StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
            if StatD_min>0
                k = obj.MyCity.vStations{StatD_min}.zoneID;
                FullSt(k,t) = FullSt(k,t) + 1;
                TotSt(k,t) = TotSt(k,t) + 1;
            else
                k = obj.MyCity.vFinishedUsers{iusr}.CarZoneD;
                TotSt(k,t) = TotSt(k,t) + 1;
            end
        end
    end
    %
    day = sum(sum(FullSt,1));
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Total users without parking' 'Users' num2str(day,'%4.2f')}];
    obj.Summary = [obj.Summary; {'Users without parking' 'Percentage' num2str(100*day/sum(sum(TotSt,1)),'%4.2f')}];
end

% tableAvgTripIncreaseInTotalSumm
function tableAvgTripIncreaseInTotalSumm(param, obj)
    % Function to create table with average access time
    % in every zone from stations+zones aggregated by region and time (mean)

    % Generate avg access time
    aux = [];
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        %
        % Access time = Time when user takes the car - Time of car reservation
        tParkAdd = obj.MyCity.vFinishedUsers{iusr}.tParkAdd;
        %
        if tParkAdd>0
            aux(end+1) = tParkAdd;
        end
    end
    
    if isnan(aux)
        aux=0;
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. trip increase' 'Minutes' num2str(mean(aux),'%6.2f')}];
end

% tableAvgEgressInTotalSumm
function tableAvgDistIncreaseInTotalSumm(param, obj)
    % Function to create table with average Egress time
    % in every zone from stations+zones aggregated by region and time (mean)

    % Generate avg Egress time
    aux = [];
    %
    for iusr=1:obj.MyCity.numFinishedUsers
        XD = obj.MyCity.vFinishedUsers{iusr}.XD;
        YD = obj.MyCity.vFinishedUsers{iusr}.YD;
        StatD_min = obj.MyCity.vFinishedUsers{iusr}.StatD_min;
        if StatD_min>0
            Xpark = obj.MyCity.vStations{StatD_min}.X;
            Ypark = obj.MyCity.vStations{StatD_min}.Y;
            aux(end+1) = sim_dist(XD, YD, Xpark, Ypark);
        else
            %aux(end+1) = 0;
        end
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. egress distance increase' 'Meters' num2str(mean(aux),'%6.2f')}];
end

% tableUtilities
function tableRepoUtilitiesInTotalSumm(param, obj)
    % Function to create table with average Egress time
    % in every zone from stations+zones aggregated by region and time (mean)

    % Generate avg Egress time
    ut_pos = 0;
    ut_neg = 0;
    t_pos = 0;
    %
    for iteam=1:obj.MyCity.numRepoTeams
        currnt = obj.MyCity.vRepoTeams{iteam}.taskCurrent;
        %
        if currnt>1
            for itask=1:currnt-1
                util = obj.MyCity.vRepoTeams{iteam}.taskUtility(itask);
                if util>0
                    ut_pos = ut_pos + util;
                    if itask>1
                        t_task = obj.MyCity.vRepoTeams{iteam}.taskTime(itask)...
                            - obj.MyCity.vRepoTeams{iteam}.taskTime(itask-1);
                    else
                        t_task = obj.MyCity.vRepoTeams{iteam}.taskTime(itask);
                    end
                    t_pos = t_pos + t_task;
                else
                    ut_neg = ut_neg + util;
                end
            end
        end
    end
    
    t_pos = t_pos/(numel(obj.MyCity.vRepoTeams{1}.status)*numel(obj.MyCity.vRepoTeams));
    
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. positive utility' '€' num2str(ut_pos,'%6.2f')}];
    obj.Summary = [obj.Summary; {'Avg. negative utility' '€' num2str(ut_neg,'%6.2f')}];
    obj.Summary = [obj.Summary; {'Time perc. positive tasks' '%' num2str(t_pos*100,'%6.2f')}];
end
