%
% Script to generate plots from datafile
%
clear
close all
addpath(genpath(pwd));
%
% Load datafile OD
datafile = '20210412_204922_OD_Acumulated.csv';
if strcmp(datafile(end-2:end),'csv') == 1
    ODmat = csvread(datafile);
else
    ODmat = xlsread(datafile);
end
%
% Create object from PostProcess class
MyPostProcess = PostProcess;
%
% Set tags for active plots
MyPostProcess.IsOriginPlot = 1;
MyPostProcess.IsDestinationPlot = 1;
%
% Plot trips by origin station
if MyPostProcess.IsOriginPlot == 1
    Fig1 = figure(1);
    MyPostProcess.axes = axes(Fig1);
    OriginPlot(ODmat, MyPostProcess);
else
    disp('The IsOriginPlot tag is set to false');
end
%
% Plot trips by origin station
if MyPostProcess.IsDestinationPlot == 1
    Fig2 = figure(2);
    MyPostProcess.axes = axes(Fig2);
    DestinationPlot(ODmat, MyPostProcess);
else
    disp('The IsDestinationPlot tag is set to false');
end
%


