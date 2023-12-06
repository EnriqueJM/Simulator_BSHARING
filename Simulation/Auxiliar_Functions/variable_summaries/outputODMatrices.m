function outputODMatrices(OD, outputODmat, nameDir, zoneNum)
%OUTPUTODMATRICES - Ver. 1.1 (2022.01.16)

    % Create folder
    [status, ~, ~] = mkdir(nameDir,'custom_ODmat');
    if status == 0
        error('Error: Output folder could not be created');
    end

    header = {'ori','des','demand'};

    for i=1:numel(OD)
        filename = [outputODmat '_' num2str(i-1) '.csv'];
        disp(filename);
        %
        MAT = OD(i).Matrix;
        
        [row, col, v] = find(MAT);
        %
        data = cell(size(row,1)+1,3);
        data(1,:) = header;
        %
        for j=1:size(row,1)
            data(j+1,:) = {zoneNum(row(j)), zoneNum(col(j)), v(j)};
        end
        %
        writecell(data, [nameDir '/custom_ODmat/' filename]);
    end
end

