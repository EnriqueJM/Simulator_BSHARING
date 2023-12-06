%creacion de la clase POSTPROCESS


classdef PostProcess<handle
    
    properties
        IsOriginPlot              % Flag for plotting trips by Origin station
        IsDestinationPlot         % Flag for plotting trips by Destination station
        IsTripsODPlot             % Flag for plotting total trips by hour from O/D matrices
        IsSAreaPlot               % Flag for plotting service area including stations, cars, ...
        axes                      % axes for plotting
        
    end
    
    methods
%% CONSTRUCTOR

        function obj = PostProcess()
            
            obj.IsOriginPlot = 0;
            obj.IsDestinationPlot = 0;
            obj.IsTripsODPlot = 0;
            obj.IsSAreaPlot = 0;
            obj.axes = [];
            
        end
        
%% PLOT FUNCTIONS

        % OriginPlot
        function OriginPlot(ODmatrix, obj)
            
            % O matrix
            Omat = sum(ODmatrix,1); % sum by rows

            % Plot figure
            x = 1:size(Omat,2);
            plot(obj.axes, x, Omat);
            title('Accumulated trips by Origin station');
            xlim([0 size(Omat,2)+1]);
             
        end
        
        % DestinationPlot
        function DestinationPlot(ODmatrix, obj)
            
            % D matrix
            Dmat = sum(ODmatrix,2); % sum by columns

            % Plot figure
            x = 1:size(Dmat,1);
            plot(obj.axes, x, Dmat);
            title('Accumulated trips by Destination station');
            xlim([0 size(Dmat,1)+1]);
            
        end
        
        % TripsODPlot
        function TripsODPlot(OD, obj)
                        
            y = zeros(size(OD,2),1);
            % 24 hourly OD matrices
            for i=1:size(OD,2)
                
                % Sum of components for 1 O/D matrix
                y(i) = sum(OD(i).Matrix,'all');
            end
            
            % Plot bar figure
            x = 0:size(OD,2)-1;
            b = bar(x, y);
            % Set values as text on top of bars
            xtips1 = b(1).XEndPoints;
            ytips1 = b(1).YEndPoints;
            labels1 = string(round(b(1).YData,0));
            text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
                'VerticalAlignment','bottom');
            % Title
            title('Total trips by hour');
            % XLim
            xlim([-1 size(OD,2)]);
            
        end
        
        % SAreaPlot
        function SAreaPlot(SArea, Station, FFZone, Cars, Users, notServicedUsers, t, obj)
           
            % Plot service area
            mapshow(SArea);
            hold on;
            
%             %
%             % Plot free float zones
%             %
%             X = zeros(1, size(FFZone,2));
%             Y = X;
%             %
%             for i=1:size(FFZone,2)
%                 X(i) = FFZone{i}.X;
%                 Y(i) = FFZone{i}.Y;
%             end
%             %
%             scatter(X,Y,10,'red','filled');
            
            %
            % Plot stations
            %
            X = zeros(1, size(Station,2));
            Y = X;
            txt = {};
            %
            for i=1:size(Station,2)
                X(i) = Station{i}.X;
                Y(i) = Station{i}.Y;
                txt{i} = num2str(Station{i}.optCars(1));
            end
            %
            scatter(X,Y,10,'blue','filled');
            text(X,Y,txt,'Color','blue','FontSize',10);
            
            %
            % Plot combustion cars
            %
            X = [];
            Y = [];
            %
            for i=1:size(Cars,2)
                if Cars{i}.isElectric == 0
                    X(end+1) = Cars{i}.X(t);
                    Y(end+1) = Cars{i}.Y(t);
                end
            end
            disp(['Combustion cars: ', num2str(size(X,2))]);
            %
            scatter(X,Y,'black','filled');
            
            %
            % Plot electric cars
            %
            X = [];
            Y = [];
            %
            for i=1:size(Cars,2)
                if Cars{i}.isElectric == 1
                    X(end+1) = Cars{i}.X(t);
                    Y(end+1) = Cars{i}.Y(t);
                end
            end
            disp(['Electric cars: ', num2str(size(X,2))]);
            %
            scatter(X,Y,'green','filled');
            
            %
            % Plot users
            %
            X = zeros(1, size(Users,2));
            Y = X;
            %
            for i=1:size(Users,2)
                X(i) = Users{i}.X;
                Y(i) = Users{i}.Y;
            end
            %
            scatter(X,Y,'red','filled');
            
            %
            % Plot not serviced users
            %
%             X = [];
%             Y = X;
%             for i=1:size(notServicedUsers,1)
%                 if notServicedUsers(i,4) == t
%                     X(end+1) = notServicedUsers(i,1);
%                     Y(end+1) = notServicedUsers(i,2);
%                 end
%             end
%             %
%             scatter(X,Y,'magenta','filled');
            
            % Add legend
%             legend('Station (Car num)', 'Car', 'eCar', 'User', 'Not Serviced Users');
            legend('Station (Car num)', 'Car', 'eCar', 'User');
            
            % Make axis invisible
            set(gca,'xtick',[],'ytick',[]);

        end
        
    end
    
end