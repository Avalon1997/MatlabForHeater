% ---------------------------------------------------------------------- %
% 
% 
% Two point calibration version 1.0 in the lab environment
% 
%                                      CharlesYu (http://www.Lhy1997.com)
% ---------------------------------------------------------------------- %

% Root directory of all data.
folder_path = "D:\EDProgram\MatlabForHeater\LaboratoryTemperatureData\Calibration";

% Split range
RANGE_START = int32(501);
RANGE_END = int32(3500);

% ---------------------------------------------------------------------- %
% Get the wafer data ----------
% ---------------------------------------------------------------------- %
wa_folder_path = strcat(folder_path, "TPCWaferData\");
wa_file_struct = dir(wa_folder_path);
wa_file_struct = wa_file_struct(~[wa_file_struct.isdir]);
wa_file_number = length(wa_file_struct);

% Determine the number of files
if (wa_file_number ~= 2)
    disp("Error: Abnormal number of files in TPCWaferData folder!");
    return;
else
    disp("Run: Load wafer data ...");
end

% Split the file name with '_'
wafilename_cell = cell(1, wa_file_number);
for i = 1:1:wa_file_number
    wafilename_cell{i} = string(strsplit(wa_file_struct(i).name, '_'));
end

% Load the raw data
warawdata_cell = cell(1, wa_file_number);
for i = 1:1:wa_file_number
    warawdata_cell{i} = readtable(strcat(wa_folder_path, wa_file_struct(i).name),"VariableNamingRule","preserve");
end

% Filterd wafer raw data
wafilterdata_cell = cell(1, wa_file_number);
TableColumnNames = {'Var1', 'Var2', 'Var3', 'Var4', 'Var5', 'Var6', 'Var7'};
for i = 1:1:wa_file_number
    wafilterdata_cell{i}(:, 1) = warawdata_cell{i}(RANGE_START:RANGE_END, 1+3);
    wafilterdata_cell{i}(:, 2) = warawdata_cell{i}(RANGE_START:RANGE_END, 10+3);
    wafilterdata_cell{i}(:, 3) = warawdata_cell{i}(RANGE_START:RANGE_END, 14+3);
    wafilterdata_cell{i}(:, 4) = warawdata_cell{i}(RANGE_START:RANGE_END, 19+3);
    wafilterdata_cell{i}(:, 5) = warawdata_cell{i}(RANGE_START:RANGE_END, 23+3);
    wafilterdata_cell{i}(:, 6) = warawdata_cell{i}(RANGE_START:RANGE_END, 27+3);
    wafilterdata_cell{i}(:, 7) = warawdata_cell{i}(RANGE_START:RANGE_END, 31+3);
    wafilterdata_cell{i}.Properties.VariableNames = TableColumnNames;
end


% ---------------------------------------------------------------------- %
% Get the hot plate data ----------
% ---------------------------------------------------------------------- %
hp_folder_path = strcat(folder_path, "TPCHotPlateData\");
hp_file_struct = dir(hp_folder_path);
hp_file_struct = hp_file_struct(~[hp_file_struct.isdir]);
hp_file_number = length(hp_file_struct);

% Determin the number of files
if (hp_file_number ~= 2)
    disp("Error: Abnormal number of files in TPCHotPlateData folder!");
    return;
else
    disp("Run: Load hot plate data ...");
end

% Split the file name with '_'
hpfilename_cell = cell(1, hp_file_number);
for i = 1:1:hp_file_number
    hpfilename_cell{i} = string(strsplit(hp_file_struct(i).name, '_'));
end

% Load the raw data
hprawdata_cell = cell(1, hp_file_number);
for i = 1:1:hp_file_number
    hprawdata_cell{i} = readtable(strcat(hp_folder_path, hp_file_struct(i).name), "VariableNamingRule", "preserve");
end

% Filtered hot plate raw data
hpfilterdata_cell = cell(1, hp_file_number);
for i = 1:1:hp_file_number
    hpfilterdata_cell{i} = hprawdata_cell{i}(RANGE_START:RANGE_END, :);
end


% ---------------------------------------------------------------------- %
% Calculate the average temperature values at seven positions on the hot
% plate and the corresponding temperature values at the wafer positions.
% ---------------------------------------------------------------------- %
% average_wafer_data = zeros(2, 8);
% for i = 1:1:wa_file_number
%     average_wafer_data(i, 1) = sum(wafilterdata_cell{i}.("温度CH1"))/height(wafilterdata_cell{i}(:, 1));
%     average_wafer_data(i, 2) = sum(wafilterdata_cell{i}.("温度CH10"))/height(wafilterdata_cell{i}(:, 10));
%     average_wafer_data(i, 3) = sum(wafilterdata_cell{i}.("温度CH14"))/height(wafilterdata_cell{i}(:, 14));
%     average_wafer_data(i, 4) = sum(wafilterdata_cell{i}.("温度CH19"))/height(wafilterdata_cell{i}(:, 19));
%     average_wafer_data(i, 5) = sum(wafilterdata_cell{i}.("温度CH23"))/height(wafilterdata_cell{i}(:, 23));
%     average_wafer_data(i, 6) = sum(wafilterdata_cell{i}.("温度CH27"))/height(wafilterdata_cell{i}(:, 27));
%     average_wafer_data(i, 7) = sum(wafilterdata_cell{i}.("温度CH31"))/height(wafilterdata_cell{i}(:, 31));
%     average_wafer_data(i, 8) = sum(average_wafer_data(i, 1:7))/7;
% end
% 
% average_hotplate_data = zeros(2, 8);
% for i = 1:1:hp_file_number
%     average_hotplate_data(i, 1:7) = sum([hpfilterdata_cell{i}.Var1, hpfilterdata_cell{i}.Var2, hpfilterdata_cell{i}.Var3, hpfilterdata_cell{i}.Var4, hpfilterdata_cell{i}.Var5, hpfilterdata_cell{i}.Var6, hpfilterdata_cell{i}.Var7])/height(hpfilterdata_cell{i});
%     average_hotplate_data(i, 8) = sum(average_hotplate_data(i, 1:7))/7;
% end


% ---------------------------------------------------------------------- %
% Two-point calibration code
% k = (y2 - y1) / (x2 - x1)
% b = (y2 - kx2) or b = (y1 - kx1)
% 
% ---------------------------------------------------------------------- %

coe = zeros(3000, 7);
cos = zeros(3000, 7);

for i = 1:1:3000
    for j = 1:1:7
        coe(i, j) = (table2array(wafilterdata_cell{1}(i, j)) - table2array(wafilterdata_cell{2}(i, j)))/(table2array(hpfilterdata_cell{1}(i, j)) - table2array(hpfilterdata_cell{2}(i, j)));
        cos(i, j) = (table2array(wafilterdata_cell{1}(i, j)) - coe(i, j)*table2array(hpfilterdata_cell{1}(i, j)));
    end
end

cc = zeros(2, 7);

cc(1, :) = sum(coe)/3000;
cc(2, :) = sum(cos)/3000;

















