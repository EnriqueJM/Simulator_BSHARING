%                                                                         %
%                P E C I S S   S i m u l a t i o n                        %
%                          GenerateOutput                                 % 
%                                                                         % 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% AUTHOR: Enrique Jimenez-Merono
% DOCUMENT: "Simulation of a public e-car sharing system" - PhD thesis
% TUTOR: Francesc Soriguera
% UNIVERSITY: Universitat Politècnica de Catalunya
% DATE: April 2021
%--------------------------------------------------------------------------

% DESCRIPTION
% This is the main script to generate the output from simulation file. 
% INITIAL: Delete all the existent variables, close all the windows created
% by Matlab, clear the command window and add all the necessary
% folders and subfolders to path.
% INPUTS: Initialize all the needed parameters to run the program. The user
% must introduce the values of those parameters following the instructions
% collected on the User Manual.
% SIMULATION: Create an Output object and generate the outputs defined 
% by the user.
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

%% SIMULATION %%

        % Create object of Output class
        MyOutput = Output;
        
        % Initialize the output object
        initializeOutput(param, MyOutput);

        % Create Tables & Plots by Category
        createResultsCategory(param, MyOutput, mainDir);
        
        % Generate Summary .pdf file
%         generatePdfSummary(param, MyOutput);
        