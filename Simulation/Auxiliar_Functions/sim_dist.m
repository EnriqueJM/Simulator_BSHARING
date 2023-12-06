function d = sim_dist(XA, YA, XB, YB)
% Function to define the distance used in the simulator

% L1 distance
d = abs(XB-XA) + abs(YB-YA);

% L2 distance
%d = sqrt((XB-XA)^2 + (YB-YA)^2);

end