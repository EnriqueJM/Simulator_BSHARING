function outputInputs(param, t, nameDir)
%OUTPUTINPUTS - ver. 1.2 (2022.01.29)
%   Creates the input summary in a txt file.

    % List of fields in struct
    list_f = fieldnames(param);
    
    % List of units
    units = {'', 'minutes', 'cycles', '', '', '', '', '', '', '', '',...
        'minutes', '', 'trips/cycle', '[fraction of trips]',...
        '[fraction of area]', '[fraction of area]', '', '',...
        'degrees from North', '', '', '', '', 'stations',  '', '',...
        'parking slots', 'charging points', 'cars', 'cars', 'cars',...
        '[fraction of cars]', 'kilometers', 'minutes', '[percentage]', 'meters',...
        'km/h', 'km/h', 'minutes', '', '[fraction of trips]', 'meters', '',...
        '€/lost trip', '€/lost trip', '', 'teams', 'vehicles/team', 'km/h', 'minutes',...
        '€/h', ''};
    %%% NOTA: Mejor hacer algo para leerlo directamente del excel por si se
    %%% cambian parámetros.

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