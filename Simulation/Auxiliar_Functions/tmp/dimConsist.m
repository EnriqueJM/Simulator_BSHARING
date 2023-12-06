%
% Script that reads shape file and O/D matrices for dimension consistency
%
S = shaperead('Data/zonas_carsharing/Zonas_Carsharing_zone.SHP');
%
list_ind = zeros(size(S,1),1);
for i=1:size(S,1)
    list_ind(i) = S(i).NO;
    S(i).NO = i;
end
%
shapewrite(S,'Data/zonas_carsharing/NEW_Zonas_Carsharing_zone.SHP');
%
prefix = 'Data/free-floating demand matrices/orig_matrix/matrix';
for i=1:24
    filename = [prefix '_' num2str(i-1) '.csv'];
    %
    A=csvread(filename,1,0);
    A=spconvert(A);
    %
    % Remove indexes from non-existing zones
    B = A(list_ind, list_ind);
    clear A;
    %
    [row, col, v] = find(B);
    A = [row, col, v];
    dlmwrite(strcat('Data/free-floating demand matrices/matrix_new_',num2str(i-1),'.csv'), ...
        A, 'delimiter', ',');
end