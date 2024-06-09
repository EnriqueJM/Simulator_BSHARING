function outputStationOccupancy(param, folder, thi, thf, StationI, StationF, obj)
    % Function to generate results (tables & plots) about station occupancy
    
    if param.verbose
        disp('');
        disp('CREATING STATION OCCUPANCY TABLES');
    end
    
    % Create Vehicles folder
    [status, msg, msgID] = mkdir([pwd '/' folder],'StationOccupancy');
    if status == 0
        error('Error: Output folder could not be created');
    end
    
    xlsfile = [folder '/StationOccupancy/Tables_station_occupancy.xlsx'];
    if isfile(xlsfile)
        delete(xlsfile);
    end

    %%%%%%%%%%%%%%%%%%%%%%
    %    HOURLY TABLES   % 
    %%%%%%%%%%%%%%%%%%%%%%
    if param.Hourly
        
        % EmptySlotsInStationTime
        if param.verbose
            disp('Creating table EmptySlotsInStationTime');
        end
        %
        sheet1 = 'EmptySlotsInStationTime';
        sheet2 = 'OccupancyInStationTime';
        tableEmptySlotsInStationTime(param, xlsfile, sheet1, sheet2, thi, thf, StationI, StationF, obj);

        % EmptyChargersInStationTime
        if param.verbose
            disp('Creating table EmptyChargersInStationTime');
        end
        %
        sheet1 = 'EmptyChargersInStationTime';
        sheet2 = 'OccupancyChargersInStationTime';
        tableEmptyChargersInStationTime(param, xlsfile, sheet1, sheet2, thi, thf, StationI, StationF, obj);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %    TIME AGGREGATION   % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggT
        
        % EmptySlotsInStationAggT
        if param.verbose
            disp('Creating table EmptySlotsInStationAggT');
        end
        %
        sheet1 = 'EmptySlotsInStationAggT';
        sheet2 = 'OccupancyInStationAggT';
        tableEmptySlotsInStationAggT(param, xlsfile, sheet1, sheet2, StationI, StationF, obj);

%         % EmptyChargersInStationAggT
%         if param.verbose
%             disp('Creating table EmptyChargersInStationAggT');
%         end
%         %
%         sheet1 = 'EmptyChargersInStationAggT';
%         sheet2 = 'OccupancyChargersInStationAggT';
%         tableEmptyChargersInStationAggT(param, xlsfile, sheet1, sheet2, StationI, StationF, obj);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %   REGION AGGREGATION  % 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if param.AggR
        
%         % EmptySlotsInStationAggR
%         if param.verbose
%             disp('Creating table EmptySlotsInStationAggR');
%         end
%         %
%         sheet1 = 'EmptySlotsInStationAggR';
%         sheet2 = 'OccupancyInStationAggR';
%         tableEmptySlotsInStationAggR(param, xlsfile, sheet1, sheet2, thi, thf, obj);
% 
%         % EmptyChargersInStationAggR
%         if param.verbose
%             disp('Creating table EmptyChargersInStationAggR');
%         end
%         %
%         sheet1 = 'EmptyChargersInStationAggR';
%         sheet2 = 'OccupancyChargersInStationAggR';
%         tableEmptyChargersInStationAggR(param, xlsfile, sheet1, sheet2, thi, thf, obj);
    end
    
    %%%%%%%%%%%%%
    %  SUMMARY  %
    %%%%%%%%%%%%%
        
    % EmptySlotsInStationSumm
    if param.verbose
        disp('Creating table EmptySlotsInStationSumm');
    end
    %
    tableEmptySlotsInStationSumm(obj);

    % EmptyChargersInStationSumm
    if param.verbose
        disp('Creating table EmptyChargersInStationSumm');
    end
    %
    tableEmptyChargersInStationSumm(obj);

end

