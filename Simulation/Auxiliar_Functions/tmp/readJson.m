clear
jsonfile = 'Data/stations.json';
%
fid=fopen(jsonfile);
raw = fread(fid);
str = char(raw');
k = find(str=='[');
val = jsondecode(str(k:end));
%
fclose(fid);