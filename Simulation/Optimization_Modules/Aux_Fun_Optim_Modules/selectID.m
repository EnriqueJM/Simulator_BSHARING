function [CopyS] = selectID(ID,stat,vStations,vZones)
%SELECTID Selects one station/zone from its ID, and returns a copy.
% The purpose of this function is to read easier the station/zone
% parameters from the copy.

    if stat == 1
       auxS = findobj([vStations{:}],'ID',ID);
       idx_auxS = [vStations{:}]==auxS;
       
       CopyS = vStations{idx_auxS};
    elseif stat == 0
       auxS = findobj([vZones{:}],'ID',ID);
       idx_auxS = [vZones{:}]==auxS;
       
       CopyS = vZones{idx_auxS};
    end
end