% tableEmptySlotsInStationTime
function tableEmptySlotsInStationTime(param, xlsfile, sheet1, sheet2, thi, thf, statI, statF, obj)
    % Function to create tables with empty slots / occupancy in every station
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
    obj.EmptySlotsSB_dt = table(ID, Name);
    obj.OccupancySB_dt = table(ID, Name);

    % Generate number of empty slots per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux1 = zeros(statF-statI+1, tf-ti);
        aux2 = zeros(statF-statI+1, tf-ti);
        %
        for t=1:tf-ti
            % Count number of cars in station at time t
            for istat=1:size(list_stat,2)
                capacity = obj.MyCity.vStations{list_stat(istat)}.capacity;
                numcars = size(obj.MyCity.vStations{list_stat(istat)}.vlistCars{(th-1)*60+t},2);
                %
                if capacity > 0 && capacity < 9999 % Only if restricted capacity
                    aux1(istat,t) = capacity - numcars; % Empty slots
                    aux2(istat,t) = 100 * numcars / capacity; % Occupancy (%)
                else
                    aux1(istat,t) = NaN;
                    aux2(istat,t) = NaN;
                end
            end
        end

        % Add column to table
        obj.EmptySlotsSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux1,2);
        obj.OccupancySB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux2,2);
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.EmptySlotsSB_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.OccupancySB_dt, xlsfile, 'Sheet', sheet2);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total number of free parking slots in stations per hour';
        unit_labl = '[parking slots]';
        plotTableStation('EmptySlotsSB_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Occupancy of parking slots in stations per hour';
        unit_labl = 'Occupancy [%]';
        plotTableStation('OccupancySB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableEmptyChargersInStationTime
function tableEmptyChargersInStationTime(param, xlsfile, sheet1, sheet2, thi, thf, statI, statF, obj)
    % Function to create tables with empty chargers / occupancy in every station
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
    obj.EmptyChargersSB_dt = table(ID, Name);
    obj.OccupancyChargersSB_dt = table(ID, Name);

    % Generate number of empty chargers per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        aux1 = zeros(statF-statI+1, tf-ti);
        aux2 = zeros(statF-statI+1, tf-ti);
        %
        for t=1:tf-ti
            % Count number of cars charging in station at time t
            for istat=1:size(list_stat,2)
                capacity = obj.MyCity.vStations{list_stat(istat)}.numChargers;
                numcars = size(obj.MyCity.vStations{list_stat(istat)}.vlistCharging{(th-1)*60+t},2);
                %
                if capacity > 0 && capacity < 9999 % Only if restricted capacity
                    aux1(istat,t) = capacity - numcars; % Empty chargers
                    aux2(istat,t) = 100 * numcars / capacity; % Occupancy (%)
                else
                    aux1(istat,t) = NaN;
                    aux2(istat,t) = NaN;
                end
            end
        end

        % Add column to table
        obj.EmptyChargersSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux1,2);
        obj.OccupancyChargersSB_dt.(['T' num2str(ti+1) '-' num2str(tf)]) = mean(aux2,2);
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.EmptyChargersSB_dt, xlsfile, 'Sheet', sheet1);
    writetable(obj.OccupancyChargersSB_dt, xlsfile, 'Sheet', sheet2);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total number of free charging slots in stations per hour';
        unit_labl = '[chargers]';
        plotTableStation('EmptyChargersSB_dt', xlsfile, obj, titulo, unit_labl);
        titulo = 'Occupancy of chargers in stations per hour';
        unit_labl = 'Occupancy [%]';
        plotTableStation('OccupancyChargersSB_dt', xlsfile, obj, titulo, unit_labl);
    end
end

% tableEmptySlotsInStationAggT
function tableEmptySlotsInStationAggT(param, xlsfile, sheet1, sheet2, statI, statF, obj)
    % Function to create tables with empty slots / occupancy in every station
    % aggregated by time (mean)

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
    obj.EmptySlotsSB_AggT = table(ID, Name);
    obj.OccupancySB_AggT = table(ID, Name);

    % Generate number of empty slots per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    aux1 = zeros(statF-statI+1, TotalTime);
    aux2 = zeros(statF-statI+1, TotalTime);
    %
    for istat=1:size(list_stat,2)
        %
        for t=1:TotalTime
            % Count capacities in station at time t
            capacity = obj.MyCity.vStations{list_stat(istat)}.capacity;
            numcars = size(obj.MyCity.vStations{list_stat(istat)}.vlistCars{t},2);
            %
            if capacity > 0 && capacity < 9999 % Only if restricted capacity
                aux1(istat,t) = (capacity - numcars); % Empty slots
                aux2(istat,t) = 100 * numcars / capacity; % Occupancy (%)
