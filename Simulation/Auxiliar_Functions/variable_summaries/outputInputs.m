function outputInputs(param, t, nameDir)
%OUTPUTINPUTS - ver. 1.3 (2024.06.01)
%   Creates the input summary in a txt file.

    % List of fields in struct
    list_f = fieldnames(param);
    
    % List of units
    units = {'', ...                                                       % Version
        'minutes', 'cycles', '', '',...                                    % SIMULATION inputs
        '', '', '', '',...                                                 % SERVICE AREA inputs
        '', '','minutes', '', 'trips/cycle', '[fraction of trips]',...     % DEMAND inputs
        '[fraction of area]', '[fraction of area]', '', '',...
        'degrees from North', '', '', '', '',...                           
        'stations', '', '', 'parking slots', 'charging points',...         % STATION inputs
        'cars', 'cars', 'cars', '[fraction of cars]', 'kilometers',...     % FLEET inputs
        'minutes', '[percentage]', '', '',...
        'meters', 'km/h', 'km/h', 'minutes', '', '[fraction of trips]',... % USER inputs
        'meters', '', '€/lost trip', '€/lost trip',...
        '', 'teams', 'vehicles/team', 'km/h', 'minutes', '€/h',...         % REPOSITIONING inputs
        '', '', '[percentage]', '[percentage]', '[percentage]'};           % Perc forecast error and low battery
    %%% NOTA: Mejor hacer algo para leerlo directamente del excel por si se
    %%% cambian parámetros. O directamente eliminar unidades.

    % Write fields to text file
    filename = [nameDir t '_rawInputs.txt'];
    [fid, msg] = fopen(filename,'w');
        if fid < 0
            error('Failed to open filename "%s" because: "%s"\n', filename, msg);
        end
    %
    for i=1:(size(list_f,1)-1)      % El último valor de "param" es ArrayReDemand, no input.
        str = [list_f{i} ': ' num2str(param.(list_f{i}))  ' ' units{i} '\n'];
        fprintf(fid, str);
    end
    fclose(fid);

end