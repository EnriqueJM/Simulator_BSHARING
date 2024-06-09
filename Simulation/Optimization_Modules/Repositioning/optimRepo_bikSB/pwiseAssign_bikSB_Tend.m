function [PwTeams, T_cost, y_end, UT] = pwiseAssign_bikSB_Tend(t, vRepoPool, vStations, vBikes, param)

%%% STEP 0
costRepo = param.costRepo/60; %In €/min
tskDur = param.taskDuration;
BPenSB = [param.costLostSB, param.costLostSB];
v_k = param.repoSpeed *1000/60;

%%% STEP 2.1: CALCULATE UTILITY MATRIX

    % Initialize utility matrix, time cost, and movements.
    UT = zeros(numel(vRepoPool), numel(vStations));
    T_cost = zeros(numel(vRepoPool),numel(vStations));
    y_end = zeros(numel(vRepoPool),numel(vStations));
    
    % Loop for all stations
    for istat=1:numel(vStations)
        %
        % Read station position, capacity, and expected demand.
        XS = vStations{istat}.X;
        YS = vStations{istat}.Y;
        Cap_i = vStations{istat}.capacity;
        req_T = vStations{istat}.accRequests(end)...
            - vStations{istat}.accRequests(t);
        ret_T = vStations{istat}.accReturns(end)...
            - vStations{istat}.accReturns(t);
        %        
        % Read inventory level of station.
        m_idle = 0;
        m_all = 0;
        list = vStations{istat}.listCars;
        if isempty(list) == 0
            for j = 1:numel(list)
                if vBikes{list(j)}.status(t) == 0
                    m_idle = m_idle + 1;
                end
                m_all = m_all + 1;
            end
        end
        % Theoretical number of movements.
        y_i = vStations{istat}.optCars(t) - m_idle;
        % 
        % Loop for all reams
        for iteam=1:numel(vRepoPool)
            
            % Read current vehicles, capacity, and position of the team.
            y_v = numel(vRepoPool{iteam}.listBikes);
            C_v = vRepoPool{iteam}.capacity;
            XT = vRepoPool{iteam}.X(t);
            YT = vRepoPool{iteam}.Y(t);
            %
            % Check how many bikes can be moved to achieve the optimum.
            % - If POSITIVE movements, it would be the minimum between the
            % ideal movements and current number of bikes carried by the
            % team.
            % - If NEGATIVE movements, if would be the maximum between the
            % ideal movements and the unused capacity of the team.
            if y_i >=0
                y_end(iteam, istat) = min([y_i, y_v]);
            else
                y_end(iteam, istat) = -1 * min([-y_i, C_v-y_v]);
%                 y_end(iteam, istat) = min([-y_i, C_v-y_v]);
            end
    
            m_end = m_all + y_end(iteam, istat);
    
            E_NSP_ini = NSPenalties(m_all, req_T, ret_T, Cap_i, BPenSB);
            E_NSP_end = NSPenalties(m_end, req_T, ret_T, Cap_i, BPenSB);
    
            T_cost(iteam, istat) = sim_dist(XT, YT, XS, YS)/v_k + 6 +...
                tskDur * abs(y_end(iteam, istat));
            if y_end(iteam, istat)~=0
                UT(iteam, istat) = E_NSP_ini - E_NSP_end - T_cost(iteam, istat)*costRepo;
            else
                UT(iteam, istat) = -99999; % Inf or NaN not possible.
            end
            
            % Duration filter
            if param.repoMethod == 2
                crrnt = vRepoPool{iteam}.taskCurrent;
                if numel(vRepoPool{iteam}.taskList)>crrnt
                    prev_duration = vRepoPool{iteam}.taskTime(crrnt+1)-vRepoPool{iteam}.taskTime(crrnt);
                    if T_cost(iteam, istat)> prev_duration
                        UT(iteam, istat) = -99999;
                    end
                end   
            end
            
        end
    end
    
%%% STEP 2.1: ASSIGN TASKS
    %
    % Pairwise assingment. (0 cost if unasigned team)
    PwTeams = matchpairs(UT, -99999,'max');
end

