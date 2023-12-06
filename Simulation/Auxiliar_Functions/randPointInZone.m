function [X, Y] = randPointInZone(XB, YB)
% Function that generates a random point inside a region with boundary
% nodes in XB, YB

% Look for maximum and minimum coordinates in x, y axis
xmin = min(XB); xmax = max(XB);
ymin = min(YB); ymax = max(YB);

inside = 0;  % Boolean for point inside the region
while inside == 0
    % Generate a random point inside the rectangle [xmin, xmax] x [ymin, ymax]
    X = xmin + rand*(xmax-xmin);
    Y = ymin + rand*(ymax-ymin);
    %
    % Check if point is inside the region
    inside = inpolygon(X, Y, XB, YB);
end