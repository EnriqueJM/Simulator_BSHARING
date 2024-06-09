function outputRepositioning(param, folder, thi, thf, StationI, StationF, ZoneI, ZoneF, obj)
    % Function to generate results (tables & plots) about unbalance of cars
    
    if param.verbose
        disp('');
        disp('CREATING REPOSITIONING TABLES');
    end
    
    % Create Vehicles folder
    [status, msg, msgID] = mkdir([pwd '/' folder],'Repositioning');
    if status == 0
        error('Error: Output folder could not be created');
    end
    
    xlsfile = [folder '/Repositioning/Tables_repositioning.xlsx'];            
    if isfile(xlsfile)
        delete(xlsfile);
    end

    %%%%%%%%%%%%%%%%%%%%%%
    %    HOURLY TABLES   % 
    %%%%%%%%%%%%%%%%%%%%%%
    if param.Hourly
        
        % VehiclesLeftInStationTime
        if param.verbose
            disp('Creating tables VehiclesLeftInStationTime');
        end
        %
        sheet1 = 'CarsLeftRechargInStationTime';
        sheet2 = 'CarsLeftRebalancInStationTime';
        sheet3 = 'CarsLeftBothInStationTime';
        tableVehiclesLeftInStationTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, StationI, StationF, obj);

        % VehiclesLeftInZoneTime
        if param.verbose
            disp('Creating tables VehiclesLeftInZoneTime');
        end
        %
        sheet1 = 'CarsLeftRechargInZoneTime';
        sheet2 = 'CarsLeftRebalancInZoneTime';
        sheet3 = 'CarsLeftBothInZoneTime';
        tableVehiclesLeftInZoneTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, ZoneI, ZoneF, obj);

        % VehiclesLeftInTotalTime
        if param.verbose
            disp('Creating tables VehiclesLeftInTotalTime');
        end
        %
        sheet1 = 'CarsLeftRechargInTotalTime';
        sheet2 = 'CarsLeftRebalancInTotalTime';
        sheet3 = 'CarsLeftBothInTotalTime';
        tableVehiclesLeftInTotalTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, StationI, StationF, ZoneI, ZoneF, obj);

        % VehiclesTakenInStationTime
        if param.verbose
            disp('Creating tables VehiclesTakenInStationTime');
        end
        %
        sheet1 = 'CarsTakenRechargInStationTime';
        sheet2 = 'CarsTakenRebalancInStationTime';
        sheet3 = 'CarsTakenBothInStationTime';
        tableVehiclesTakenInStationTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, StationI, StationF, obj);

        % VehiclesTakenInZoneTime
        if param.verbose
            disp('Creating tables VehiclesTakenInZoneTime');
        end
        %
        sheet1 = 'CarsTakenRechargInZoneTime';
        sheet2 = 'CarsTakenRebalancInZoneTime';
        sheet3 = 'CarsTakenBothInZoneTime';
        tableVehiclesTakenInZoneTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, ZoneI, ZoneF, obj);

        % VehiclesTakenInTotalTime
        if param.verbose
            disp('Creating tables VehiclesTakenInTotalTime');
        end
        %
        sheet1 = 'CarsTakenRechargInTotalTime';
        sheet2 = 'CarsTakenRebalancInTotalTime';
        sheet3 = 'CarsTakenBothInTotalTime';
        tableVehiclesTakenInTotalTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, StationI, StationF, ZoneI, ZoneF, obj);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %    TIME AGGREGATION   % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggT
        
        % VehiclesLeftInStationAggT
        if param.verbose
            disp('Creating tables VehiclesLeftInStationAggT');
        end
        %
        sheet1 = 'CarsLeftRechargInStationAggT';
        sheet2 = 'CarsLeftRebalancInStationAggT';
        sheet3 = 'CarsLeftBothInStationAggT';
        tableVehiclesLeftInStationAggT(param, xlsfile, sheet1, sheet2, sheet3, StationI, StationF, obj);

        % VehiclesLeftInZoneAggT
        if param.verbose
            disp('Creating tables VehiclesLeftInZoneAggT');
        end
        %
        sheet1 = 'CarsLeftRechargInZoneAggT';
        sheet2 = 'CarsLeftRebalancInZoneAggT';
        sheet3 = 'CarsLeftBothInZoneAggT';
        tableVehiclesLeftInZoneAggT(param, xlsfile, sheet1, sheet2, sheet3, ZoneI, ZoneF, obj);

        % VehiclesLeftInTotalAggT
        if param.verbose
            disp('Creating tables VehiclesLeftInTotalAggT');
        end
        %
        sheet1 = 'CarsLeftRechargInTotalAggT';
        sheet2 = 'CarsLeftRebalancInTotalAggT';
        sheet3 = 'CarsLeftBothInTotalAggT';
        tableVehiclesLeftInTotalAggT(param, xlsfile, sheet1, sheet2, sheet3, StationI, StationF, ZoneI, ZoneF, obj);

        % VehiclesTakenInStationAggT
        if param.verbose
            disp('Creating tables VehiclesTakenInStationAggT');
        end
        %
        sheet1 = 'CarsTakenRechargInStationAggT';
        sheet2 = 'CarsTakenRebalancInStationAggT';
        sheet3 = 'CarsTakenBothInStationAggT';
        tableVehiclesTakenInStationAggT(param, xlsfile, sheet1, sheet2, sheet3, StationI, StationF, obj);

        % VehiclesTakenInZoneAggT
        if param.verbose
            disp('Creating tables VehiclesTakenInZoneAggT');
        end
        %
        sheet1 = 'CarsTakenRechargInZoneAggT';
        sheet2 = 'CarsTakenRebalancInZoneAggT';
        sheet3 = 'CarsTakenBothInZoneAggT';
        tableVehiclesTakenInZoneAggT(param, xlsfile, sheet1, sheet2, sheet3, ZoneI, ZoneF, obj);

        % VehiclesTakenInTotalAggT
        if param.verbose
            disp('Creating tables VehiclesTakenInTotalAggT');
        end
        %
        sheet1 = 'CarsTakenRechargInTotalAggT';
        sheet2 = 'CarsTakenRebalancInTotalAggT';
        sheet3 = 'CarsTakenBothInTotalAggT';
        tableVehiclesTakenInTotalAggT(param, xlsfile, sheet1, sheet2, sheet3, StationI, StationF, ZoneI, ZoneF, obj);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %   REGION AGGREGATION  % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggR
        
        % VehiclesLeftInStationAggR
        if param.verbose
            disp('Creating tables VehiclesLeftInStationAggR');
        end
        %
        sheet1 = 'CarsLeftRechargInStationAggR';
        sheet2 = 'CarsLeftRebalancInStationAggR';
        sheet3 = 'CarsLeftBothInStationAggR';
        tableVehiclesLeftInStationAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj);

        % VehiclesLeftInZoneAggR
        if param.verbose
            disp('Creating tables VehiclesLeftInZoneAggR');
        end
        %
        sheet1 = 'CarsLeftRechargInZoneAggR';
        sheet2 = 'CarsLeftRebalancInZoneAggR';
        sheet3 = 'CarsLeftBothInZoneAggR';
        tableVehiclesLeftInZoneAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj);

        % VehiclesLeftInTotalAggR
        if param.verbose
            disp('Creating tables VehiclesLeftInTotalAggR');
        end
        %
        sheet1 = 'CarsLeftRechargInTotalAggR';
        sheet2 = 'CarsLeftRebalancInTotalAggR';
        sheet3 = 'CarsLeftBothInTotalAggR';
        tableVehiclesLeftInTotalAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj);

        % VehiclesTakenInStationAggR
        if param.verbose
            disp('Creating tables VehiclesTakenInStationAggR');
        end
        %
        sheet1 = 'CarsTakenRechargInStationAggR';
        sheet2 = 'CarsTakenRebalancInStationAggR';
        sheet3 = 'CarsTakenBothInStationAggR';
        tableVehiclesTakenInStationAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj);

        % VehiclesTakenInZoneAggR
        if param.verbose
            disp('Creating tables VehiclesTakenInZoneAggR');
        end
        %
        sheet1 = 'CarsTakenRechargInZoneAggR';
        sheet2 = 'CarsTakenRebalancInZoneAggR';
        sheet3 = 'CarsTakenBothInZoneAggR';
        tableVehiclesTakenInZoneAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj);

        % VehiclesTakenInTotalAggR
        if param.verbose
            disp('Creating tables VehiclesTakenInTotalAggR');
        end
        %
        sheet1 = 'CarsTakenRechargInTotalAggR';
        sheet2 = 'CarsTakenRebalancInTotalAggR';
        sheet3 = 'CarsTakenBothInTotalAggR';
        tableVehiclesTakenInTotalAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj);
    end
    
    %%%%%%%%%%%%%
    %  SUMMARY  %
    %%%%%%%%%%%%%
    
    % VehiclesLeftInStationSumm
    if param.verbose
        disp('Creating tables VehiclesLeftInStationSumm');
    end
    %
    tableVehiclesLeftInStationSumm(obj);

    % VehiclesLeftInZoneSumm
    if param.verbose
        disp('Creating tables VehiclesLeftInZoneSumm');
    end
    %
    tableVehiclesLeftInZoneSumm(obj);

    % VehiclesLeftInTotalSumm
    if param.verbose
        disp('Creating tables VehiclesLeftInTotalSumm');
    end
    %
    tableVehiclesLeftInTotalSumm(obj);

    % VehiclesTakenInStationSumm
    if param.verbose
        disp('Creating tables VehiclesTakenInStationSumm');
    end
    %
    tableVehiclesTakenInStationSumm(obj);

    % VehiclesTakenInZoneSumm
    if param.verbose
        disp('Creating tables VehiclesTakenInZoneSumm');
    end
    %
    tableVehiclesTakenInZoneSumm(obj);

    % VehiclesTakenInTotalSumm
    if param.verbose
        disp('Creating tables VehiclesTakenInTotalSumm');
    end
    %
    tableVehiclesTakenInTotalSumm(obj);
    
    % AvgRepoRateSumm
    if param.verbose
        disp('Creating tables AvgRepoRateSumm');
    end
    %
    tableAvgRepoRateSumm(obj);
    
    % RepoTeamStatusSumm
    if param.verbose
        disp('Creating tables RepoTeamStatusSumm');
    end
    %
    tableRepoTeamStatusSumm(obj);
    
    % TaskTypeSumm
    if param.verbose
        disp('Creating tables TaskTypeSumm');
    end
    %
    tableTaskTypeSumm(obj);
    
    % TaskOrigDestSumm
