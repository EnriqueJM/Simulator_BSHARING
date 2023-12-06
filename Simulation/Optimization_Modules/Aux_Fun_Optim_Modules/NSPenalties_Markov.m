function E_NSP_i = NSPenalties_Markov(m_i, req_h, ret_h, Cap_i, beta)
% NSPENALTIES - ver. 1.1
%   Returns the average penalty cost of users not getting service on a
%   station/FF_zone given a current inventory level and a expected demand.
%   INPUTS:
%   - m_i -> Currrent number of bikes on station i.
%   - req_h -> Total number of requests during h.
%   - ret_h -> Total number of returns during h.
%   - Cap_i -> Max. capacity of station i.
%   - beta -> {Array 2x1} Value of single penalty cost in €/trip.
%               beta(1) -> no cars
%               beta(2) -> no parking slots
%   OUTPUTS:
%   - E_NSP_i -> Expected no service penalty cost for station i.


    avg_steps = req_h + ret_h;
    stdev_steps = sqrt(ret_h + req_h);
    
    P_ret = acc_ret/(acc_ret+acc_req);
    P_req = acc_req/(acc_ret+acc_req);
    
    P_markov = zeros(Cap_i+3);
    for i=1:Cap_i+3
        if i==2
            P_markov(i,2)=P_req;
            P_markov(i,3)=P_ret;
        elseif i>2 && i<Cap_i+2
            P_markov(i,i-1)=P_req;
            P_markov(i,i+1)=P_ret;
        elseif i==Cap_i+2
            P_markov(i,end-1)=P_ret;
            P_markov(i,end-2)=P_req;
        end
        
    end

    if req_h == 0 && ret_h == 0
        E_NSP_i = 0;
    else
%         E_NSP_i = beta(1) * req_h * probEmpty(m_i, req_h, ret_h) ...
%             + beta(2) * ret_h * probFull(m_i, req_h, ret_h, Cap_i);
        E_NSP_i = beta(1) * expectEmpty(m_i, req_h, ret_h) ...
            + beta(2) * expectFull(m_i, req_h, ret_h, Cap_i);
    end

end

function result_P_e = expectEmpty (m_i, req_h, ret_h)
% EXPECTEMPTY - ver. 1.0 (previous PROBEMPTY)
%   Returns the expected number of users not finding available vehicles on
%   a vehicle-sharing station/FF_zone, given a current inventory level and
%   the expected (forecasted) demand.
%   INPUTS: {Arrays Nx1}
%   - m_i -> Currrent number of vehicles on station i.
%   - req_h -> Total expected demand requests during the analyzed period.
%   - ret_h -> Total expected demand returns during the analyzed period.
%
% NOTE: This function depends on the analyzed period, since the expected
% number of returns and requests vary if the period changes.

%%% Demand requests and returns are considered independent distributions.
%%% The average and standard deviation of vehicle variation will be:
    avg_D_h = ret_h - req_h;
    stdev_D_h = sqrt(ret_h + req_h);

%%% Result array is initialized.
    result_P_e = zeros(length(m_i),1);

%%% The expected value must be calculated numerically as an integral.
%%% Lower bound of the integral is determined by a worst case in which the
%%% inventory level is reduced up to 4 standard deviations away from the
%%% average value.
%%% Upper bound is always -1.
%%% Even in the best case, the probability of suffering 1 no-service
%%% situation is calculated.
    max_variation = floor(avg_D_h - 4 * stdev_D_h);
    limit_int = min(-1, m_i + max_variation);

%%% Numerical integration for the set of N stations/FF_zones.
%%% Vehicle variation is a Skellam distribution. However, it can be
%%% approximated to a Normal distribution.
    for i=1:length(m_i)
        
        aux_int = zeros(-limit_int(i)+1,1);
        
        for x = 0:-1:limit_int(i) 
            aux_int(-x+1) = normpdf(x,m_i(i)+avg_D_h(i),stdev_D_h(i))*(-x);
        end
        
        result_P_e(i) = trapz(aux_int);
    end
end

function result_P_f = expectFull (m_i, req_h, ret_h, Cap_i)
% EXPECTFULL - ver. 1.0 (previous PROBFULL)
%   Returns the expected numebr of users not finding available parking on a
%   vehicle-sharing station/FF_zone, given a current inventory level and
%   the expected (forecasted) demand.
%   INPUTS: {Arrays Nx1}
%   - m_i -> Currrent number of vehicles on station i.
%   - req_h -> Total expected demand requests during the analyzed period.
%   - ret_h -> Total expected demand returns during the analyzed period.
%   - Cap_i -> Max. capacity of station i.
%
% NOTE: This function depends on the analyzed period, since the expected
% number of returns and requests vary if the period changes.

%%% Demand requests and returns are considered independent distributions.
%%% The average and standard deviation of vehicle variation will be:
    avg_D_h = ret_h - req_h;
    stdev_D_h = sqrt(ret_h + req_h);
  
%%% Result array is initialized.
    result_P_f = zeros(length(m_i),1);

%%% The expected value must be calculated numerically as an integral.
%%% Upper bound of the integral is determined by a worst case in which the
%%% inventory level is increased up to 4 standard deviations away from the
%%% average value.
%%% Lower bound is always 1.
%%% Even in the best case, the probability of suffering 1 no-service
%%% situation is calculated.    
    max_variation = ceil(avg_D_h + 4 * stdev_D_h);
    limit_int = max(1, max_variation + m_i - Cap_i);
        
%%% Numerical integration for the set of N stations/FF_zones.
%%% Vehicle variation is a Skellam distribution. However, it can be
%%% approximated to a Normal distribution.
    for i=1:length(m_i)
        
%%% Only if there is a capacity constraint.
        if Cap_i(i) ~= Inf

            aux_int = zeros(limit_int(i)+1,1);
         
            for x = 0:limit_int(i)               
                aux_int(x+1) = normpdf(x,m_i(i)+avg_D_h(i),stdev_D_h(i))*x;             
            end
            
            result_P_f(i) = trapz(aux_int);
        end
    end
end

