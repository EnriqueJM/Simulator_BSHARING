function [vStationsOut, m_i, req, ret] = ...
    optimDistribution(vStations, NVeh, Timer, BPen)
% OPTIMDISTRIBUTION - ver. 1.0
%   Provides the optimal distribution of vehicles between stations on a
%   given time step of the simulation. This function also works for the
%   distribution of vehicles between FF_zones.
%   INPUTS:
%   - vStations -> {Array Nx1} Array of station/FF_zone class objects.
%   - NVeh -> Total number of vehicles to distribute.
%   - BPen -> {Array 2x1} Value of no-service penalties in origin and
%   destination.
%   - Timer -> Evaluation time index. (Note that t=0 -> Timer=1)
%   OUTPUTS:
%   - vStationsOut -> {Array Nx1} Array of station/FF_zone class objects.
%   ONLY DEBUG:
%   - m_i -> {Array Nx1} Array of station/FF_zone optimal distribution.
%   - req -> {Array Nx1} Array of station/FF_zone accumulated requests.
%   - ret -> {Array Nx1} Array of station/FF_zone accumulated returns.


%%% Inicializa las variables auxiliares.
inc_NSP = zeros(length(vStations),1);
m_i = zeros(length(vStations),1);
req = zeros(length(vStations),1);
ret = zeros(length(vStations),1);

%%% Se calcula aquí para cada una de las estaciones:
%%% - Retornos esperados hasta el final del día.
%%% - Demanda esperada hasta el final del día.
%%% - Incremento/ahorro de penalizaciones por añadir un vehículo extra.
for j=1:length(vStations)
    ret(j) = vStations{j}.accReturns(end) - vStations{j}.accReturns(Timer);
    req(j) = vStations{j}.accRequests(end) - vStations{j}.accRequests(Timer);
    inc_NSP(j) = NSPenalties(m_i(j), req(j), ret(j), vStations{j}.capacity, BPen)...
        - NSPenalties(m_i(j)+1, req(j), ret(j), vStations{j}.capacity, BPen);
end

%%% Uno a uno, se va asignando cada vehículo de la flota en aquella
%%% estación/zona donde se reducirían más las penalizaciones estimadas.
%%% Se actualiza posteriormente el incremento de penalizaciones de dicha
%%% estación.
%%% En las estaciones que alcanzan la capacidad máxima, el incremento de
%%% penalizaciones no existe (NaN) para que no se le asignen vehículos
%%% adicionales.
for i=1:NVeh

    [~,idx] = max(inc_NSP);
    m_i(idx) = m_i(idx) + 1;
    
    if m_i(idx) >= vStations{idx}.capacity
        inc_NSP(idx) = NaN;
    else
        inc_NSP(idx) = NSPenalties(m_i(idx), req(idx), ret(idx), vStations{idx}.capacity, BPen)...
            - NSPenalties(m_i(idx)+1, req(idx), ret(idx), vStations{idx}.capacity, BPen);
    end   
    
end

%%% Se actualiza la distribución óptima en todas las estaciones.
for j=1:length(vStations)
    vStations{j}.optCars(Timer) =  m_i(j);          
end

vStationsOut = vStations; %';

end

