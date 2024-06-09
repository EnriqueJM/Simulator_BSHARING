function generatePdfSummary(param, MyOutput)
%GENERATEPDFSUMMARY - ver. 0.1
%   Detailed explanation goes here
if isdeployed
    makeDOMCompilable();
end

% Import packages
import mlreportgen.report.*
import mlreportgen.dom.*

% Find folder name and simulation date
k1 = find(param.ResFile=='/');
k2 = find(param.ResFile=='.');
folder = [param.ResFile(1:k2(end)-1) '_output'];
date = [param.ResFile(k1(end)+1:k2(end)-1)];
k3 = find(date=='_');
date = [date(1:k3(2)-1)];

% Select table data
summaryTable = MyOutput.Summary;
% 

%%
%%% Create report package
rpt = Report([folder '/' date '_Simulation_Summary'],"pdf");

%%% Title page
tp = TitlePage();
tp.Title = "Carsharing Simulation Summary";
% tp.Image = "peppers.png";
tp.Author = " ";
dt = datetime(date,'InputFormat','yyyyMMdd_HHmmss');
dt = datestr(dt,'mmmm dd, yyyy');
tp.PubDate = dt;
add(rpt,tp);

%%% Table of content
toc = TableOfContents();
add(rpt,toc);

%%
% Style parameters
style = { ...
    Border("solid"), ...
    RowSep("solid"), ...
    ColSep("solid"), ...
    OuterMargin("5pt","5pt","5pt","5pt")};
entriesStyle = {InnerMargin("2pt")};
headerStyle = { ...
    BackgroundColor("LightBlue"), ...
    Bold };

%%
% Find position of categories in table
%
aux = summaryTable{:,1};
k1 = find(strcmp('VEHICLES',aux));
k2 = find(strcmp('BATTERY LEVEL',aux));
k3 = find(strcmp('STATION OCCUPANCY',aux));
k4 = find(strcmp('UNBALANCE',aux));
k5 = find(strcmp('DEMAND',aux));
k6 = find(strcmp('REPOSITIONING',aux));
%
k7 = find(strcmp('COSTS',aux));

%% KPI TABLE 1 - CARS
if size(k1,1) > 0 && size(k1,2) > 0
    ini = k1;
else
    if size(k2,1) > 0 && size(k2,2) > 0
        ini = k2;
    else
        ini = 0;
    end
end
%
if ini > 0
    if size(k2,1) > 0 && size(k2,2) > 0
        tableData = summaryTable(ini:k2+4,:);
    else
        tableData = summaryTable(ini:k1+12,:);
    end

    table = Table(tableData);
    table.Style = style;
    table.TableEntriesStyle = entriesStyle;
    headerStyle = { ...
        BackgroundColor("LightBlue"), ...
        Bold };
    table.row(1).Style = headerStyle;

    fig = FormalImage([folder '\Vehicles\CarStatus_AggT\CarStatus_AggT_T1-1440.jpg']);

    ch = Chapter("Car Performance Summary");
    add(ch,table);
    % append(ch,fig);
    add(rpt,ch);
end

%% KPI TABLE 2 - OCCUPANCY/IMBALANCE
if size(k3,1) > 0 && size(k3,2) > 0
    ini = k3;
else
    if size(k4,1) > 0 && size(k4,2) > 0
        ini = k4;
    else
        if size(k5,1) > 0 && size(k5,2) > 0
            ini = k5;
        else
            ini = 0;
        end
    end
end
%
if ini > 0
    if size(k5,1) > 0 && size(k5,2) > 0
        tableData = summaryTable(ini:k5+23,:);
    else
        if size(k4,1) > 0 && size(k4,2) > 0
            tableData = summaryTable(ini:k4+4,:);
        else
            tableData = summaryTable(ini:k3+5,:);
        end
    end

    table = Table(tableData);
    table.Style = style;
    table.TableEntriesStyle = entriesStyle;
    headerStyle = { ...
        BackgroundColor("LightBlue"), ...
        Bold };
    table.row(1).Style = headerStyle;

    ch = Chapter("Spatial Performance Summary");
    add(ch,table);
    add(rpt,ch);
end

%% KPI TABLE 3 - REPOSITIONING
if size(k6,1) > 0 && size(k6,2) > 0
    tableData = summaryTable(k6:k6+30,:);

    table = Table(tableData);
    table.Style = style;
    table.TableEntriesStyle = entriesStyle;
    headerStyle = { ...
        BackgroundColor("LightBlue"), ...
        Bold };
    table.row(1).Style = headerStyle;

    ch = Chapter("Repositioning Performance Summary");
    add(ch,table);
    add(rpt,ch);
end

%% COST TABLE
tableData = summaryTable(k7:end,:);

table = Table(tableData);
table.Style = style;
table.TableEntriesStyle = entriesStyle;
headerStyle = { ...
    BackgroundColor("LightBlue"), ...
    Bold };
table.row(1).Style = headerStyle;

ch = Chapter("Cost Summary");
add(ch,table);
add(rpt,ch);

%% END (CLOSE AND VIEW)
close(rpt);
rptview(rpt)

% grps = TableColSpecGroup;
% grps.Span = 1;
% grps.Style = headerStyle;
% table.ColSpecGroups = grps;



%% HELP
%%% Create chapter with figure/table
% ch = Chapter("Imports Summary Graph");
% fig = Figure(fig);  % tab = 
% add(ch,fig/Table);
% add(rpt,ch);

%%% Create chapter with table slices
% 
% for slice = slices
%     ch = Chapter();
%     ch.Title = strjoin(["Data from" years(slice.StartCol-1)...
%         "to" years(slice.EndCol-1)]);
%     add(ch,slice.Table);
%     add(rpt,ch);
% end


end

