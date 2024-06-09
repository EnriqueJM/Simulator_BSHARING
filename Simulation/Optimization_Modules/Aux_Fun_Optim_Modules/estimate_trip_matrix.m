function [Cost_travel] = estimate_trip_matrix(vStations, param)
% ESTIMATE_TRIP_MATRIX - ver 1.0
%   Estimates the trip matrix between stations/zones. 

    v_k = param.repoSpeed*1000/60;
    
    Cost_travel=zeros(numel(vStations));

    for i=1:numel(vStations)
        for j=1:numel(vStations)
            
            % Note: This cost does not consider any extra parking time.
            Cost_travel(i,j)= sim_dist(vStations{i}.X, vStations{i}.Y,...
                vStations{j}.X, vStations{j}.Y)/v_k;          
        end
    end             

end

