function b = copyRepoTeam(a, t)
   b = RepoTeam ();  %create default object of the same class as a. one valid use of eval
   
   % Properties of Team A.
   currnt = a.taskCurrent;
   
   TotalTime = numel(a.vehicles);
   i = a.ID;
   X = a.X(t);
   Y = a.Y(t);
   capacity = a.capacity;
   
   initializeTeam(TotalTime, 10000+i, X, Y, capacity, b);
   %
   % Change vehicles.
   b.vehicles(t:end) = max([0,(a.vehicles(t)-a.taskMovements(currnt))]);
   b.vehicles(t:end) = min([b.capacity, b.vehicles(t)]);
   %
   % Copy bike list
   b.listBikes = a.listBikes;
   

end

