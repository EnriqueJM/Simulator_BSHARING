function [SA] = listNeighbors(SA)
% Function that generates the list of neighbors for every region in the
% geometry (service area)

% Initialize arrays
for i=1:size(SA,2)
    SA(i).Neighbors = [];
end

% We consider a neighbor region if it shares at least one boundary node
for i=1:size(SA,1)
    XA = SA(i).X;          % List of boundary nodes for region i
    YA = SA(i).Y;
    %
    for j=i+1:size(SA,1)
        XB = SA(j).X;
        YB = SA(j).Y;
        %
        [inside, bound] = inpolygon(XA, YA, XB, YB);
        %
        if sum(bound) > 0  % There is at least one boundary node in common
            SA(i).Neighbors(end+1) = j;
            SA(j).Neighbors(end+1) = i;
        end
    end
end
% %
% for center = 1:size(SA,1)
%     figure();
%     %
%     ind = 1:size(SA,1);
%     ind_neig = ind(SA(center).Neighbors);
%     ind_rest = ind; ind_rest([center, SA(center).Neighbors]) = [];
%     %
%     mapshow(SA(center),'FaceColor','r'); % Region
%     hold on;
%     mapshow(SA(ind_neig),'FaceColor','b'); % Neighbors
%     mapshow(SA(ind_rest),'FaceColor','y'); % NOT Neighbors
%     %
%     pause(0.5);
% end
% %