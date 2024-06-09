function outputStationOccupancy_reduced(param, folder, ~, ~, StationI, StationF, obj)
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
        tableEmptyFullStationAggT(param, xlsfile, sheet1, sheet2, StationI, StationF, obj);

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



% tableEmptySlotsInStationAggT
function tableEmptyFullStationAggT(param, xlsfile, sheet1, sheet2, statI, statF, obj)
    % Function to create tables with fraction of time spent full or empty
    % by stations.

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
            if numcars == 0
                aux1(istat,t) = 100;
            end
            if numcars == capacity
                aux2(istat,t) = 100;
            end
%             if capacity > 0 && capacity < 9999 % Only if restricted capacity
%                 aux1(istat,t) = capacity - numcars; % Empty slots
%                 aux2(istat,t) = 100 * numcars / capacity; % Occupancy (%)
%             else
%                 aux1(istat,t) = NaN;
%                 aux2(istat,t) = NaN;
%             end
        end

        % Add column to table
        obj.EmptySlotsSB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux1,2);
        obj.OccupancySB_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux2,2);
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(obj.EmptySlotsSB_AggT, xlsfile, 'Sheet', sheet1);
    writetable(obj.OccupancySB_AggT, xlsfile, 'Sheet', sheet2);
    
%     modifile = 'Results/ERR2_36/20230402_124415_Final_City_Variables_output/StationOccupancy/Tables_station_occupancy_comb.xlsx';
%     obj.EmptySlotsSB_AggT = readtable(modifile, 'Sheet', sheet1);
%     obj.OccupancySB_AggT = readtable(modifile, 'Sheet', sheet2);

    % Plot table graphically by stations
    if param.GeneratePlots
        titulo = 'Average number of empty stations';
        unit_labl = 'Time spent empty [%]';
        plotTableStation('EmptySlotsSB_AggT', xlsfile, obj, titulo, unit_labl);
        titulo = 'Average number of full stations';
        unit_labl = 'Time spent full [%]';
        plotTableStation('OccupancySB_AggT', xlsfile, obj, titulo, unit_labl);
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

