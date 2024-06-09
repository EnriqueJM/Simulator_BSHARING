function [vRepo_Out, vStat_Out] = optimRepoRouteDual_bikSB_Prob(vRepoTeams, vStations, param)
% OPTIMREPOROUTEDUAL - ver 1.0
%   Optimizes the repositioning tasks for the following cycle as routes.
%   The purpose of this strategy is to assign tasks to vehicles taking into
%   account the next and following tasks.
%   The procedure is developed by following 3 steps:
%       1. A feasible solution is estimated.
%       2. The previous feasible solution is translated into a MILP
%       solution seed.
%       3. The MILP is solved using the solution seed.
%       4. The new solution is translated as a set of tasks to the teams.
%   Each one of these steps are subprocedures.
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

    vRepo_Out = vRepoTeams;
    vStat_Out = vStations;

%% Parameters from param
    %%%
    BPenSB = [param.costLostSB(1), param.costLostSB(2)];
    t_mov = param.taskDuration;


%% DVs of repositioning route:
    
    %%% Array of time steps where the route is evaluated. [1xT]
    t_vect = 1:30:1441;

    %%% Trip matrix of repositioning teams. [SxSxTxV]
    X_trip = zeros(numel(vStations),numel(vStations),...
        numel(t_vect),numel(vRepoTeams));

    %%% Array of vehicle movements [SxSxTxV] (Note that all columns must be
    %%% equal.
    Y_veh = zeros(numel(vStations),numel(vStations),...
        numel(t_vect),numel(vRepoTeams));
    
    
%% Capacities and auxiliary values
    %%% Repo team capacity [1xV]
    cap_v = zeros(1,numel(vRepoTeams));
    for v=1:numel(cap_v)
        cap_v(v)=vRepoTeams{v}.capacity;
    end
    %%% Station capacity [1xS]
    cap_s = zeros(1,numel(vStations));
    for j=1:numel(cap_s)
        cap_s(j)=vStations{j}.capacity;
    end
    %%% Accumulated requests and returns [SxT]
    bik_q = zeros(numel(vStations),numel(t_vect));
    bik_t = zeros(numel(vStations),numel(t_vect));
    for j=1:size(bik_q,1)
        bik_q(j,:) = vStations{j}.accRequests(t_vect);
        bik_t(j,:) = vStations{j}.accReturns(t_vect);
    end
    %%% Travel cost matrix [SxS]  
    D_cost = estimate_trip_matrix(vStations, param);
    %%% Station inventory level [SxT]
    bik_cur = zeros(numel(vStations),numel(t_vect));
    for t=1:size(bik_cur,2)
        for j=1:size(bik_cur,1)
            if t==1
                bik_cur(j,t)=numel(vStations{j}.listCars);
            else
                bik_cur(j,t)=bik_cur(j,t-1) + (bik_t(j,t-1)-bik_t(j,t))...
                    - (bik_q(j,t-1)-bik_q(j,t));
                bik_cur(j,t)=max([0, min([bik_cur(j,t), cap_s(j)])]);
            end
        end
    end
    bik_end = bik_cur;

    
%% Find SEED SOLUTION    
    
%     [vRepo_Out, vStat_Out] = genSeedRoute_SB(vRepoTeams, vStations, vBikes, param);
                                
%     [X_trip, Y_bik] = constructDVs (vRepo_Out, vStat_Out);
%     
%     [DV] = solveOptim();
%     
%     [vRepo_Out, vStat_Out] = construcRoute(DV);

%% DEFINE PROBLEM
    % Problem creation
    routeprob = optimproblem('ObjectiveSense','maximize');
    % Variable X (repo team trips)
    X_var = optimvar('X_var', numel(X_trip),'Type','integer','LowerBound',0,'UpperBound',1);
    % Variable Y (vehicle movements)
    for iteams=1:size(Y_veh,4)
        Y_veh(:,:,:,iteams) = cap_v(iteams);
    end
    y_lim = reshape(ones(size(Y_veh)),[numel(Y_veh),1]); %#ok<NBRAK>
    Y_var = optimvar('Y_var', numel(Y_veh),'Type','integer','LowerBound',-y_lim,'UpperBound',y_lim);
    
    %%% Objective function
    NSP_save = NSP_save_obj(X_var, Y_var, bik_cur, bik_end,...
        bik_q, bik_t, cap_s, cap_v, BPenSB);                
    routeprob.Objective = NSP_save;
    
    %%% Constraints
    % At most one task per vehicle and time span
    routeprob.Constraints.consTaskV = Task_countV(X_var, X_trip)<=numel(cap_v);
    routeprob.Constraints.consTaskT = Task_countT(X_var, X_trip)<=numel(t_vect);
    % Enough time to fulfill the tasks for each vehicle.
    routeprob.Constraints.consTime = Time_countV(X_var, X_trip, Y_var, Y_veh, D_cost, t_mov) <= t_vect(end)*ones(size(cap_v));
    % Enough vehicles in the repo team
    %routeprob.Constraints.consZeroV = ;
    % Enough capacity in the repo team
    %routeprob.Constraints.consCapV = ;
    
%% SOLVE PROBLEM
    
    [sol,fval] = solve(routeprob);
    
    %%% Change solution into variables
    
    X_trip = reshape(sol.X_var,size(X_trip));
    Y_veh = reshape(sol.Y_veh,size(Y_veh));
    
    %%% Programm tasks to vehicles
      
    for iteam=1:numel(vRepo_Out)
        t_end = 1;
        for t=1:numel(t_vect)
            % Find station to visit
            
            istat = find(sum(X_trip(:,:,t,iteam)));
            
            if istat>0
                %
                % Update timer with task duration
                task_dur = t_mov * sum(sum(Y_veh(:,t,iteam).*X_trip(:,:,t,iteam))) ...
                                + sum(sum(D_cost.*X_trip(:,:,t,iteam)));
                %Timer = t_vect(t);
                t_end = ceil(t_end + task_dur);
                %
                % Add task to the list
                vRepo_Out{iteam}.taskList(end+1) = istat;
                vRepo_Out{iteam}.taskStat(end+1) = 1;
                vRepo_Out{iteam}.taskType(end+1) = 2; % Priorities - 1: Charge; 2:Repositioning
                vRepo_Out{iteam}.taskMovements(end+1) = Y_veh(istat,t,iteam);
                vRepo_Out{iteam}.taskTime(end+1) = t_end;
                % vRepo_Out{iteam}.taskUtility(end+1) = UT_1(iteam,istat,Timer);
                % Change position of team (at the end of the task).
                vRepo_Out{iteam}.X(t_end:end) = vStat_Out{istat}.X;
                vRepo_Out{iteam}.Y(t_end:end) = vStat_Out{istat}.Y;
                % Change vehicles of team
                if t_end<=t_vect(end)
                    vRepo_Out{iteam}.vehicles(t_end:end) =...
                        vRepo_Out{iteam}.vehicles(t_end) - Y_veh(istat,t,iteam);
                end
                % Change bike variation on station.
                % If removing bikes -> Increase expected requests
                % If adding bikes -> Increase expected returns
                if t_end<=t_vect(end)
                    if Y_veh(istat,t,iteam)<0
                        vStat_Out{istat}.accRequests(t_end+1:end) = ...
                            vStat_Out{istat}.accRequests(t_end+1:end) - Y_veh(istat,t,iteam);
                    else
                        vStat_Out{istat}.accReturns(t_end+1:end) = ...
                            vStat_Out{istat}.accReturns(t_end+1:end) + Y_veh(istat,t,iteam);
                    end
                end
            end
           %  
        end
    end   
end


function [NSP_save] = NSP_save_obj(X_var, Y_var, bik_cur, bik_end,...
                                    bik_q, bik_t, cap_s, cap_v, BPenSB)
    % Reshape the DVs to matrices
    X_trip = reshape(X_var,[size(bik_cur,1),size(bik_cur,1),size(bik_cur,2),numel(cap_v)]);
    Y_veh = reshape(Y_var,[size(bik_cur,1),size(bik_cur,1),size(bik_cur,2),numel(cap_v)]);
    % Change the final inventory level depending on visits
    for v=1:numel(cap_v)
        bik_end = bik_end + squeeze(sum(Y_veh(:,:,:,v).*X_trip(:,:,:,v),1));
    end
    % Estimate NSP savings
    NSP_save = 0;
    for t=1:size(bik_cur,2)
        req_T = bik_q(:,end) - bik_q(:,t);
        ret_T = bik_t(:,end) - bik_t(:,t);
        for j=1:numel(cap_s)
            NSP_save = NSP_save + ...
                NSPenalties(bik_cur(j,t), req_T(j), ret_T(j), cap_s(j), BPenSB)...
                - NSPenalties(bik_end(j,t), req_T(j), ret_T(j), cap_s(j), BPenSB);
        end
    end
    
end

function [NtasksT] = Task_countT(X_var, X_trip)

    X_trip = reshape(X_var,size(X_trip));
    
    NtasksT = sum(sum(sum(X_trip,4),2),1);

end
function [NtasksV] = Task_countV(X_var, X_trip)

    X_trip = reshape(X_var,size(X_trip));
    
    NtasksV = sum(sum(sum(X_trip,3),2),1);

end
function [TimeV] = Time_countV(X_var, X_trip, Y_var, Y_veh, D_cost, t_mov)

    X_trip = reshape(X_var,size(X_trip));
    Y_veh = reshape(Y_var,size(Y_veh));
    
    TimeV = zeros(dim(X_trip,4),1);
    for v=1:dim(X_trip,4)
        
        
        TimeV(v)= sum(t_mov*abs(Y_veh(:,:,v)),'all') + ...
            sum(D_cost.*sum(X_trip(:,:,:,v),3),'all');
    end

end


function [vRepo_Out, vStat_Out] = genSeedRoute_SB(vRepoTeams, vStations,...
                                    vBikes, param)
% GENSEEDROUTE - ver 1.0
%   Selects the initial seed solution for the routing optimization.
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
        PwTeams = matchpairs(UT_1(:,:,Timer),-9999,'max');

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

