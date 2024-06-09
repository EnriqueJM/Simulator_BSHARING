%               ___  ___       ___       __   __   __                     %
%              |   \/   |     /   \     |  | |  \ |  |                    %
%              |  \  /  |    /  ^  \    |  | |   \|  |                    % 
%              |  |\/|  |   /  /_\  \   |  | |  . `  |                    %
%              |  |  |  |  /  _____  \  |  | |  |\   |                    %
%              |__|  |__| /__/     \__\ |__| |__| \__|                    %
%                P E B I S S   S i m u l a t i o n                        %

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% AUTHOR: Enrique Jimenez-Merono
% DOCUMENT: "Simulation of a public e-bike sharing system" - PhD thesis
% TUTOR: Francesc Soriguera
% UNIVERSITY: Universitat Politècnica de Catalunya
% DATE: August 2022
%--------------------------------------------------------------------------

% DESCRIPTION
% This is the main script to run the program. 
% INITIAL: Delete all the existent variables, close all the windows created
% by Matlab, clear the command window and add all the necessary
% folders and subfolders to path.
% INPUTS: Initialize all the needed parameters to run the program. The user
% must introduce the values of those parameters following the instructions
% collected on the User Manual. The input matrixes of Stations and  O/D
% must be stored in the 'Data' folder as explained on the User
% Manual.
% SIMULATION: Create a City and run the simulation (initialize the city and
% simulate all the procedures in time).
%--------------------------------------------------------------------------

% INITIAL:
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

    % Create results folder
    [status, msg, msgID] = mkdir(mainDir,'Results');
    if status == 0
        error('Error: Results folder could not be created because: "%s"\n', msg);
    end
    

%% INPUTS
param = struct();
%
%Code version
param.ver = '1.6.8';

%--------------------------------------------------------------------------
%                     READ INPUT PARAMETERS
%--------------------------------------------------------------------------
[~, ~, alldata] = xlsread('Data/inputs.xlsx');
alldata(1,:)=[];
alldata(:,1)=[];
for i=1:size(alldata,1)
    param.(alldata{i,1}) = alldata{i,2};
end

%--------------------------------------------------------------------------
%                        SET RANDOM SEED
%--------------------------------------------------------------------------
param.rndSeed = [];
if size(param.rndSeed,1) > 0 && size(param.rndSeed,2) > 0
    myStream = RandStream(param.rndSeed);
    RandStream.setGlobalStream(myStream);
else
    param.rndSeed = RandStream.getGlobalStream.Type;
end

%--------------------------------------------------------------------------
%                       TIME PARAMETERS
%--------------------------------------------------------------------------    
% Array of demand updates
n_upd = floor(param.TotalTime / param.TimeReDemand);
param.ArrayReDemand = param.TimeReDemand * (1:n_upd);


%% SIMULATION %%

    % Create objects of City class
    MyCity = City;

    % Run time simulation
    simulation(param, MyCity);

    % Save results to file
    t = datestr(now,'yyyymmdd_HHMMSS');
    save (['Results/' t '_Final_City_Variables.mat'], 'MyCity');

%% SUMMARY %%
    %%% Create folder with input summary
    % Name of the subfolder
    fldrname =  [t '_Final_City_Variables_input'];
    % Create subfolder
    [status, ~, ~] = mkdir([mainDir '/Results'],fldrname);
    if status == 0
        error('Error: Output folder could not be created');
    end
    % Name of the subfolder GLOBAL PATH.
    resultsDir = [mainDir '/Results/' fldrname '/'];
    %
    %%% Export files
    % Saving raw inputs
    disp('Saving Inputs');
    param.minBatteryPerc = MyCity.minBatteryLevel; % For the txt input recap. 
    outputInputs(param, t, resultsDir);
    % Saving generated station lists
    disp('Saving Station Summary');
    outputStations(param, MyCity, resultsDir);
    % Saving generated zonification
    disp('Saving Zonification Summary');
    outputZonification(param, MyCity, resultsDir)
    % Saving generated OD matrices
    if param.OdmatKnown == 0
        disp('Exporting Generated O/D Matrices');
        outputODMatrices(MyCity.OD, param.Odmat_out, resultsDir, MyCity.zoneNum);
    end
    % Saving demand array of users
    users = MyCity.vUsersGen;
    save ([resultsDir t '_Generated_Users.mat'], 'users');
    clear users
    % Saving demand parameters and figures
    disp('Saving Demand Characterization Summary');
    [~] = calculateImbalanceParam(param, MyCity, t, resultsDir);

%     clear t fldrname status
        
