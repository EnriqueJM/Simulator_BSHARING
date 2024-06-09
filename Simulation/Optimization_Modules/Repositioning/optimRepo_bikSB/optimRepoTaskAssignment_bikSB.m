function [vRepoTeamsOut, vStationsOut, vBikesOut] = ...
    optimRepoTaskAssignment_bikSB(t, vRepoTeams, vRepoPool, vStations, vBikes,...
    param)
    

%%
% costRepo = param.costRepo/60; %In €/min
% tskDur = param.taskDuration;
% BPenSB = [param.costLostSB, 2*param.costLostSB];
% v_k = param.repoSpeed *1000/60;

timeCycle = param.TotalTime + 1;

%% STEP 2: CHECK POSSIBLE MODIFICATIONS - PREV. CALCULATIONS

    %%% STEP 2.1: CORRECTION OF DEMAND FORECAST AT STATIONS

    %%% If repositioning strategy is #2 (preemptive route + recalculation),
    %   the next task will be checked. To do so, the effect of that
    %   repositioning action must be deleted in the accumulated demand
    %   forecast. Otherwise, the movement will be assumed as granted.
    if param.repoMethod == 2
        for iteam=1:numel(vRepoTeams)
            currnt = vRepoTeams{iteam}.taskCurrent;
            if vRepoTeams{iteam}.status(t)==0 && numel(vRepoTeams{iteam}.taskList)>currnt
                istat = vRepoTeams{iteam}.taskList(currnt+1);
                y_prev = vRepoTeams{iteam}.taskMovements(currnt+1);
                t_prev = vRepoTeams{iteam}.taskTime(currnt+1);
                
                % Correct demand forecast
                if t_prev<=timeCycle
                    if y_prev<0
                        vStations{istat}.accRequests(t_prev+1:end) = ...
                            vStations{istat}.accRequests(t_prev+1:end) + y_prev;
                    else
                        vStations{istat}.accReturns(t_prev+1:end) = ...
                            vStations{istat}.accReturns(t_prev+1:end) - y_prev;
                    end
                end                
            end
        end
    end


    %% STEP 2.2: CALCULATE UTILITY MATRIX AND OPTIMUM ASSIGNMENT
    
    %%% On an auxiliary function