%                 aux2(istat,t) = numcars; % Occupancy (%)
            else
                aux1(istat,t) = NaN;
                aux2(istat,t) = NaN;
            end
        end
    end
    %
    % Add column to table
    obj.EmptySlotsSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux1,2);
    obj.OccupancySB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux2,2);
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.EmptySlotsSB_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.OccupancySB_AggT, xlsfile, 'Sheet', sheet2);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total number of free parking slots in stations';
        unit_labl = '[parking slots]';
        plotTableStation('EmptySlotsSB_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Occupancy of parking slots in stations';
        unit_labl = 'Occupancy [%]';
        plotTableStation('OccupancySB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableEmptyChargersInStationAggT
function tableEmptyChargersInStationAggT(param, xlsfile, sheet1, sheet2, statI, statF, obj)
    % Function to create tables with empty chargers / occupancy in every station
    % aggregated by time (mean)

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
    obj.EmptyChargersSB_AggT = table(ID, Name);
    obj.OccupancyChargersSB_AggT = table(ID, Name);

    % Generate number of empty slots per station in every hour as mean of
    % 60min
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    aux1 = zeros(statF-statI+1, TotalTime);
    aux2 = zeros(statF-statI+1, TotalTime);
    %
    for istat=1:size(list_stat,2)
        %
        for t=1:TotalTime
            % Count capacities in station at time t
            capacity = obj.MyCity.vStations{list_stat(istat)}.numChargers;
            numcars = size(obj.MyCity.vStations{list_stat(istat)}.vlistCharging{t},2);
            %
            if capacity > 0 && capacity < 9999 % Only if restricted capacity
                aux1(istat,t) = capacity - numcars; % Empty slots
                aux2(istat,t) = 100 * numcars / capacity; % Occupancy (%)
            else
                aux1(istat,t) = NaN;
                aux2(istat,t) = NaN;
            end
        end

        % Add column to table
        obj.EmptyChargersSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux1,2);
        obj.OccupancyChargersSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux2,2);
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.EmptyChargersSB_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.OccupancyChargersSB_AggT, xlsfile, 'Sheet', sheet2);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total number of free charging slots in stations';
        unit_labl = '[chargers]';
        plotTableStation('EmptyChargersSB_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Occupancy of chargers in stations';
        unit_labl = 'Occupancy [%]';
        plotTableStation('OccupancyChargersSB_AggT', xlsfile, obj, titulo, unit_labl);
    end
end

% tableEmptySlotsInStationAggR
function tableEmptySlotsInStationAggR(param, xlsfile, sheet1, sheet2, thi, thf, obj)
    % Function to create tables with empty slots / occupancy in every station
    % aggregated by region (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.EmptySlotsSB_AggR = table(Time);
    obj.OccupancySB_AggR = table(Time);
    %
    day1 = zeros(thf-thi+1,1);
    day2 = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        aux1 = [];
        aux2 = [];
        for t=1:tf-ti
            % Count capacities in station at time t
            for istat=1:obj.MyCity.numStations
                capacity = obj.MyCity.vStations{istat}.capacity;
                numcars = size(obj.MyCity.vStations{istat}.vlistCars{(th-1)*60+t},2);
                %
                if capacity > 0 && capacity < 9999 % Only if restricted capacity
                    aux1(end+1) = capacity - numcars; % Empty slots
                    aux2(end+1) = 100 * numcars / capacity; % Occupancy (%)
%                 else
%                     aux1(end+1) = NaN;
%                     aux2(end+1) = NaN;
                end
            end
        end
        %
        day1(th) = mean(aux1);
        day2(th) = mean(aux2);
    end
    
    % Add column to table
    obj.EmptySlotsSB_AggR.('EmptySlotsSB_AggR') = day1;
    obj.OccupancySB_AggR.('OccupancySB_AggR') = day2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.EmptySlotsSB_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.OccupancySB_AggR, xlsfile, 'Sheet', sheet2);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total number of free parking slots in stations';
        eje_y = 'Free parking slots';
        plotTableTime('EmptySlotsSB_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Average occupancy of parking slots in stations';
        eje_y = 'Average SB parking occupancy [%]';
        plotTableTime('OccupancySB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableEmptyChargersInStationAggR
function tableEmptyChargersInStationAggR(param, xlsfile, sheet1, sheet2, thi, thf, obj)
    % Function to create tables with empty chargers / occupancy in every station
    % aggregated by region (mean)

    % Generate first column with labels
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    Time = {};
    for th = thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        Time(end+1,1) = {['T' num2str(ti+1) '-' num2str(tf)]};
    end
    %
    obj.EmptyChargersSB_AggR = table(Time);
    obj.OccupancyChargersSB_AggR = table(Time);
    %
    day1 = zeros(thf-thi+1,1);
    day2 = zeros(thf-thi+1,1);
    for th=thi:thf
        ti = (th-1)*60;
        tf = min(TotalTime,th*60);
        %
        aux1 = [];
        aux2 = [];
        for t=1:tf-ti
            % Count capacities in station at time t
            for istat=1:obj.MyCity.numStations
                capacity = obj.MyCity.vStations{istat}.numChargers;
                numcars = size(obj.MyCity.vStations{istat}.vlistCharging{(th-1)*60+t},2);
                %
                if capacity > 0 && capacity < 9999 % Only if restricted capacity
                    aux1(end+1) = capacity - numcars; % Empty slots
                    aux2(end+1) = 100 * numcars / capacity; % Occupancy (%)
%                 else
%                     aux1(end+1) = NaN;
%                     aux2(end+1) = NaN;
                end
            end
        end
        %
        day1(th) = mean(aux1);
        day2(th) = mean(aux2);
    end
    
    % Add column to table
    obj.EmptyChargersSB_AggR.('EmptyChargersSB_AggR') = day1;
    obj.OccupancyChargersSB_AggR.('OccupancyChargersSB_AggR') = day2;
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.EmptyChargersSB_AggR, xlsfile, 'Sheet', sheet1);
    writetable(obj.OccupancyChargersSB_AggR, xlsfile, 'Sheet', sheet2);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Total number of free charging slots in stations';
        eje_y = 'Free chargers';
        plotTableTime('EmptyChargersSB_AggR', xlsfile, obj, titulo, eje_y);
        titulo = 'Average occupancy of chargers in stations';
        eje_y = 'Average charger occupancy [%]';
        plotTableTime('OccupancyChargersSB_AggR', xlsfile, obj, titulo, eje_y);
    end
end

% tableEmptySlotsInStationSumm
function tableEmptySlotsInStationSumm(obj)
    % Function to create tables with empty slots / occupancy in every station
    % aggregated by region and time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    aux1 = [];
    aux2 = [];
    for t=1:TotalTime
        % Count capacities in station at time t
        for istat=1:obj.MyCity.numStations
            capacity = obj.MyCity.vStations{istat}.capacity;
            numcars = size(obj.MyCity.vStations{istat}.vlistCars{t},2);
            %
            if capacity > 0 && capacity < 9999 % Only if restricted capacity
                aux1(end+1) = capacity - numcars; % Empty slots
                aux2(end+1) = 100 * numcars / capacity; % Occupancy (%)
%             else
%                 aux1(end+1) = NaN;
%                 aux2(end+1) = NaN;
            end
        end
    end
    
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. number of empty parking slots (SB)' 'Slots' num2str(mean(aux1),'%6.2f')}];
    obj.Summary = [obj.Summary; {'Occupancy of SB parkings' 'Percentage' num2str(mean(aux2),'%6.2f')}];
end

% tableEmptyChargersInStationSumm
function tableEmptyChargersInStationSumm(obj)
    % Function to create tables with empty chargers / occupancy in every station
    % aggregated by region and time
    TotalTime = size(obj.MyCity.vCars{1}.status,2);
    %
    aux1 = [];
    aux2 = [];
    for t=1:TotalTime
        % Count capacities in station at time t
        for istat=1:obj.MyCity.numStations
            capacity = obj.MyCity.vStations{istat}.numChargers;
            numcars = size(obj.MyCity.vStations{istat}.vlistCharging{t},2);
            %
            if capacity > 0 && capacity < 9999 % Only if restricted capacity
                aux1(end+1) = capacity - numcars; % Empty slots
                aux2(end+1) = 100 * numcars / capacity; % Occupancy (%)
%             else
%                 aux1(end+1) = NaN;
%                 aux2(end+1) = NaN;
            end
        end
    end
    
    % Add row to table
    obj.Summary = [obj.Summary; {'Avg. number of empty chargers' 'Chargers' num2str(mean(aux1),'%6.2f')}];
    obj.Summary = [obj.Summary; {'Occupancy of chargers' 'Percentage' num2str(mean(aux2),'%6.2f')}];
end

