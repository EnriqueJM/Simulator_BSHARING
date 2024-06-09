%                                                                         %
%                   VSHARING   S i m u l a t i o n                        %
%                       RepoExperimentFigures                             % 
%                                                                         % 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% AUTHOR: Enrique Jimenez-Merono
% DOCUMENT: "Simulation of a public e-car sharing system" - PhD thesis
% TUTOR: Francesc Soriguera
% UNIVERSITY: Universitat Politècnica de Catalunya
% DATE: May 2024
%--------------------------------------------------------------------------

% DESCRIPTION
% This is the main script to generate the figures from the repositioning
% strategies alternatives experiments simulated in the Vsharing Simulator.
%
% INITIAL: Delete all the existent variables, close all the windows created
% by Matlab, clear the command window and add all the necessary
% folders and subfolders to path.
% SIMULATION RESULTS DATA FILE PATH: Here the user introduces the
% simulation results data file name and path for the postprocessing.
% INPUTS: Initialize all the needed parameters to run the program. The user
% must introduce the values of those parameters following the instructions
% collected on the User Manual.
% OUTPUT POSPROCESSING: Create an Output object and generate the outputs 
% defined by the user.
%--------------------------------------------------------------------------

%% INITIAL:
    clc;
    clear;
    close all;
    if isdeployed
%         mainDir = getmainDir();
        mainDir = getExecutableFolder();
        cd(mainDir)
    elseif (~isdeployed)
        mainDir = pwd;
        addpath(genpath(mainDir));           
    end

%% SIMULATION RESULTS DATA FILE PATH
%--------------------------------------------------------------------------
%          INTRODUCE HERE FILE NAME AND PATH OF SIMULATION DATA
%--------------------------------------------------------------------------

results_filename = 'Results/20240603_203652_Final_City_Variables.mat';
figure_filename = 'pwise_e36';
table_filename = 'Results/20240603_203652_Final_City_Variables_output/TableFullEmpty.xlsx';
table_subtitle = 'Scenario 1 (Real-time pairwise assignment)';

%% INPUTS
param = struct();
%
%--------------------------------------------------------------------------
%                     READ OUTPUT PARAMETERS
%--------------------------------------------------------------------------
[num, txt, alldata] = xlsread('Data/outputs.xlsx');
alldata(1,:)=[];
alldata(:,1)=[];
for i=1:size(txt,1)-1
    param.(alldata{i,1}) = alldata{i,2};
end

%% FIGURE PROCESSING %%
    %%% Read datafile
        try
            load(results_filename);
        catch
            error(['Error: File ' obj.datafile ' cannot be loaded']);
        end
    %

    % Plot table graphically by stations
    titulo = 'Average number of empty stations';
    unit_labl = 'Time spent empty [%]';
    plotTableStation('StationEmpty_AggT', table_filename, MyCity, titulo, table_subtitle, unit_labl, [figure_filename '_empty']);
    titulo = 'Average number of full stations';
    unit_labl = 'Time spent full [%]';
    plotTableStation('StationFull_AggT', table_filename, MyCity, titulo, table_subtitle, unit_labl, [figure_filename '_full']);


        % plotTableStation
        function plotTableStation(tab_name, xlsfile, MyCity, titulo, table_subtitle, unit_labl, figure_filename)
            % Function that plots table graphically by station
            
            % Get table by name
            tab = readtable(xlsfile,'sheet',tab_name);
            cols = tab.Properties.VariableNames;
            cmap = colormap(flipud(bone));
           
            % Create folder to export jpg
            k = find(xlsfile=='/');
            if isempty(k)
                k = find(xlsfile=='\');
            end
            folder = [xlsfile(1:k(end))];
                
            % Get list of indexes depending on Station ID
            list_IDs = zeros(1,MyCity.numStations);
            for i=1:MyCity.numStations
                list_IDs(i) = MyCity.vStations{i}.ID;
            end
            %
            ind = zeros(size(tab,1),1);
            for i=1:size(tab,1)
                ind(i) = find(tab.ID(i)==list_IDs);
            end
            
            % Loop over columns (do not consider ID & Name)
            for i=3:size(cols,2)
                aux = zeros(MyCity.numStations,1);
                %
                % Get column values for every station in table
                for j=1:size(tab,1)
                    aux(ind(j)) = tab.(cols{i})(j);
                end
                %
%                 cmin = min(aux);
%                 cmax = max(aux);
                cmin = 0;
                cmax = 100;
                m = length(cmap);
                %
                % Generate figure
                figure('Visible','off');
                mapshow(MyCity.servArea, 'FaceColor', 'none')
                set(gca,'fontname','times')
                colormap(flipud(bone))
                hold on;
                %
                for j=1:MyCity.numStations
                    index = fix((aux(j)-cmin)/(cmax-cmin)*m)+1;
                    RGB = cmap(min(index,m),:);
                    %
                    scatter(MyCity.vStations{ind(j)}.X, MyCity.vStations{ind(j)}.Y, 30, RGB, 'filled','markeredgecolor','black');
%                     ax.scatter(edgecolors='black');
                    hold on;
                end
                % Set colormap
%                 colormap jet;
                h = colorbar('Ticks',[0, 0.5 ,1], 'TickLabels', ...
                    {num2str(cmin,'%.2f'), num2str((cmax+cmin)/2,'%.2f'), num2str(cmax,'%.2f')});
                ylabel(h, unit_labl,'fontname','times', 'FontSize', 14);
                %set(c, 'Ylim', [cmin cmax]);
                
                % Title
                title(titulo, 'Interpreter','none','fontname','times', 'FontSize', 16);
                %subtitle(['Table: ' tab_name ' - ' cols{i}], 'Interpreter','none');
                subtitle(table_subtitle, 'Interpreter','none','fontname','times');
                xlabel('X UTM Coordinate [m]','fontname','times', 'FontSize', 14)
                ylabel('Y UTM Coordinate [m]','fontname','times', 'FontSize', 14)
                
                % Print figure to jpg file
                filename = [folder '/' figure_filename '.jpg'];
                saveas(gcf,filename);
                close(gcf);
            end
            
        end