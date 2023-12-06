function errorInputs(param)

 %%%% Check dimensions consistency between zonification (SHP file) and
 %%%% hourly O/D matrices (NOT MORE ROWS OR COLUMNS IN MATRIX THAN ZONES
 %%%% !!!)
 
 %%%% Check UTM coordinates when reading SHP
 
 %%%% Check every station inside the area
 
 
% AuxStationM = xlsread('Data/StationsData.xlsx');
% boundM = xlsread('Data/Boundary.xlsx');
% DemandM = xlsread('Data/Demand.xlsx');
% AttractM =  xlsread('Data/Attraction.xlsx');
% 
%  if size(boundM,1) ~= 2
%      error('INPUT BOUNDARY MATRIX: boundary matrix size is not correct');
%  end
%  
%  if size(DemandM,2) ~= size(AuxStationM,2) || size(AttractM,2) ~= size(AuxStationM,2)
%      error('INPUT DEMAND/ATTRACTION MATRIX: Demand or attraction size do not consider all the stations');
%  end
% 
% if param.m < sum(AuxStationM(5,:))
%     error('INPUT m: The number of bikes is smaller than initial bikes needed');
% end
% 
% if param.Ebike ~= 0 && param.Ebike ~= 1
%     error('INPUT Ebike: E-bike mode must be selected (0 or 1)');
% end
% 
% if param.BikeSpeed < 0
%     error('INPUT bikeSpeed: bikes speed must be defined and positive');
% end
% 
% if param.BikeLoadUnload < 1
%     error('INPUT bikeLoadUnload: some time must be considered for loading and unloading bikes by users in a stations');   
% end
% 
% if param.Wmax < 1
%     error('INPUT Wmax: A maximum walking distance must be defined');   
%     
% end
% 
% if param.AvgRideDist < 1
%     error('INPUT Wmax: An average ride distance must be defined')
% end
% 
% if param.App ~= 0 && param.App ~= 1
%     error('INPUT App: App mode must be selected (0 or 1)');
% end
% 
% if param.ContRepo ~= 0 && param.ContRepo ~= 1 && param.ContRepo ~= 2
%     error('INPUT ContRepo: Continuous reposition mode must be selected (0, 1 or 2)');
% end
% 
% if param.PeriodRepo ~= 0 && param.PeriodRepo ~= 1
%     error('INPUT PeriodRepo: Periodic reposition mode must be selected (0 or 1)');
% end
% 
% if param.ContTrucks < 1 && (param.ContRepo == 1 || param.ContRepo == 2)
%     error('INPUT ContTrucks: A number of trucks must be defined for continuous reposition programed');
% end
% 
% if param.PeriodTrucks < 1 && param.PeriodTrucks == 1
%     error('INPUT PeriodTrucks: A number of trucks must be defined for periodic reposition programed');
% end
% 
% if length(param.DepoPosition)< 3 || length(unique(param.DepoPosition)) < 3
%     error('INPUT DepoPosition: The position of the central depod must be defined in x, y, z');
% end
% 
% if param.TimeReDemand < 1 || param.TimeReDemand > size(DemandM,1)
%     error('INPUT TimeReDemand: The period of actualization of the Demand is not good defined. Check over the Demand and attraction inputs');
% end
% 
% if param.WalkSpeed < 1
%     error('INPUT WalkSpeed: Walking speed must be defined and positive');
% end
% 
% if param.BatteryCharge < 1
%     error('INPUT BatteryCharge: The time to charge an empty battery must be defined and positive');
% end
% 
% if param.BatteryConsume < 1
%     error('INPUT BatteryConsume: The time to consume a full battery while riding must be defined and positive');
% end
% 
% if param.K < 1
%     error('INPUT K: The capacity of trucks must be defined and positive');
% end
% 
% if param.TruckSpeed < 1
%     error('INPUT TruckSpeed: Trucks speed must be defined and positive');
% end
% 
% if param.TimeLoadUnload <= 0
%     error('INPUT bikeLoadUnload: some time must be considered for loading and unloading bikes by operators in a stations'); 
% end
% 
% if param.TotalTime > size(DemandM,1)
%     error('INPUT TotalTime: There are not enough demand data to simulate. Check over the Demand and Attraction inputs');
% elseif param.TotalTime < 1
%     error('INPUT TotalTime: Total time for simulation must be defined and positive');
% end
% 
% if param.expBikes < 0
%     error('INPUT expBikes: minimum movements needed to move a truck must be defined and positive');
% end
% 
% if param.Per4Alarm > 100 || param.Per4Alarm < 0
%     error('INPUT Per4Alarm: percentage to set reposition alarm must be defined between 0% and 100%');
% end

end