function [vRepoTeamsOut, vStationsOut, vBikesOut, vRepoPool, idle_cntr] = ...
    repoTeamAction_bikSB(t, vRepoTeams, vStations, vBikes,...
    param, minBatteryLevel)
% OPTIMREPOTASKDUAL - ver 1.0
%   Selects the optimum station locations for the simulation. The total
%   number of stations and a candidate list are the main inputs.
%   Three different cases are considered:
%       - Select the first stations in the list.
%       - Select all stations in the list and create new ones on empty
%         zones. (No complete coverage.)
%       - Select all stations in the list and create new ones. (Complete
%         coverage.)
%   INPUTS:
%   - NStations -> Total number of stations in the system.
%   - vStationslist -> {Array Nx1} Array of station class objects. From an
%                      excel file with the list of possible stations.              
%   - vZones -> {Array Mx1} Array of FF_zone class objects.
%   - vServArea -> {Array Mx1} Array of structs with the geometry of zones.
%   - TotalCarsSB -> Total number of cars on stations.
%   - TotalCarsSB -> Total number of cars on streets.
%   - OD - {Array 24x1} Array with hourly demand matrices (sparse).
%   - percParking -> Fraction of demand parking on stations.
%   - Wmax -> Maximum walking distance.
%   - TotalTime -> Total number of time steps.
%   OUTPUTS:
%   - vStationsOut -> {Array NStationsx1} Array of station class objects.
%   - vZonesOut -> {Array Mx1} Array of FF_zone class objects.
                
%%
% costRepo = param.costRepo/60; %In €/min
% tskDur = param.taskDuration;
% BPenSB = [param.costLostSB, param.costLostSB];
% v_k = param.repoSpeed *1000/60;


% Initialize the repositioning team pool and idle counter.
    vRepoPool = {};
    idle_cntr = 0;
    
    for iteam = 1: length(vRepoTeams)
        if vRepoTeams{iteam}.status(t) == 1   
            %%% Check current task.   
            currnt = vRepoTeams{iteam}.taskCurrent;

            %%% If task is finished, make the movement.
            if t==vRepoTeams{iteam}.taskTime(currnt)

                % Check the station and movements.
                istat = vRepoTeams{iteam}.taskList(currnt);
                y_i = vRepoTeams{iteam}.taskMovements(currnt);
                % Account for the number of available vehicles and/or slots.
                % - If POSITIVE movements, it would be the minimum between the
                % ideal movements and current number of bikes carried by the
                % team.
                % - If NEGATIVE movements, if would be the maximum between the
                % ideal movements and the unused capacity of the team.      
                if y_i >=0 
                    % Account for the number free slots in the station.
                    y_stat = vStations{istat}.capacity ...
                        - numel(vStations{istat}.listCars);
                    % Account for number of vehicles in the team.
                    y_team = numel(vRepoTeams{iteam}.listBikes);
                    % Number of real movements.
                    y_end = min([y_i, y_stat, y_team]);

                    %%% Remove those vehicles from the team.
                    movd = vRepoTeams{iteam}.listBikes(1:y_end);
                    vRepoTeams{iteam}.listBikes(1:y_end) = [];
                    vRepoTeams{iteam}.vehicles(t:end) = vRepoTeams{iteam}.vehicles(t) - y_end;
                    %%% Add vehicles to the station.
                    vStations{istat}.listCars = [vStations{istat}.listCars, movd];          %%% CONTROLAR ESTO

                    for j=1:numel(movd)
                        bikeID = movd(j);
                        if vBikes{bikeID}.isElectric == 1 && vBikes{bikeID}.batteryLevel(t) < minBatteryLevel
                            vBikes{bikeID}.status(t:end) = 4;
                        else
                            vBikes{bikeID}.status(t:end) = 0;
                        end
                    end
                else
                    % Account for the number of available vehicles in the station.
                    y_stat = 0;
                    rem_list = [];
                    list = vStations{istat}.listCars;
                    if isempty(list) == 0
                        for j = 1:numel(list)
                            if vBikes{list(j)}.status(t) == 0
                                y_stat = y_stat + 1;
                                rem_list = [rem_list, j];
                            end
                        end
                    end
                    % Account for the number of available slots in the team.
                    y_team = vRepoTeams{iteam}.capacity ...
                        - numel(vRepoTeams{iteam}.listBikes);
                    % Number of real movements.
                    y_end = min([-y_i, y_stat, y_team]); %%% POSITIVE by def.

                    %%% Remove the vehicles from the station.
                    rem_list = rem_list(1:y_end);
                    movd = list(rem_list);
                    vStations{istat}.listCars(rem_list) = [];
                    %%% Add vehicles to the team.
                    vRepoTeams{iteam}.listBikes = [vRepoTeams{iteam}.listBikes, movd];
                    vRepoTeams{iteam}.vehicles(t:end) = vRepoTeams{iteam}.vehicles(t) + y_end;
                    for j=1:numel(movd)
                        bikeID = movd(j);
                        vBikes{bikeID}.status(t:end) = 3;
                    end
                end
                %
                %%% UPDATE TEAM
                % Update position of team (at the end of the task).
                vRepoTeams{iteam}.X(t:end) = vStations{istat}.X;
                vRepoTeams{iteam}.Y(t:end) = vStations{istat}.Y;
                % Update status
                if param.repoMethod == 3
                    % If only route strategy is followed, next task.
                    if numel(vRepoTeams{iteam}.taskList)>currnt
                        vRepoTeams{iteam}.taskCurrent = currnt + 1;
                    end                    
                else
                    % If other strategy is followed (dynamic assignment),
                    % change to idle and add to repo pool.
                    vRepoTeams{iteam}.status(t:end) = 0;
                    vRepoPool{end+1}=vRepoTeams{iteam};
                    idle_cntr = idle_cntr + 1;
                end
                %
                %%% UPDATE STATION: EXPECTED DEMAND
                %%% Check movements. Change if different from expected.
                if y_end ~= abs(y_i)
                    vStations = update_acc_demand_forecast(vStations,...
                        istat, y_i, t, istat, y_end, t);
                    % Change movements on the task array
                    vRepoTeams{iteam}.taskMovements(currnt) = y_end * y_i/abs(y_i);
                end               
            else
                % Make a team copy, change the position and inventory, and add
                % it to the pool.
                TeamCopy = copyRepoTeam(vRepoTeams{iteam},t);
                % Change position.
                idx_stat = vRepoTeams{iteam}.taskList(currnt);
                TeamCopy.X(t:end) = vStations{idx_stat}.X;
                TeamCopy.Y(t:end) = vStations{idx_stat}.Y;
                % Add copy to idle pool.
                vRepoPool{end+1}=TeamCopy;
            end
        else
            % If repo team is idle, add to the pool directly.
            vRepoPool{end+1}=vRepoTeams{iteam};
            idle_cntr = idle_cntr + 1;
            
        end
    end
    
    vRepoTeamsOut = vRepoTeams;
    vStationsOut = vStations;
    vBikesOut = vBikes;
    