%     [PwTeams, T_cost, y_end, UT] = pwiseAssign_bikSB_Tend(t, vRepoPool, vStations, vBikes, param);
    [PwTeams, T_cost, y_end, UT] = pwiseAssign_bikSB_twdow(t, vRepoPool, vStations, vBikes, param);  %%% MUCHO MEJOR
    
    
    %% STEP 2.3: ASSIGN OPTIMUM TASKS ON IDLE VEHICLES
    
    %%% Assigned tasks
    for i=1:size(PwTeams,1)
        % Index of team and station per assigment
        iteam = PwTeams(i,1);
        istat = PwTeams(i,2);
        %
        % Current task (just finished)
        currnt = vRepoTeams{iteam}.taskCurrent;
        % Time cost of task (new assignation).
        t_end = ceil(t + T_cost(iteam,istat));
        %
        %%% If team is idle, adjust next task.
        if vRepoTeams{iteam}.status(t)==0
            if numel(vRepoTeams{iteam}.taskList)==currnt
                %%% If previous task was the last one, add to the list.
                %
                % Add task to the list
                vRepoTeams{iteam}.taskList(end+1) = istat;
                vRepoTeams{iteam}.taskStat(end+1) = 1;
                vRepoTeams{iteam}.taskType(end+1) = 2;
                vRepoTeams{iteam}.taskMovements(end+1) = y_end(iteam,istat);
                vRepoTeams{iteam}.taskTime(end+1) = t_end;
                vRepoTeams{iteam}.taskUtility(end+1) = UT(iteam,istat);

                % Change expected bike variation on station.
                % If removing bikes -> Increase expected requests
                % If adding bikes -> Increase expected returns
                if t_end<=timeCycle
                    if y_end(iteam,istat)<0
                        vStations{istat}.accRequests(t_end+1:end) = ...
                            vStations{istat}.accRequests(t_end+1:end) - y_end(iteam,istat);
                    else
                        vStations{istat}.accReturns(t_end+1:end) = ...
                            vStations{istat}.accReturns(t_end+1:end) + y_end(iteam,istat);
                    end
                end
            elseif numel(vRepoTeams{iteam}.taskList)>currnt
                %%% If there are more pending task in the list, check best
                %   utility and update task if better.
                %
                % Expected task ending time, movements, and utility.
                y_prev = vRepoTeams{iteam}.taskMovements(currnt+1);
                t_prev = vRepoTeams{iteam}.taskTime(currnt+1);
                istat_prev = vRepoTeams{iteam}.taskList(currnt+1);
                ut_prev = vRepoTeams{iteam}.taskUtility(currnt+1);
                % New utility
                ut_new = UT(iteam,istat);
                %
                if ut_prev>=ut_new
                    % If previous utility is better, remain task.
                    %
                    % Change expected bike variation on station because of movements.
                    % If removing bikes -> Increase expected requests
                    % If adding bikes -> Increase expected returns
                    % (Undo previous correction)
                    if t_prev<=timeCycle
                        if y_prev<0
                            vStations{istat_prev}.accRequests(t_prev+1:end) = ...
                                vStations{istat_prev}.accRequests(t_prev+1:end) - y_prev;
                        else
                            vStations{istat_prev}.accReturns(t_prev+1:end) = ...
                                vStations{istat_prev}.accReturns(t_prev+1:end) + y_prev;
                        end
                    end
                else
                    % If new utility is better, replace task.
                    vRepoTeams{iteam}.taskList(currnt+1) = istat;
                    %
                    % Replace movements
                    vRepoTeams{iteam}.taskMovements(currnt+1) = y_end(iteam,istat);
                    % Change expected bike variation on station because of movements.
                    % If removing bikes -> Increase expected requests
                    % If adding bikes -> Increase expected returns
                    if t_end<=timeCycle
                        if y_end(iteam,istat)<0
                            vStations{istat}.accRequests(t_end+1:end) = ...
                                vStations{istat}.accRequests(t_end+1:end) - y_end(iteam,istat);
                        else
                            vStations{istat}.accReturns(t_end+1:end) = ...
                                vStations{istat}.accReturns(t_end+1:end) + y_end(iteam,istat);
                        end
                    end
                    %
                    % Replace times
                    t_diff = t_end - t_prev;
                    vRepoTeams{iteam}.taskTime(currnt+1:end) =...
                        vRepoTeams{iteam}.taskTime(currnt+1:end) + t_diff;
                    % Update station returns/requests forecast
                    if numel(vRepoTeams{iteam}.taskList)>currnt+1
                        for itask=currnt+2:numel(vRepoTeams{iteam}.taskList)
                            istat_fut = vRepoTeams{iteam}.taskList(itask);
                            y_end_fut = vRepoTeams{iteam}.taskMovements(itask);
                            t_end_fut = vRepoTeams{iteam}.taskTime(itask);
                            vStations = update_acc_demand_forecast(vStations,...
                                istat_fut, y_end_fut, t_end_fut-t_diff,...
                                istat_fut, y_end_fut, t_end_fut);
                        end
                    end
                    %
                    % Replace utility
                    vRepoTeams{iteam}.taskUtility(currnt+1) = ut_new;
                end
            end
            %
            % Initialize next task and change status to busy.
            vRepoTeams{iteam}.taskCurrent = vRepoTeams{iteam}.taskCurrent+1;
            vRepoTeams{iteam}.status(t:end) = 1;
        end
    end
    
    vRepoTeamsOut = vRepoTeams;
    vStationsOut = vStations;
    vBikesOut = vBikes;     
        
end

