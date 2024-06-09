function [vRepo_Out, vStat_Out] = ...
                    optimRepoRouteDual_bikSB_Tmax(vRepoTeams, vStations, vBikes,...
                    param)
% OPTIMREPOROUTEDUAL - ver 1.0
%   Selects the optimum task route.
%   For the SB systems only.
%   Procedure:
%       - Timer = 0.
%       - Pairwise assignment to select the best task for each vehicle
%         taking time cost into consideration.
%       - Select longest task assigned. (Fix time step.)
%       - Repeat process, but only taking into consideration tasks that can
%         be finished during the time step. Time cost is not taken into
%         consideration now.
%       - Update timer and repeat until reaching the end.
%   INPUTS:
%   - vStations -> {Array Sx1} Array of station class objects.
%   - vRepoTeams -> {Array Vx1} Array of repo teams class objects.
%   - vBikes -> {Array Mx1} Array of bike class objects. (vehicles)
%   - param -> Parameter struct:
%         - costRepo -> Repositioning cost (labor) per hour.
%         - tskDur -> Duration of moving one bike (minutes).
%         - BPenSB -> [orig dest] No-service penalty cost per trip.
%         - v_k -> Speed of repositioning vehicle.
%         - timeCycle -> Duration of one cycle.
%   OUTPUTS:
%   - vStat_Out -> {Array Sx1} Array of station class objects.
%   - vRepo_Out -> {Array Vx1} Array of repo teams class objects.
                                
    costRepo = param.costRepo/60; %In €/min
    tskDur = param.taskDuration ;
    BPenSB = [param.costLostSB(1), param.costLostSB(2)];
    v_k = param.repoSpeed *1000/60;

    timeCycle = param.TotalTime+1;

    %% STEP 0 - INITIALIZE TIMER AND VECTORS
    %
    vRepo_Out = vRepoTeams;
    vStat_Out = vStations;

    % Timer initialization.
    Timer = 1;
    for iteam=1:numel(vRepo_Out)
        if numel(vRepo_Out{iteam}.taskList)>0
            if vRepo_Out{iteam}.taskTime(vRepo_Out{iteam}.taskCurrent)>Timer
                Timer = vRepo_Out{iteam}.taskTime(vRepo_Out{iteam}.taskCurrent);
            end
        end
    end 
    %
    % Initialize total and station counter of current available bikes.
    % (Note that in the first iteration all bikes will be available. In the
    % second and after, some bikes could be in use.)
    NBikes = 0;
    m_i = zeros(numel(vStat_Out),1);
    % Account for bikes on stations
    for istat=1:numel(vStat_Out)
        list = vStat_Out{istat}.listCars;
        if isempty(list) == 0
            for j = 1:numel(list)
                if vBikes{list(j)}.status(Timer) == 0
                    m_i(istat) = m_i(istat) + 1;
                end
            end
        end
        NBikes = NBikes + m_i(istat);
    end
    % (Store initial distribution.)
    m_ini = m_i;
    % Account for bikes on repo vehicles.
    for iteam=1:numel(vRepo_Out)
        NBikes = NBikes + vRepo_Out{iteam}.vehicles(Timer);
    end 


    %% STEP 1 - CREATE ROUTES
    while Timer<timeCycle
        %% STEP 1.1 - UPDATE INVENTORY LEVEL, OPTIMUM DISTRIBUTION AND MOVEMENTS
        %
        % Change the station inventory level to the current step. (Must end in
        % an integer.)
        for istat=1:numel(vStat_Out)
            m_i(istat) = round(m_ini(istat) + vStat_Out{istat}.accReturns(Timer) ...
                - vStat_Out{istat}.accRequests(Timer));
        end
        % Calculate optimum distribution and accumulate requests and returns.
        [vStat_Out, m_opt, req_T, ret_T] = optimDistribution(vStat_Out, NBikes, Timer, BPenSB);

        % Calculate ideal bike movements per stations.
        y_i = m_opt - m_i;

        %% STEP 1.2 - UTILITY MATRIX
        %
        % Initialize utility matrix, time cost, and movements.
        UT_1 = zeros(numel(vRepo_Out), numel(vStat_Out), param.TotalTime);
        T_cost = zeros(numel(vRepo_Out),numel(vStat_Out));
        y_end = zeros(numel(vRepo_Out),numel(vStat_Out));

        % Loop for each repo team
        for iteam=1:numel(vRepo_Out)

            % Read current vehicles, capacity, and position of the team.
            y_v = vRepo_Out{iteam}.vehicles(Timer);
            C_v = vRepo_Out{iteam}.capacity;

            XT = vRepo_Out{iteam}.X(Timer);
            YT = vRepo_Out{iteam}.Y(Timer);

            % Loop for all stations
            for istat=1:numel(vStat_Out)

                % Read station position and capacity.
                XS = vStat_Out{istat}.X;
                YS = vStat_Out{istat}.Y;
                Cap_i = vStat_Out{istat}.capacity;

                % Check how many bikes can be moved to achieve the optimum.
                % - If POSITIVE movements, it would be the minimum between the
                % ideal movements and current number of bikes carried by the
                % team.
                % - If NEGATIVE movements, if would be the maximum between the
                % ideal movements and the unused capacity of the team.
                if y_i(istat) >=0
                    y_end(iteam, istat) = min([y_i(istat), y_v]);
                else
                    y_end(iteam, istat) = -1 * min([-y_i(istat), C_v-y_v]);
                end

                m_end = m_i(istat) + y_end(iteam, istat);

                E_NSP_ini = NSPenalties(m_i(istat), req_T(istat), ret_T(istat), Cap_i, BPenSB);
                E_NSP_end = NSPenalties(m_end, req_T(istat), ret_T(istat), Cap_i, BPenSB);

                T_cost(iteam, istat) = sim_dist(XT, YT, XS, YS)/v_k + 6  ...
                    + tskDur * abs(y_end(iteam, istat));
                if y_end(iteam, istat)~=0
                    UT_1(iteam, istat, Timer) = E_NSP_ini - E_NSP_end - T_cost(iteam, istat)*costRepo;
