function [vStationsOut] = update_acc_demand_forecast(vStations,...
                istat_prev, y_prev, t_prev,...
                istat_new, y_new, t_new)
    %%% Change movements
    % Delete previous movements
    if t_prev<=numel(vStations{istat_new}.accRequests)
        if y_prev<0
            vStations{istat_prev}.accRequests(t_prev+1:end) = ...
                vStations{istat_prev}.accRequests(t_prev+1:end) + y_prev;
        else
            vStations{istat_prev}.accReturns(t_prev+1:end) = ...
                vStations{istat_prev}.accReturns(t_prev+1:end) - y_prev;
        end
    end
    % Add new movements
    if t_new<=numel(vStations{istat_new}.accRequests)
        if y_new<0
            vStations{istat_new}.accRequests(t_new+1:end) = ...
                vStations{istat_new}.accRequests(t_new+1:end) - y_new;
        else
            vStations{istat_new}.accReturns(t_new+1:end) = ...
                vStations{istat_new}.accReturns(t_new+1:end) + y_new;
        end
    end
    
    vStationsOut = vStations;
end

