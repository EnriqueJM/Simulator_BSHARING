%                                                                         %
%                   VSHARING   S i m u l a t i o n                        %
%                       RepoExperimentOutputs                             % 
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
% This is the main script to generate the results from the repositioning
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
    
results_filename = 'Results\20240603_203652_Final_City_Variables.mat';


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

%% OUTPUT POSTPROCESSING %%
        %%% Create output folder
        k = find(results_filename=='.');
        folder = [results_filename(1:k(end)-1) '_output'];
        [status, msg, msgID] = mkdir(mainDir,folder);
        if status == 0
            error('Error: Output folder could not be created');
        end
        % 
        %%% Read datafile
            try
                load(results_filename);
            catch
                error(['Error: File ' obj.datafile ' cannot be loaded']);
            end
        %
        %%% Calculate system-level results
        if param.verbose
            disp('Creating system-level results');
        end
        filename = 'Table_summary.xlsx';
        [RESULTS] = Calculate_Stats(MyCity);
        writematrix(RESULTS, [folder '/' filename]);

        %
        %%% Station-by-station results
        %
        % Create excel file
        filename = 'TableFullEmpty.xlsx';
        xlsfile = [folder '/' filename];
        if isfile(xlsfile)
            delete(xlsfile);
        end
        
        if param.verbose
            disp('Creating station-by-station results');
        end
        %
        sheet1 = 'StationEmpty_AggT';
        sheet2 = 'StationFull_AggT';
        StationI = 1;
        StationF = MyCity.numStations;
        tableEmptyFullStationAggT(param, xlsfile, sheet1, sheet2, StationI, StationF, MyCity);
         
        
%% tableFullEmptyStations
function tableEmptyFullStationAggT(param, xlsfile, sheet1, sheet2, statI, statF, MyCity)
    % Function to create tables with fraction of time spent full or empty
    % by stations.

    % Generate first 2 columns with labels
    ID = []; Name = {};
    for istat=statI:statF
        ID(end+1,1) = MyCity.vStations{istat}.ID;
        try
            Name(end+1,1) = MyCity.vStations{istat}.Name;
        catch
            Name(end+1,1) = {''};
        end
    end
    %
    StationEmpty_AggT = table(ID, Name);
    StationFull_AggT = table(ID, Name);

    % Generate number of empty slots per station in every hour as mean of
    % 60min
    TotalTime = size(MyCity.vCars{1}.status,2);
    list_stat = statI:statF;
    %
    aux1 = zeros(statF-statI+1, TotalTime);
    aux2 = zeros(statF-statI+1, TotalTime);
    %
    for istat=1:size(list_stat,2)
        %
        for t=1:TotalTime
            % Count capacities in station at time t
            capacity = MyCity.vStations{list_stat(istat)}.capacity;
            numcars = size(MyCity.vStations{list_stat(istat)}.vlistCars{t},2);
            %
            if numcars == 0
                aux1(istat,t) = 100;
            end
            if numcars == capacity
                aux2(istat,t) = 100;
            end
%             if capacity > 0 && capacity < 9999 % Only if restricted capacity
%                 aux1(istat,t) = capacity - numcars; % Empty slots
%                 aux2(istat,t) = 100 * numcars / capacity; % Occupancy (%)
%             else
%                 aux1(istat,t) = NaN;
%                 aux2(istat,t) = NaN;
%             end
        end

        % Add column to table
        StationEmpty_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux1,2);
        StationFull_AggT.(['T' num2str(1) '-' num2str(TotalTime)]) = mean(aux2,2);
    end
    %
    % Export tables to excel file xlsfile in sheet
    writetable(StationEmpty_AggT, xlsfile, 'Sheet', sheet1);
    writetable(StationFull_AggT, xlsfile, 'Sheet', sheet2);
    
%     modifile = 'Results/ERR2_36/20230402_124415_Final_City_Variables_output/StationOccupancy/Tables_station_occupancy_comb.xlsx';
%     obj.EmptySlotsSB_AggT = readtable(modifile, 'Sheet', sheet1);
%     obj.OccupancySB_AggT = readtable(modifile, 'Sheet', sheet2);
end       