end


%% AUX FUN (UNUSED)
% function check_next_task(t, iteam, vRepoTeams, vStations, vBikes, param)
% 
%     costRepo = param.costRepo/60; %In €/min
%     tskDur = param.taskDuration;
%     BPenSB = [param.costLostSB, param.costLostSB];
%     v_k = param.repoSpeed *1000/60;
% 
%     currnt = vRepoTeams{iteam}.taskCurrent;
%     
%     % If repositioning is mixed and there are more tasks in the list, run
%     % the process.
%     if param.repoMethod == 2 && numel(vRepoTeams{iteam}.taskList)>=currnt
%         %%% Read data
%         % Initialize utility matrix, time cost, and movements.
%         UT = zeros(numel(vStations), 1);
%         T_trip_1 = zeros(numel(vStations), 1);
%         T_trip_2 = zeros(numel(vStations), 1);
%         y_end = zeros(numel(vStations), 1);
%         %
%         % Read current vehicles, capacity, and position of the team.
%         y_v = numel(vRepoTeams{iteam}.listBikes);
%         C_v = vRepoTeams{iteam}.capacity;
%         XT = vRepoTeams{iteam}.X(t);
%         YT = vRepoTeams{iteam}.Y(t);
%         %
%         % Read position and stationID of next task.
%         inext = vRepoTeams{iteam}.taskList(currnt);
%         XS_2 = vStations{inext}.X;
%         YS_2 = vStations{inext}.Y;
%         %
%         % Loop for all stations
%         for istat=1:numel(vStations)
%             
%             % Read station position, capacity, and expected demand.
%             XS_1 = vStations{istat}.X;
%             YS_1 = vStations{istat}.Y;
%             Cap_i = vStations{istat}.capacity;
%             req_T = vStations{istat}.accRequests(end)...
%                 - vStations{istat}.accRequests(t);
%             ret_T = vStations{istat}.accReturns(end)...
%                 - vStations{istat}.accReturns(t);
%             
%             % Account number of cars.
%             m_idle = 0;
%             m_all = 0;
%             list = vStations{istat}.listCars;
%             if isempty(list) == 0
%                 for j = 1:numel(list)
%                     if vBikes{list(j)}.status(t) == 0
%                         m_idle = m_idle + 1;
%                     end
%                     m_all = m_all + 1;
%                 end
%             end
%             y_i = vStations{istat}.optCars(t) - m_idle;
%             
%             % Check how many bikes can be moved to achieve the optimum.
%             % - If POSITIVE movements, it would be the minimum between the
%             % ideal movements and current number of bikes carried by the
%             % team.
%             % - If NEGATIVE movements, if would be the maximum between the
%             % ideal movements and the unused capacity of the team.
%             if y_i >=0
%                 y_end(istat) = min([y_i, y_v]);
%             else
%                 y_end(istat) = -1 * min([-y_i, C_v-y_v]);
%             end
%             % Inv level at the end
%             m_end = m_idle + y_end(istat);
%             % Expected penalties before and after the task.
%             E_NSP_ini = NSPenalties(m_idle, req_T, ret_T, Cap_i, BPenSB);
%             E_NSP_end = NSPenalties(m_end, req_T, ret_T, Cap_i, BPenSB);
%             % Time spent on task.
%             T_trip_1(istat) = sim_dist(XT, YT, XS_1, YS_1)/v_k + 6 ...
%                 + tskDur * abs(y_end(istat));
%             % Time spent on travelling to following task.
%             T_trip_2(istat) = sim_dist(XS_1, YS_1, XS_2, YS_2)/v_k + 6;
%             %
%             % Utility
%             if y_end(istat)~=0
%                 UT(istat) = E_NSP_ini - E_NSP_end;
%             else
%                 UT(istat) = NaN; % Inf or NaN not possible.
%             end
%         end
%         
%         %% STEP 2: CHECK POSSIBLE MODIFICATIONS - DECISION
%         
%         %%% Check best
%         
%         UT_add = UT - (T_trip_1 - T_trip_2)*costRepo...
%             - UT(inext) + T_trip_1(inext)*costRepo;
%         
%         T_sum = T_trip_1 + T_trip_2;
%         T_fit = vRepoTeams{iteam}.taskTime(currnt) - t;
%         
%         UT_add_cr = (T_sum<=T_fit).*UT_add;
%         
%         [val_max, idx_max] = max(UT_add_cr, [], 'omitnan');
%         if ~isnan(val_max)
%             if (val_max > 0) &&(idx_max ~= inext)
%                 %%% If utility of visiting the best intermediate station is
%                 %%% positive, include it.
%                 
%                 %%% Intercalate task to the list
%                 vRepoTeams{iteam}.taskList = [vRepoTeams{iteam}.taskList(1:currnt-1),...
%                     idx_max, vRepoTeams{iteam}.taskList(currnt:end)];
%                 vRepoTeams{iteam}.taskStat = [vRepoTeams{iteam}.taskStat(1:currnt-1),...
%                     1, vRepoTeams{iteam}.taskStat(currnt:end)];
%                 vRepoTeams{iteam}.taskType = [vRepoTeams{iteam}.taskType(1:currnt-1),...
%                     2, vRepoTeams{iteam}.taskType(currnt:end)];
%                 vRepoTeams{iteam}.taskMovements = [vRepoTeams{iteam}.taskMovements(1:currnt-1),...
%                     y_end(idx_max), vRepoTeams{iteam}.taskMovements(currnt:end)];
%                 vRepoTeams{iteam}.taskTime = [vRepoTeams{iteam}.taskTime(1:currnt-1),...
%                     vRepoTeams{iteam}.taskTime(currnt-1)+ceil(T_trip_1(idx_max)),...
%                     vRepoTeams{iteam}.taskTime(currnt:end)];
%                 % Correction of next times
%                 vRepoTeams{iteam}.taskTime(currnt+1:end) = ...
%                     vRepoTeams{iteam}.taskTime(currnt+1:end)...
%                     + ceil(T_trip_1(idx_max) + T_trip_2(idx_max) - T_trip_1(inext));
%             end
%         else
%             %%% If not, check if it would be better to skip the next task.
%             if numel(vRepoTeams{iteam}.taskList) >= currnt+1
%                 inext_2 = vRepoTeams{iteam}.taskList(currnt+1);
%                 UT_sbt = UT(inext_2) - T_trip_1(inext_2)*costRepo...
%                     - UT(inext)...
%                     + (T_trip_1(inext) + T_trip_2(inext_2))*costRepo;
%                 
%                 if UT_sbt > 0
%                     %%% If utility is positive, skip next task.
%                     vRepoTeams{iteam}.taskList(currnt) = [];
%                     vRepoTeams{iteam}.taskStat(currnt) = [];
%                     vRepoTeams{iteam}.taskType(currnt) = [];
%                     vRepoTeams{iteam}.taskMovements(currnt) = [];
%                     vRepoTeams{iteam}.taskTime(currnt) = [];
%                     % Correction of next times
%                     vRepoTeams{iteam}.taskTime(currnt:end) = ...
%                         vRepoTeams{iteam}.taskTime(currnt:end)...
%                         + ceil(T_trip_1(inext_2) - T_trip_2(inext_2) - T_trip_1(inext));
%                 end
%             end
%         end
%     elseif param.repoMethod == 3
% 
% 
%     end
% end