%     if param.verbose
%         disp('Creating tables TaskOrigDestSumm');
%     end
%     %
%     tableTaskOrigDestSumm(obj);

end

% tableVehiclesLeftInStationTime
function tableVehiclesLeftInStationTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, statI, statF, obj)
    % Function to create table with vehicles left in every station
    % at every hour 

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
    obj.VehiclesLeftRechargingSB_dt = table(ID, Name);
    obj.VehiclesLeftRebalancingSB_dt = table(ID, Name);
    obj.VehiclesLeftBothSB_dt = table(ID, Name);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    % Because external ID is used in repo:
    list_statID = zeros(statF-statI+1,1);
    for istat = 1:statF-statI+1
        list_statID(istat) = obj.MyCity.vStations{istat}.ID;
    end
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux1 = zeros(statF-statI+1, 1);
        aux2 = zeros(statF-statI+1, 1);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            %
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if stat == 1 && mov>0
                        statID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        [k] = find(list_statID==statID);
                        if size(k,1) > 0 && size(k,2) > 0
                            %%% Check type of task.
                            % Check the ending time of the task.
                            t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                            %
                            if t >= ti && t < tf
                                if priority == 1
                                    % Recharging
                                    aux1(k) = aux1(k) + 1;
                                elseif priority == 2
                                    % Rebalancing
                                    aux2(k) = aux2(k) + 1;
                                end
                            end
                        end
                    end
                end
            end
        end            

        % Add column to table
        obj.VehiclesLeftRechargingSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1;
        obj.VehiclesLeftRebalancingSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux2;
        obj.VehiclesLeftBothSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1+aux2;
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesLeftRechargingSB_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesLeftRebalancingSB_dt, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesLeftBothSB_dt, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles returned to stations for recharging (priority 1 & 2) per hour';
        unit_labl = '[vehicles]';
        plotTableStation('VehiclesLeftRechargingSB_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles returned to stations for relocation (priority 3) per hour';
        plotTableStation('VehiclesLeftRebalancingSB_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles returned to stations due to repositioning per hour';
        plotTableStation('VehiclesLeftBothSB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesLeftInZoneTime
function tableVehiclesLeftInZoneTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, zoneI, zoneF, obj)
    % Function to create table with vehicles left in every zone
    % at every hour

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.VehiclesLeftRechargingFF_dt = table(ID);
    obj.VehiclesLeftRebalancingFF_dt = table(ID);
    obj.VehiclesLeftBothFF_dt = table(ID);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_zoneID = zeros(zoneF-zoneI+1,1);
    for izone = 1:zoneF-zoneI+1
        list_zoneID(izone) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux1 = zeros(zoneF-zoneI+1, 1);
        aux2 = zeros(zoneF-zoneI+1, 1);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if stat == 0 && mov>0
                        zoneID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        [k] = find(list_zoneID==zoneID);
                        if size(k,1) > 0 && size(k,2) > 0
                            %%% Check type of task.
                            % Check the ending time of the task.
                            t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                            %
                            if t >= ti && t < tf
                                if priority == 1
                                    % Recharging
                                    aux1(k) = aux1(k) + 1;
                                elseif priority == 2
                                    % Rebalancing
                                    aux2(k) = aux2(k) + 1;
                                end
                            end
                        end
                    end
                end
            end
        end            

        % Add column to table
        obj.VehiclesLeftRechargingFF_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1;
        obj.VehiclesLeftRebalancingFF_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux2;
        obj.VehiclesLeftBothFF_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1+aux2;
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesLeftRechargingFF_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesLeftRebalancingFF_dt, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesLeftBothFF_dt, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles returned to street for recharging (priority 1 & 2) per hour';
        unit_labl = '[vehicles]';
        plotTableZone('VehiclesLeftRechargingFF_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles returned to street for relocation (priority 3) per hour';
        plotTableZone('VehiclesLeftRebalancingFF_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles returned to street due to repositioning per hour';
        plotTableZone('VehiclesLeftBothFF_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesLeftInTotalTime
function tableVehiclesLeftInTotalTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, statI, statF, zoneI, zoneF, obj)
    % Function to create table with vehicles left in every station+zone
    % at every hour

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.VehiclesLeftRechargingTotal_dt = table(ID);
    obj.VehiclesLeftRebalancingTotal_dt = table(ID);
    obj.VehiclesLeftBothTotal_dt = table(ID);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_statID = zeros(statF-statI+1,1);
    for istat = 1:statF-statI+1
        list_statID(istat) = obj.MyCity.vStations{istat}.ID;
    end
    %
    list_zoneID = zeros(zoneF-zoneI+1,1);
    for izone = 1:zoneF-zoneI+1
        list_zoneID(izone) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux1 = zeros(zoneF-zoneI+1, 1);
        aux2 = zeros(zoneF-zoneI+1, 1);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    
                    if mov > 0
                        % Check zoneID
                        if stat == 0
                            zoneID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                        elseif stat == 1
                            statID = obj.MyCity.vRepoTeams{iteam}.taskList(j); % Station ID
                            [k1] = find(list_statID==statID);
                            if size(k1,1) > 0 && size(k1,2) > 0
                                zoneID = obj.MyCity.vFreeFloatZones{obj.MyCity.vStations{k1}.zoneID}.ID;
                            else
                                zoneID = 0;
                            end
                        end
                        if zoneID > 0
                            priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                            %
                            [k] = find(list_zoneID==zoneID);
                            if size(k,1) > 0 && size(k,2) > 0
                                %%% Check type of task.
                                % Check the ending time of the task.
                                t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                                %
                                if t >= ti && t < tf
                                    if priority == 1
                                        % Recharging
                                        aux1(k) = aux1(k) + 1;
                                    elseif priority == 2
                                        % Rebalancing
                                        aux2(k) = aux2(k) + 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end            

        % Add column to table
        obj.VehiclesLeftRechargingTotal_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1;
        obj.VehiclesLeftRebalancingTotal_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux2;
        obj.VehiclesLeftBothTotal_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1+aux2;
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesLeftRechargingTotal_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesLeftRebalancingTotal_dt, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesLeftBothTotal_dt, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles returned for recharging (priority 1 & 2) per hour';
        unit_labl = '[vehicles]';
        plotTableZone('VehiclesLeftRechargingTotal_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles returned for relocation (priority 3) per hour';
        plotTableZone('VehiclesLeftRebalancingTotal_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles returned due to repositioning per hour';
        plotTableZone('VehiclesLeftBothTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesTakenInStationTime
function tableVehiclesTakenInStationTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, statI, statF, obj)
    % Function to create table with vehicles taken in every station
    % at every hour

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
    obj.VehiclesTakenRechargingSB_dt = table(ID, Name);
    obj.VehiclesTakenRebalancingSB_dt = table(ID, Name);
    obj.VehiclesTakenBothSB_dt = table(ID, Name);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_statID = zeros(statF-statI+1,1);
    for istat = 1:statF-statI+1
        list_statID(istat) = obj.MyCity.vStations{istat}.ID;
    end
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux1 = zeros(statF-statI+1, 1);
        aux2 = zeros(statF-statI+1, 1);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if stat == 1 && mov<0
                        statID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        [k] = find(list_statID==statID);
                        if size(k,1) > 0 && size(k,2) > 0
                            %%% Check type of task.
                            % Check the ending time of the task.
                            t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                            %
                            if t >= ti && t < tf
                                if priority == 1
                                    % Recharging
                                    aux1(k) = aux1(k) + 1;
                                elseif priority == 2
                                    % Rebalancing
                                    aux2(k) = aux2(k) + 1;
                                end
                            end
                        end
                    end
                end
            end
        end            

        % Add column to table
        obj.VehiclesTakenRechargingSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1;
        obj.VehiclesTakenRebalancingSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux2;
        obj.VehiclesTakenBothSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1+aux2;
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesTakenRechargingSB_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesTakenRebalancingSB_dt, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesTakenBothSB_dt, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles taken from stations for recharging (priority 1 & 2) per hour';
        unit_labl = '[vehicles]';
        plotTableStation('VehiclesTakenRechargingSB_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles taken from stations for relocation (priority 3) per hour';
        plotTableStation('VehiclesTakenRebalancingSB_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles taken from stations for repositioning per hour';
        plotTableStation('VehiclesTakenBothSB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesTakenInZoneTime
function tableVehiclesTakenInZoneTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, zoneI, zoneF, obj)
    % Function to create table with vehicles taken in every zone
    % at every hour

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.VehiclesTakenRechargingFF_dt = table(ID);
    obj.VehiclesTakenRebalancingFF_dt = table(ID);
    obj.VehiclesTakenBothFF_dt = table(ID);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_zoneID = zeros(zoneF-zoneI+1,1);
    for izone = 1:zoneF-zoneI+1
        list_zoneID(izone) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux1 = zeros(zoneF-zoneI+1, 1);
        aux2 = zeros(zoneF-zoneI+1, 1);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if stat == 0 && mov<0
                        zoneID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        [k] = find(list_zoneID==zoneID);
                        if size(k,1) > 0 && size(k,2) > 0
                            %%% Check type of task.
                            % Check the ending time of the task.
                            t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                            %
                            if t >= ti && t < tf
                                if priority == 1
                                    % Recharging
                                    aux1(k) = aux1(k) + 1;
                                elseif priority == 2
                                    % Rebalancing
                                    aux2(k) = aux2(k) + 1;
                                end
                            end
                        end
                    end
                end
            end
        end            

        % Add column to table
        obj.VehiclesTakenRechargingFF_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1;
        obj.VehiclesTakenRebalancingFF_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux2;
        obj.VehiclesTakenBothFF_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1+aux2;
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesTakenRechargingFF_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesTakenRebalancingFF_dt, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesTakenBothFF_dt, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles taken from street for recharging (priority 1 & 2) per hour';
        unit_labl = '[vehicles]';
        plotTableZone('VehiclesTakenRechargingFF_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles taken from street for relocation (priority 3) per hour';
        plotTableZone('VehiclesTakenRebalancingFF_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles taken from street for repositioning per hour';
        plotTableZone('VehiclesTakenBothFF_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesTakenInTotalTime
function tableVehiclesTakenInTotalTime(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, statI, statF, zoneI, zoneF, obj)
    % Function to create table with vehicles taken in every station+zone
    % at every hour

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.VehiclesTakenRechargingTotal_dt = table(ID);
    obj.VehiclesTakenRebalancingTotal_dt = table(ID);
    obj.VehiclesTakenBothTotal_dt = table(ID);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_statID = zeros(statF-statI+1,1);
    for istat = 1:statF-statI+1
        list_statID(istat) = obj.MyCity.vStations{istat}.ID;
    end
    %
    list_zoneID = zeros(zoneF-zoneI+1,1);
    for izone = 1:zoneF-zoneI+1
        list_zoneID(izone) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux1 = zeros(zoneF-zoneI+1, 1);
        aux2 = zeros(zoneF-zoneI+1, 1);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    if mov < 0
                        % Check zoneID
                        if stat == 0
                            zoneID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                        elseif stat == 1
                            statID = obj.MyCity.vRepoTeams{iteam}.taskList(j); % Station ID
                            [k1] = find(list_statID==statID);
                            if size(k1,1) > 0 && size(k1,2) > 0
                                zoneID = obj.MyCity.vFreeFloatZones{obj.MyCity.vStations{k1}.zoneID}.ID;
                            else
                                zoneID = 0;
                            end
                        end
                        if zoneID > 0
                            priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                            %
                            [k] = find(list_zoneID==zoneID);
                            if size(k,1) > 0 && size(k,2) > 0
                                %%% Check type of task.
                                % Check the ending time of the task.
                                t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                                %
                                if t >= ti && t < tf
                                    if priority == 1
                                        % Recharging
                                        aux1(k) = aux1(k) + 1;
                                    elseif priority == 2
                                        % Rebalancing
                                        aux2(k) = aux2(k) + 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end            

        % Add column to table
        obj.VehiclesTakenRechargingTotal_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1;
        obj.VehiclesTakenRebalancingTotal_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux2;
        obj.VehiclesTakenBothTotal_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = aux1+aux2;
    end
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesTakenRechargingTotal_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesTakenRebalancingTotal_dt, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesTakenBothTotal_dt, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles taken for recharging (priority 1 & 2) per hour';
        unit_labl = '[vehicles]';
        plotTableZone('VehiclesTakenRechargingTotal_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles taken for relocation (priority 3) per hour';
        plotTableZone('VehiclesTakenRebalancingTotal_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles taken for repositioning per hour';
        plotTableZone('VehiclesTakenBothTotal_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesLeftInStationAggT
function tableVehiclesLeftInStationAggT(param, xlsfile, sheet1, sheet2, sheet3, statI, statF, obj)
    % Function to create table with vehicles left in every station
    % aggregated by time

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
    obj.VehiclesLeftRechargingSB_AggT = table(ID, Name);
    obj.VehiclesLeftRebalancingSB_AggT = table(ID, Name);
    obj.VehiclesLeftBothSB_AggT = table(ID, Name);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_statID = zeros(statF-statI+1,1);
    for istat = 1:statF-statI+1
        list_statID(istat) = obj.MyCity.vStations{istat}.ID;
    end
    %
    aux1 = zeros(statF-statI+1, 1);
    aux2 = zeros(statF-statI+1, 1);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and movements
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if stat == 1 && mov>0
                    statID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                    priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                    %
                    [k] = find(list_statID==statID);
                    if size(k,1) > 0 && size(k,2) > 0
                        %%% Check type of task.
                        if priority == 1
                            % Recharging
                            aux1(k) = aux1(k) + 1;
                        elseif priority == 2
                            % Rebalancing
                            aux2(k) = aux2(k) + 1;
                        end
                    end
                end
            end
        end
    end            
    %
    % Add column to table
    obj.VehiclesLeftRechargingSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1;
    obj.VehiclesLeftRebalancingSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    obj.VehiclesLeftBothSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1+aux2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesLeftRechargingSB_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesLeftRebalancingSB_AggT, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesLeftBothSB_AggT, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles returned to stations for recharging (priority 1 & 2)';
        unit_labl = '[vehicles]';
        plotTableStation('VehiclesLeftRechargingSB_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles returned to stations for relocation (priority 3)';
        plotTableStation('VehiclesLeftRebalancingSB_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles returned to stations due to repositioning';
        plotTableStation('VehiclesLeftBothSB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesLeftInZoneAggT
function tableVehiclesLeftInZoneAggT(param, xlsfile, sheet1, sheet2, sheet3, zoneI, zoneF, obj)
    % Function to create table with vehicles left in every zone
    % aggregated by time

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.VehiclesLeftRechargingFF_AggT = table(ID);
    obj.VehiclesLeftRebalancingFF_AggT = table(ID);
    obj.VehiclesLeftBothFF_AggT = table(ID);

    % Generate unbalance of cars per station in every hour
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_zoneID = zeros(zoneF-zoneI+1,1);
    for izone = 1:zoneF-zoneI+1
        list_zoneID(izone) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    aux1 = zeros(zoneF-zoneI+1, 1);
    aux2 = zeros(zoneF-zoneI+1, 1);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and movements
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if stat == 0 && mov>0
                    zoneID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                    priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                    %
                    [k] = find(list_zoneID==zoneID);
                    if size(k,1) > 0 && size(k,2) > 0
                        %%% Check type of task.
                        if priority == 1
                            % Recharging
                            aux1(k) = aux1(k) + 1;
                        elseif priority == 2
                            % Rebalancing
                            aux2(k) = aux2(k) + 1;
                        end
                    end
                end
            end
        end
    end            

    % Add column to table
    obj.VehiclesLeftRechargingFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1;
    obj.VehiclesLeftRebalancingFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    obj.VehiclesLeftBothFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1+aux2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesLeftRechargingFF_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesLeftRebalancingFF_AggT, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesLeftBothFF_AggT, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles returned to street for recharging (priority 1 & 2)';
        unit_labl = '[vehicles]';
        plotTableZone('VehiclesLeftRechargingFF_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles returned to street for relocation (priority 3)';
        plotTableZone('VehiclesLeftRebalancingFF_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles returned to street due to repositioning';
        plotTableZone('VehiclesLeftBothFF_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesLeftInTotalAggT
function tableVehiclesLeftInTotalAggT(param, xlsfile, sheet1, sheet2, sheet3, statI, statF, zoneI, zoneF, obj)
    % Function to create table with vehicles left in every station+zone
    % at every hour

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.VehiclesLeftRechargingTotal_AggT = table(ID);
    obj.VehiclesLeftRebalancingTotal_AggT = table(ID);
    obj.VehiclesLeftBothTotal_AggT = table(ID);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_statID = zeros(statF-statI+1,1);
    for istat = 1:statF-statI+1
        list_statID(istat) = obj.MyCity.vStations{istat}.ID;
    end
    %
    list_zoneID = zeros(zoneF-zoneI+1,1);
    for izone = 1:zoneF-zoneI+1
        list_zoneID(izone) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    aux1 = zeros(zoneF-zoneI+1, 1);
    aux2 = zeros(zoneF-zoneI+1, 1);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and priority of the task
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                if mov > 0
                    % Check zoneID
                    if stat == 0
                        zoneID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                    elseif stat == 1
                        statID = obj.MyCity.vRepoTeams{iteam}.taskList(j); % Station ID
                        [k1] = find(list_statID==statID);
                        if size(k1,1) > 0 && size(k1,2) > 0
                            zoneID = obj.MyCity.vFreeFloatZones{obj.MyCity.vStations{k1}.zoneID}.ID;
                        else
                            zoneID = 0;
                        end
                    end
                    if zoneID > 0
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        [k] = find(list_zoneID==zoneID);
                        if size(k,1) > 0 && size(k,2) > 0
                            %%% Check type of task.
                            if priority == 1
                                % Recharging
                                aux1(k) = aux1(k) + 1;
                            elseif priority == 2
                                % Rebalancing
                                aux2(k) = aux2(k) + 1;
                            end
                        end
                    end
                end
            end
        end
    end            

    % Add column to table
    obj.VehiclesLeftRechargingTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1;
    obj.VehiclesLeftRebalancingTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    obj.VehiclesLeftBothTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1+aux2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesLeftRechargingTotal_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesLeftRebalancingTotal_AggT, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesLeftBothTotal_AggT, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles returned for recharging (priority 1 & 2)';
        unit_labl = '[vehicles]';
        plotTableZone('VehiclesLeftRechargingTotal_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles returned for relocation (priority 3)';
        plotTableZone('VehiclesLeftRebalancingTotal_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles returned due to repositioning';
        plotTableZone('VehiclesLeftBothTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesTakenInStationAggT
function tableVehiclesTakenInStationAggT(param, xlsfile, sheet1, sheet2, sheet3, statI, statF, obj)
    % Function to create table with vehicles taken in every station
    % aggregated by time

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
    obj.VehiclesTakenRechargingSB_AggT = table(ID, Name);
    obj.VehiclesTakenRebalancingSB_AggT = table(ID, Name);
    obj.VehiclesTakenBothSB_AggT = table(ID, Name);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_statID = zeros(statF-statI+1,1);
    for istat = 1:statF-statI+1
        list_statID(istat) = obj.MyCity.vStations{istat}.ID;
    end
    %
    aux1 = zeros(statF-statI+1, 1);
    aux2 = zeros(statF-statI+1, 1);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and movements
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if stat == 1 && mov<0
                    statID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                    priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                    %
                    [k] = find(list_statID==statID);
                    if size(k,1) > 0 && size(k,2) > 0
                        %%% Check type of task.
                        if priority == 1
                            % Recharging
                            aux1(k) = aux1(k) + 1;
                        elseif priority == 2
                            % Rebalancing
                            aux2(k) = aux2(k) + 1;
                        end
                    end
                end
            end
        end
    end            

    % Add column to table
    obj.VehiclesTakenRechargingSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1;
    obj.VehiclesTakenRebalancingSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    obj.VehiclesTakenBothSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1+aux2;

    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesTakenRechargingSB_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesTakenRebalancingSB_AggT, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesTakenBothSB_AggT, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles taken from stations for recharging (priority 1 & 2)';
        unit_labl = '[vehicles]';
        plotTableStation('VehiclesTakenRechargingSB_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles taken from stations for relocation (priority 3)';
        plotTableStation('VehiclesTakenRebalancingSB_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles taken from stations for repositioning';
        plotTableStation('VehiclesTakenBothSB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesTakenInZoneAggT
function tableVehiclesTakenInZoneAggT(param, xlsfile, sheet1, sheet2, sheet3, zoneI, zoneF, obj)
    % Function to create table with vehicles taken in every zone
    % at every hour

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.VehiclesTakenRechargingFF_AggT = table(ID);
    obj.VehiclesTakenRebalancingFF_AggT = table(ID);
    obj.VehiclesTakenBothFF_AggT = table(ID);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_zoneID = zeros(zoneF-zoneI+1,1);
    for izone = 1:zoneF-zoneI+1
        list_zoneID(izone) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    aux1 = zeros(zoneF-zoneI+1, 1);
    aux2 = zeros(zoneF-zoneI+1, 1);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and movements
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if stat == 0 && mov<0
                    zoneID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                    priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                    %
                    [k] = find(list_zoneID==zoneID);
                    if size(k,1) > 0 && size(k,2) > 0
                        %%% Check type of task.
                        if priority == 1
                            % Recharging
                            aux1(k) = aux1(k) + 1;
                        elseif priority == 2
                            % Rebalancing
                            aux2(k) = aux2(k) + 1;
                        end
                    end
                end
            end
        end
    end            

    % Add column to table
    obj.VehiclesTakenRechargingFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1;
    obj.VehiclesTakenRebalancingFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    obj.VehiclesTakenBothFF_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1+aux2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesTakenRechargingFF_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesTakenRebalancingFF_AggT, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesTakenBothFF_AggT, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles taken from street for recharging (priority 1 & 2)';
        unit_labl = '[vehicles]';
        plotTableZone('VehiclesTakenRechargingFF_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles taken from street for relocation (priority 3)';
        plotTableZone('VehiclesTakenRebalancingFF_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles taken from street for repositioning';
        plotTableZone('VehiclesTakenBothFF_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesTakenInTotalAggT
function tableVehiclesTakenInTotalAggT(param, xlsfile, sheet1, sheet2, sheet3, statI, statF, zoneI, zoneF, obj)
    % Function to create table with vehicles taken in every station+zone
    % at every hour

    % Generate first column with ID
    ID = [];
    for izone=zoneI:zoneF
        ID(end+1,1) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    obj.VehiclesTakenRechargingTotal_AggT = table(ID);
    obj.VehiclesTakenRebalancingTotal_AggT = table(ID);
    obj.VehiclesTakenBothTotal_AggT = table(ID);

    % Generate unbalance of cars per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    list_statID = zeros(statF-statI+1,1);
    for istat = 1:statF-statI+1
        list_statID(istat) = obj.MyCity.vStations{istat}.ID;
    end
    %
    list_zoneID = zeros(zoneF-zoneI+1,1);
    for izone = 1:zoneF-zoneI+1
        list_zoneID(izone) = obj.MyCity.vFreeFloatZones{izone}.ID;
    end
    %
    aux1 = zeros(zoneF-zoneI+1, 1);
    aux2 = zeros(zoneF-zoneI+1, 1);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and movements
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                if mov < 0
                    % Check zoneID
                    if stat == 0
                        zoneID = obj.MyCity.vRepoTeams{iteam}.taskList(j);   %(Station/FFzone ID. EXTERNAL INDEXING.)
                    elseif stat == 1
                        statID = obj.MyCity.vRepoTeams{iteam}.taskList(j); % Station ID
                        [k1] = find(list_statID==statID);
                        if size(k1,1) > 0 && size(k1,2) > 0
                            zoneID = obj.MyCity.vFreeFloatZones{obj.MyCity.vStations{k1}.zoneID}.ID;
                        else
                            zoneID = 0;
                        end
                    end
                    if zoneID > 0
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        [k] = find(list_zoneID==zoneID);
                        if size(k,1) > 0 && size(k,2) > 0
                            %%% Check type of task.
                            if priority == 1
                                % Recharging
                                aux1(k) = aux1(k) + 1;
                            elseif priority == 2
                                % Rebalancing
                                aux2(k) = aux2(k) + 1;
                            end
                        end
                    end
                end
            end
        end
    end            

    % Add column to table
    obj.VehiclesTakenRechargingTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1;
    obj.VehiclesTakenRebalancingTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux2;
    obj.VehiclesTakenBothTotal_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = aux1+aux2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesTakenRechargingTotal_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesTakenRebalancingTotal_AggT, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesTakenBothTotal_AggT, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles taken for recharging (priority 1 & 2)';
        unit_labl = '[vehicles]';
        plotTableZone('VehiclesTakenRechargingTotal_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Vehicles taken for relocation (priority 3)';
        plotTableZone('VehiclesTakenRebalancingTotal_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Total vehicles taken for repositioning';
        plotTableZone('VehiclesTakenBothTotal_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableVehiclesLeftInStationAggR
function tableVehiclesLeftInStationAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj)
    % Function to create table with vehicles left in every station
    % aggregated by region

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.VehiclesLeftRechargingSB_AggR = table(Time);
    obj.VehiclesLeftRebalancingSB_AggR = table(Time);
    obj.VehiclesLeftBothSB_AggR = table(Time);
    %
    day1 = zeros(thf-thi+1,1);
    day2 = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if stat == 1 && mov>0
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        %%% Check type of task.
                        % Check the ending time of the task.
                        t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                        %
                        if t >= ti && t < tf
                            if priority == 1
                                % Recharging
                                day1(th) = day1(th) + 1;
                            elseif priority == 2
                                % Rebalancing
                                day2(th) = day2(th) + 1;
                            end
                        end
                    end
                end
            end
        end 
    end

    % Add column to table
    obj.VehiclesLeftRechargingSB_AggR.('VehiclesLeftRechargingSB_AggR') = day1;
    obj.VehiclesLeftRebalancingSB_AggR.('VehiclesLeftRebalancingSB_AggR') = day2;
    obj.VehiclesLeftBothSB_AggR.('VehiclesLeftBothSB_AggR') = day1+day2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesLeftRechargingSB_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesLeftRebalancingSB_AggR, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesLeftBothSB_AggR, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles returned to stations over time for recharging (priority 1 & 2)';
        eje_y = 'Vehicles returned';
        plotTableTime('VehiclesLeftRechargingSB_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Vehicles returned to stations over time for relocation (priority 3)';
        eje_y = 'Vehicles returned';
        plotTableTime('VehiclesLeftRebalancingSB_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Total vehicles returned to stations over time for repositioning';
        eje_y = 'Vehicles returned';
        plotTableTime('VehiclesLeftBothSB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableVehiclesLeftInZoneAggR
function tableVehiclesLeftInZoneAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj)
    % Function to create table with vehicles left in every zone
    % aggregated by region

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.VehiclesLeftRechargingFF_AggR = table(Time);
    obj.VehiclesLeftRebalancingFF_AggR = table(Time);
    obj.VehiclesLeftBothFF_AggR = table(Time);
    %
    day1 = zeros(thf-thi+1,1);
    day2 = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if stat == 0 && mov>0
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        %%% Check type of task.
                        % Check the ending time of the task.
                        t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                        %
                        if t >= ti && t < tf
                            if priority == 1
                                % Recharging
                                day1(th) = day1(th) + 1;
                            elseif priority == 2
                                % Rebalancing
                                day2(th) = day2(th) + 1;
                            end
                        end
                    end
                end
            end
        end
    end
    % Add column to table
    obj.VehiclesLeftRechargingFF_AggR.('VehiclesLeftRechargingFF_AggR') = day1;
    obj.VehiclesLeftRebalancingFF_AggR.('VehiclesLeftRebalancingFF_AggR') = day2;
    obj.VehiclesLeftBothFF_AggR.('VehiclesLeftBothFF_AggR') = day1+day2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesLeftRechargingFF_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesLeftRebalancingFF_AggR, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesLeftBothFF_AggR, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles returned to street over time for recharging (priority 1 & 2)';
        eje_y = 'Vehicles returned';
        plotTableTime('VehiclesLeftRechargingFF_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Vehicles returned to street over time for relocation (priority 3)';
        eje_y = 'Vehicles returned';
        plotTableTime('VehiclesLeftRebalancingFF_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Total vehicles returned to street over time for repositioning';
        eje_y = 'Vehicles returned';
        plotTableTime('VehiclesLeftBothFF_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableVehiclesLeftInTotalAggR
function tableVehiclesLeftInTotalAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj)
    % Function to create table with vehicles left in every station+zone
    % aggregated by region

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.VehiclesLeftRechargingTotal_AggR = table(Time);
    obj.VehiclesLeftRebalancingTotal_AggR = table(Time);
    obj.VehiclesLeftBothTotal_AggR = table(Time);
    %
    day1 = zeros(thf-thi+1,1);
    day2 = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check movements
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if mov > 0
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        %%% Check type of task.
                        % Check the ending time of the task.
                        t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                        %
                        if t >= ti && t < tf
                            if priority == 1
                                % Recharging
                                day1(th) = day1(th) + 1;
                            elseif priority == 2
                                % Rebalancing
                                day2(th) = day2(th) + 1;
                            end
                        end
                    end
                end
            end
        end 
    end
    
    % Add column to table
    obj.VehiclesLeftRechargingTotal_AggR.('VehiclesLeftRechargingTotal_AggR') = day1;
    obj.VehiclesLeftRebalancingTotal_AggR.('VehiclesLeftRebalancingTotal_AggR') = day2;
    obj.VehiclesLeftBothTotal_AggR.('VehiclesLeftBothTotal_AggR') = day1+day2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesLeftRechargingTotal_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesLeftRebalancingTotal_AggR, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesLeftBothTotal_AggR, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles returned over time for recharging (priority 1 & 2)';
        eje_y = 'Vehicles returned';
        plotTableTime('VehiclesLeftRechargingTotal_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Vehicles returned over time for relocation (priority 3)';
        eje_y = 'Vehicles returned';
        plotTableTime('VehiclesLeftRebalancingTotal_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Total vehicles returned over time for repositioning';
        eje_y = 'Vehicles returned';
        plotTableTime('VehiclesLeftBothTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableVehiclesTakenInStationAggR
function tableVehiclesTakenInStationAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj)
    % Function to create table with vehicles taken in every station
    % aggregated by region

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.VehiclesTakenRechargingSB_AggR = table(Time);
    obj.VehiclesTakenRebalancingSB_AggR = table(Time);
    obj.VehiclesTakenBothSB_AggR = table(Time);
    %
    day1 = zeros(thf-thi+1,1);
    day2 = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if stat == 1 && mov<0
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        %%% Check type of task.
                        % Check the ending time of the task.
                        t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                        %
                        if t >= ti && t < tf
                            if priority == 1
                                % Recharging
                                day1(th) = day1(th) + 1;
                            elseif priority == 2
                                % Rebalancing
                                day2(th) = day2(th) + 1;
                            end
                        end
                    end
                end
            end
        end 
    end

    % Add column to table
    obj.VehiclesTakenRechargingSB_AggR.('VehiclesTakenRechargingSB_AggR') = day1;
    obj.VehiclesTakenRebalancingSB_AggR.('VehiclesTakenRebalancingSB_AggR') = day2;
    obj.VehiclesTakenBothSB_AggR.('VehiclesTakenBothSB_AggR') = day1+day2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesTakenRechargingSB_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesTakenRebalancingSB_AggR, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesTakenBothSB_AggR, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles taken on stations over time for recharging (priority 1 & 2)';
        eje_y = 'Vehicles taken';
        plotTableTime('VehiclesTakenRechargingSB_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Vehicles taken on stations over time for relocation (priority 3)';
        eje_y = 'Vehicles taken';
        plotTableTime('VehiclesTakenRebalancingSB_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Total vehicles taken on stations over time for repositioning';
        eje_y = 'Vehicles taken';
        plotTableTime('VehiclesTakenBothSB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableVehiclesTakenInZoneAggR
function tableVehiclesTakenInZoneAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj)
    % Function to create table with vehicles taken in every zone
    % aggregated by region

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.VehiclesTakenRechargingFF_AggR = table(Time);
    obj.VehiclesTakenRebalancingFF_AggR = table(Time);
    obj.VehiclesTakenBothFF_AggR = table(Time);
    %
    day1 = zeros(thf-thi+1,1);
    day2 = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check location and movements
                    stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if stat == 0 && mov<0
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        %%% Check type of task.
                        % Check the ending time of the task.
                        t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                        %
                        if t >= ti && t < tf
                            if priority == 1
                                % Recharging
                                day1(th) = day1(th) + 1;
                            elseif priority == 2
                                % Rebalancing
                                day2(th) = day2(th) + 1;
                            end
                        end
                    end
                end
            end
        end 
    end

    % Add column to table
    obj.VehiclesTakenRechargingFF_AggR.('VehiclesTakenRechargingFF_AggR') = day1;
    obj.VehiclesTakenRebalancingFF_AggR.('VehiclesTakenRebalancingFF_AggR') = day2;
    obj.VehiclesTakenBothFF_AggR.('VehiclesTakenBothFF_AggR') = day1+day2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesTakenRechargingFF_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesTakenRebalancingFF_AggR, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesTakenBothFF_AggR, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles taken on street over time for recharging (priority 1 & 2)';
        eje_y = 'Vehicles taken';
        plotTableTime('VehiclesTakenRechargingFF_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Vehicles taken on street over time for relocation (priority 3)';
        eje_y = 'Vehicles taken';
        plotTableTime('VehiclesTakenRebalancingFF_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Total vehicles taken on street over time for repositioning';
        eje_y = 'Vehicles taken';
        plotTableTime('VehiclesTakenBothFF_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableVehiclesTakenInTotalAggR
function tableVehiclesTakenInTotalAggR(param, xlsfile, sheet1, sheet2, sheet3, thi, thf, obj)
    % Function to create table with vehicles taken in every station+zone
    % aggregated by region

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.VehiclesTakenRechargingTotal_AggR = table(Time);
    obj.VehiclesTakenRebalancingTotal_AggR = table(Time);
    obj.VehiclesTakenBothTotal_AggR = table(Time);
    %
    day1 = zeros(thf-thi+1,1);
    day2 = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        for iteam=1:obj.MyCity.numRepoTeams
            % Find the number of finished tasks
            [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
            task_finish = sum(idx);
            %
            % If there is at least one finished task, check all of them.
            if task_finish > 0
                for j=1:task_finish
                    %
                    %%% Check movements
                    mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                    %
                    if mov < 0
                        priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                        %
                        %%% Check type of task.
                        % Check the ending time of the task.
                        t = obj.MyCity.vRepoTeams{iteam}.taskTime(j);
                        %
                        if t >= ti && t < tf
                            if priority == 1
                                % Recharging
                                day1(th) = day1(th) + 1;
                            elseif priority == 2
                                % Rebalancing
                                day2(th) = day2(th) + 1;
                            end
                        end
                    end
                end
            end
        end 
    end

    % Add column to table
    obj.VehiclesTakenRechargingTotal_AggR.('VehiclesTakenRechargingTotal_AggR') = day1;
    obj.VehiclesTakenRebalancingTotal_AggR.('VehiclesTakenRebalancingTotal_AggR') = day2;
    obj.VehiclesTakenBothTotal_AggR.('VehiclesTakenBothTotal_AggR') = day1+day2;
    %
    % Export table to excel file xlsfile in sheet
    writetable(obj.VehiclesTakenRechargingTotal_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.VehiclesTakenRebalancingTotal_AggR, xlsfile, 'Sheet', sheet2);
    writetable(obj.VehiclesTakenBothTotal_AggR, xlsfile, 'Sheet', sheet3);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Vehicles taken over time for recharging (priority 1 & 2)';
        eje_y = 'Vehicles taken';
        plotTableTime('VehiclesTakenRechargingTotal_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Vehicles taken over time for relocation (priority 3)';
        eje_y = 'Vehicles taken';
        plotTableTime('VehiclesTakenRebalancingTotal_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Total vehicles taken over time for repositioning';
        eje_y = 'Vehicles taken';
        plotTableTime('VehiclesTakenBothTotal_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableVehiclesLeftInStationSumm
function tableVehiclesLeftInStationSumm(obj)
    % Function to create table with vehicles left in every station
    % aggregated by region and time
    day1 = 0;
    day2 = 0;
    %
    % Total time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and movements
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if stat == 1 && mov > 0
                    priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                    %
                    %%% Check type of task.
                    if priority == 1
                        % Recharging
                        day1 = day1 + 1;
                    elseif priority == 2
                        % Rebalancing
                        day2 = day2 + 1;
                    end
                end
            end
        end
    end 
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Vehicles returned - recharge (SB)' 'Cars' num2str(day1,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Vehicles returned - relocation (SB)' 'Cars' num2str(day2,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Total vehicles returned (SB)' 'Cars' num2str(day1+day2,'%4.0f')}];
end

% tableVehiclesLeftInZoneSumm
function tableVehiclesLeftInZoneSumm(obj)
    % Function to create table with vehicles left in every zone
    % aggregated by region and time
    day1 = 0;
    day2 = 0;
    %
    % Total time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and priority of the task
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if stat == 0 && mov > 0
                    priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                    %
                    %%% Check type of task.
                    if priority == 1
                        % Recharging
                        day1 = day1 + 1;
                    elseif priority == 2
                        % Rebalancing
                        day2 = day2 + 1;
                    end
                end
            end
        end
    end
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Vehicles returned - recharge (FF)' 'Cars' num2str(day1,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Vehicles returned - relocation (FF)' 'Cars' num2str(day2,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Total vehicles returned (FF)' 'Cars' num2str(day1+day2,'%4.0f')}];
end

% tableVehiclesLeftInTotalSumm
function tableVehiclesLeftInTotalSumm(obj)
    % Function to create table with vehicles left in every station+zone
    % aggregated by region and time
    day1 = 0;
    day2 = 0;
    %
    % Total time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check movements
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if mov > 0
                    priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                    %
                    %%% Check type of task.
                    if priority == 1
                        % Recharging
                        day1 = day1 + 1;
                    elseif priority == 2
                        % Rebalancing
                        day2 = day2 + 1;
                    end
                end
            end
        end
    end 
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Vehicles returned - recharge (SB+FF)' 'Cars' num2str(day1,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Vehicles returned - relocation (SB+FF)' 'Cars' num2str(day2,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Total vehicles returned (SB+FF)' 'Cars' num2str(day1+day2,'%4.0f')}];
end

% tableVehiclesTakenInStationSumm
function tableVehiclesTakenInStationSumm(obj)
    % Function to create table with vehicles taken in every station
    % aggregated by region and time
    day1 = 0;
    day2 = 0;
    %
    % Total time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and movements
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if stat == 1 && mov < 0
                    priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                    %
                    %%% Check type of task.
                    if priority == 1
                        % Recharging
                        day1 = day1 + 1;
                    elseif priority == 2
                        % Rebalancing
                        day2 = day2 + 1;
                    end
                end
            end
        end
    end 
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Vehicles taken - recharge (SB)' 'Cars' num2str(day1,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Vehicles taken - relocation (SB)' 'Cars' num2str(day2,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Total vehicles taken (SB)' 'Cars' num2str(day1+day2,'%4.0f')}];
end

% tableVehiclesTakenInZoneSumm
function tableVehiclesTakenInZoneSumm(obj)
    % Function to create table with vehicles taken in every zone
    % aggregated by region and time
    day1 = 0;
    day2 = 0;
    %
    % Total time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check location and movements
                stat = obj.MyCity.vRepoTeams{iteam}.taskStat(j); %(1: task in station, 0: task in FF zone)
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if stat == 0 && mov < 0
                    priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
                    %
                    %%% Check type of task.
                    if priority == 1
                        % Recharging
                        day1 = day1 + 1;
                    elseif priority == 2
                        % Rebalancing
                        day2 = day2 + 1;
                    end
                end
            end
        end
    end 
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Vehicles taken - recharge (FF)' 'Cars' num2str(day1,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Vehicles taken - relocation (FF)' 'Cars' num2str(day2,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Total vehicles taken (FF)' 'Cars' num2str(day1+day2,'%4.0f')}];
end

% % tableVehiclesTakenInTotalSumm
% function tableVehiclesTakenInTotalSumm(obj)
%     % Function to create table with vehicles taken in every station+zone
%     % aggregated by region
%     day1 = 0;
%     day2 = 0;
%     %
%     % Total time
%     TotalTime = size(obj.MyCity.vCars{1}.status,2);
%     %
%     for iteam=1:obj.MyCity.numRepoTeams
%         % Find the number of finished tasks
%         [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
%         task_finish = sum(idx);
%         %
%         % If there is at least one finished task, check all of them.
%         if task_finish > 0
%             for j=1:task_finish
%                 %
%                 %%% Check movements
%                 mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
%                 %
%                 if mov < 0
%                     priority = obj.MyCity.vRepoTeams{iteam}.taskType(j); %(1: recharging, 2: rebalancing)
%                     %
%                     %%% Check type of task.
%                     if priority == 1
%                         % Recharging
%                         day1 = day1 + 1;
%                     elseif priority == 2
%                         % Rebalancing
%                         day2 = day2 + 1;
%                     end
%                 end
%             end
%         end
%     end 
%     %
%     % Add row to table
%     obj.Summary = [obj.Summary; {'Vehicles taken - recharge (SB+FF)' 'Cars' num2str(day1,'%4.0f')}];
%     obj.Summary = [obj.Summary; {'Vehicles taken - relocation (SB+FF)' 'Cars' num2str(day2,'%4.0f')}];
%     obj.Summary = [obj.Summary; {'Total vehicles taken (SB+FF)' 'Cars' num2str(day1+day2,'%4.0f')}];
% end

% tableVehiclesTakenInTotalSumm
function tableVehiclesTakenInTotalSumm(obj)
    % Function to create table with vehicles taken in every station+zone
    % aggregated by region
    day1 = 0;
    day2 = 0;
    %
    % Total time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        %
        % If there is at least one finished task, check all of them.
        if task_finish > 0
            for j=1:task_finish
                %
                %%% Check movements
                mov = obj.MyCity.vRepoTeams{iteam}.taskMovements(j); %(-1 vehicle taken, +1 vehicle left)
                %
                if mov < 0
                    day1 = day1 - mov;
                    
                else
                    day2 = day2 + mov;
                    
                end
            end
        end
    end 
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Vehicles taken' 'Bikes' num2str(day1,'%4.0f')}];
    obj.Summary = [obj.Summary; {'Vehicles relocated' 'Bikes' num2str(day2,'%4.0f')}];
end


% tableAvgRepoRateSumm
function tableAvgRepoRateSumm(obj)
    % Function to create table with average repo rates
    ops = 0;
    %
    % Total time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    for iteam=1:obj.MyCity.numRepoTeams
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        % Add the number of finished tasks to the total.
        ops = ops + task_finish;
    end
    % Each repo op has 2 tasks (Task_O + Task_D)
    ops = ops/2;
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. repositioning rate (system)' 'ops/h' num2str(ops/(TotalTime/60),'%4.2f')}];
    obj.Summary = [obj.Summary; {'Avg. repositioning rate (per team)' 'ops/h·team' num2str(ops/((TotalTime/60)*obj.MyCity.numRepoTeams),'%4.2f')}];
end

% tableRepoTeamStatusSumm
function tableRepoTeamStatusSumm(obj)
    % Function to create table with repo teams status
    % Total time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    stat_lab = {'Idle' 'Assigned' 'Repositioning'};
    status = zeros(3,TotalTime); % Repositioning teams status
    %
    for iteam=1:obj.MyCity.numRepoTeams
        %
        for t=1:TotalTime
            status(obj.MyCity.vRepoTeams{iteam}.status(t)+1, t) = status(obj.MyCity.vRepoTeams{iteam}.status(t)+1, t) + 1;
        end
    end
    stat = sum(status,2);
    %
    % Add row to table
    for i=1:3
        obj.Summary = [obj.Summary; {['Team status - ' stat_lab{i}] 'Percentage' num2str(100*stat(i)/(TotalTime*obj.MyCity.numRepoTeams),'%4.2f')}];
    end
end

% % tableTaskTypeSumm
% function tableTaskTypeSumm(obj)
%     % Function to create table with task type percentage
%     task = zeros(2,1);
%     %
%     % Total time
%     TotalTime = size(obj.MyCity.vCars{1}.status,2);
%     %
%     for iteam=1:obj.MyCity.numRepoTeams
%         %
%         % Find the number of finished tasks
%         [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
%         task_finish = sum(idx);
%         % If there is at least one finished task, check all of them.
%         if task_finish > 0
%             for j=1:task_finish
%                 task(obj.MyCity.vRepoTeams{iteam}.taskType(j)) = task(obj.MyCity.vRepoTeams{iteam}.taskType(j))+1; 
%                 %(1: recharging, 2: rebalancing)
%                 %
%             end
%         end
%     end 
%     tot = sum(task);
%     %
%     % Add row to table
%     obj.Summary = [obj.Summary; {'Recharging tasks (priority 1 & 2)' 'Percentage' num2str(100*task(1)/tot,'%4.2f')}];
%     obj.Summary = [obj.Summary; {'Rebalancing tasks (priority 3)' 'Percentage' num2str(100*task(2)/tot,'%4.2f')}];
% end

function tableTaskTypeSumm(obj) %%% FAKE!!! REPO DISTANCE
    % Function to create table with total reposistioning travel distance
    tot_dist = 0;
    tot_tasks = 0;
    uncount_task = 0;
    %
    % Total time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    num_teams = obj.MyCity.numRepoTeams;
    
    for iteam=1:num_teams
        %
        % Find the number of finished tasks
        [idx,~] = find(obj.MyCity.vRepoTeams{iteam}.taskTime<=TotalTime);
        task_finish = sum(idx);
        tot_tasks = tot_tasks + task_finish;
        if task_finish == 1
        
        uncount_task = uncount_task +1;
        % If there is at least one finished task, check all of them.
        elseif task_finish > 1
            uncount_task = uncount_task +1;
            for j=2:task_finish
                
                idx_1 = obj.MyCity.vRepoTeams{iteam}.taskList(j-1);
                idx_2 = obj.MyCity.vRepoTeams{iteam}.taskList(j);
                tot_dist = tot_dist + ...
                    sim_dist(obj.MyCity.vStations{idx_1}.X, obj.MyCity.vStations{idx_1}.Y,...
                    obj.MyCity.vStations{idx_2}.X, obj.MyCity.vStations{idx_2}.Y);
            end
        end
    end
    
    avg_dist = tot_dist/(tot_tasks-uncount_task);
    tot_dist = tot_dist+avg_dist*uncount_task ;
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Repositioning distance (avg)' 'm' num2str(avg_dist,'%4.2f')}];
    obj.Summary = [obj.Summary; {'Repositioning distance (tot)' 'Km' num2str(tot_dist/1000,'%4.2f')}];
end


% tableTaskOrigDestSumm
function tableTaskOrigDestSumm(obj)
    % Function to create table with task orig-dest percentage
    task = zeros(2,2); % FF - SB
    %
    for iteam=1:obj.MyCity.numRepoTeams
        %
        % Find the first Task_O of the list (movements < 0)
        TaskO_list = find(obj.MyCity.vRepoTeams{iteam}.taskMovements<0);

        % If there is at least one assigned Task_O
        if numel(TaskO_list)>0
            %
            for k=TaskO_list(1):2:TaskO_list(end)
                orig = obj.MyCity.vRepoTeams{iteam}.taskStat(k);   %(1: task in station, 0: task in FF zone) 
                dest = obj.MyCity.vRepoTeams{iteam}.taskStat(k+1);
                %
                task(orig+1, dest+1) = task(orig+1, dest+1) + 1;
            end
        end
    end 
    tot = sum(sum(task));
    %
    % Add row to table
    obj.Summary = [obj.Summary; {'Tasks FF -> FF' 'Percentage' num2str(100*task(1,1)/tot,'%4.2f')}];
    obj.Summary = [obj.Summary; {'Tasks FF -> SB' 'Percentage' num2str(100*task(1,2)/tot,'%4.2f')}];
    obj.Summary = [obj.Summary; {'Tasks SB -> FF' 'Percentage' num2str(100*task(2,1)/tot,'%4.2f')}];
    obj.Summary = [obj.Summary; {'Tasks SB -> SB' 'Percentage' num2str(100*task(2,2)/tot,'%4.2f')}];
end