%                     UT(iteam, istat, Timer) = E_NSP_ini - E_NSP_end;
                else
                    UT_1(iteam, istat, Timer) = -99999; % Inf or NaN not possible.
                end
            end
        end

        %% STEP 1.3 - CALCULATE OPTIMUM TASKS
        %
        % Pairwise assingment 1. (-9999 cost if unasigned team)
        PwTeams = matchpairs(UT_1(:,:,Timer),-99999,'max');
        
        if size(PwTeams,1)>0

            % Calculate assigned tasks time vector
            asign_tcost = zeros(size(PwTeams,1),1);
            for i=1:size(PwTeams,1)
                % Index of team and station per assigment
                iteam = PwTeams(i,1);
                istat = PwTeams(i,2);
                % Time cost of task
                asign_tcost(i) = T_cost(iteam,istat);
            end
            max_tcost = max(asign_tcost);
            UT_2 = (UT_1(:,:,Timer) + T_cost*costRepo)...
                .*(T_cost<=max_tcost) -99999*(T_cost>max_tcost);
            % 
            % Pairwise assingment 1. (-9999 cost if unasigned team)
            PwTeams = matchpairs(UT_2,-9999,'max');

            %%% Assigned tasks
            for i=1:size(PwTeams,1)
                % Index of team and station per assigment
                iteam = PwTeams(i,1);
                istat = PwTeams(i,2);
                % Time cost of task
                asign_tcost(i) = T_cost(iteam,istat);
                t_end = ceil(Timer + T_cost(iteam,istat));
                %
                % Add task to the list
                vRepo_Out{iteam}.taskList(end+1) = istat;
                vRepo_Out{iteam}.taskStat(end+1) = 1;
                vRepo_Out{iteam}.taskType(end+1) = 2;
                vRepo_Out{iteam}.taskMovements(end+1) = y_end(iteam,istat);
                vRepo_Out{iteam}.taskTime(end+1) = t_end;
                vRepo_Out{iteam}.taskUtility(end+1) = UT_1(iteam,istat,Timer);
                % Change position of team (at the end of the task).
                vRepo_Out{iteam}.X(t_end:end) = vStat_Out{istat}.X;
                vRepo_Out{iteam}.Y(t_end:end) = vStat_Out{istat}.Y;
                % Change vehicles of team
                if t_end<=timeCycle
                    vRepo_Out{iteam}.vehicles(t_end:end) =...
                        vRepo_Out{iteam}.vehicles(Timer) - y_end(iteam,istat);
                end
                % Change bike variation on station.
                % If removing bikes -> Increase expected requests
                % If adding bikes -> Increase expected returns
                if t_end<=timeCycle
                    if y_end(iteam,istat)<0
                        vStat_Out{istat}.accRequests(t_end+1:end) = ...
                            vStat_Out{istat}.accRequests(t_end+1:end) - y_end(iteam,istat);
                    else
                        vStat_Out{istat}.accReturns(t_end+1:end) = ...
                            vStat_Out{istat}.accReturns(t_end+1:end) + y_end(iteam,istat);
                    end
                end
            end
        end
    

        %% UPDATE TIMER   
        %
        % Update timer to the most delay task. (Update 1 minute min.)
        Timer = Timer + max([1, ceil(max(asign_tcost))]);


    end

    %% SET TEAM ON STARTING POSITION
    for iteam=1:numel(vRepo_Out)
        if numel(vRepo_Out{iteam}.taskList)>0
            vRepo_Out{iteam}.taskCurrent = 1;
            vRepo_Out{iteam}.status(1:end)=1;
        end
        vRepo_Out{iteam}.vehicles(1:end)=vRepoTeams{iteam}.vehicles(1);
    end 

end

