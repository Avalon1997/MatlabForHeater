% ---------------------------------------------------------------------- %
% 
% 
% Two point calibration version 2.0 in the lab environment
% 
%                                      CharlesYu (http://www.Lhy1997.com)
% ---------------------------------------------------------------------- %

% Root directory of TPC data.
folder_path = "D:\EDProgram\MatlabForHeater\LaboratoryTemperatureData" + ...
              "\CalibrationData\CalibrationData_OneByOne\";
% Get file struct of hot plate and wafer.
file_stc = dir(folder_path);
file_stc = file_stc(~[file_stc.isdir]);
file_number = length(file_stc);
hotplate_file_stc = ([]);
wafer_file_stc = ([]);
for i = 1:1:file_number
%     dr = contains(file_stc(i).name, "HotPlate");
    if contains(file_stc(i).name, "HotPlate")
        hotplate_file_stc = [hotplate_file_stc file_stc(i)];
    elseif contains(file_stc(i).name, "DatCHLOG")
        wafer_file_stc = [wafer_file_stc file_stc(i)];
    elseif contains(file_stc(i).name, "Hotplate") && contains(file_stc(i).name, "RT")
        hotplate_rtdata = readtable(strcat(folder_path, file_stc(i).name), "VariableNamingRule", "preserve");
    elseif contains(file_stc(i).name, "Wafer")
        wafer_rtdata = readtable(strcat(folder_path, file_stc(i).name), "VariableNamingRule", "preserve");
    end
end
clear file_stc
file_number = length(hotplate_file_stc);

% Split file name by '_'.
hotplate_name = cell(1, file_number);
wafer_name = cell(1, file_number);
for i = 1:1:file_number
    hotplate_name{i} = string(strsplit(hotplate_file_stc(i).name, '_'));
    wafer_name{i} = string(strsplit(wafer_file_stc(i).name, '_'));
end

% Load the raw temp data.
hotplate_rawdata = cell(1, file_number);
wafer_rawdata = cell(1, file_number);
for i = 1:1:file_number
    hotplate_rawdata{i} = readtable(strcat(folder_path, hotplate_file_stc(i).name), "VariableNamingRule","preserve");
    wafer_rawdata{i} = readtable(strcat(folder_path, wafer_file_stc(i).name), "VariableNamingRule","preserve");
end

% Filter hot plate raw data.
hotplate_filtereddata = zeros(5000, 7);
for i = 1:1:file_number
    hotplate_filtereddata(:, i) = table2array(hotplate_rawdata{i}(end-4999:end, i));
end

% Filter wafer raw data.
wafer_filtereddata = zeros(5000, 7);
wafer_filteredrtdata = zeros(height(wafer_rtdata), 7);
wafer_filtereddata(:, 1) = table2array(wafer_rawdata{1}(end-4999:end, 3));
wafer_filtereddata(:, 2) = table2array(wafer_rawdata{2}(end-4999:end, 12));
wafer_filtereddata(:, 3) = table2array(wafer_rawdata{3}(end-4999:end, 12));
wafer_filtereddata(:, 4) = table2array(wafer_rawdata{4}(end-4999:end, 21));
wafer_filtereddata(:, 5) = table2array(wafer_rawdata{5}(end-4999:end, 25));
wafer_filtereddata(:, 6) = table2array(wafer_rawdata{6}(end-4999:end, 29));
wafer_filtereddata(:, 7) = table2array(wafer_rawdata{7}(end-4999:end, 33));
wafer_filteredrtdata(:, 1) = table2array(wafer_rtdata(:, 3));
wafer_filteredrtdata(:, 2) = table2array(wafer_rtdata(:, 12));
wafer_filteredrtdata(:, 3) = table2array(wafer_rtdata(:, 16));
wafer_filteredrtdata(:, 4) = table2array(wafer_rtdata(:, 21));
wafer_filteredrtdata(:, 5) = table2array(wafer_rtdata(:, 25));
wafer_filteredrtdata(:, 6) = table2array(wafer_rtdata(:, 29));
wafer_filteredrtdata(:, 7) = table2array(wafer_rtdata(:, 33));

% TPC calculation data array
hotplate_tpcdata = zeros(2, 7);
wafer_tpcdata = zeros(2, 7);
hotplate_tpcdata(1, :) = sum(table2array(hotplate_rtdata))/height(hotplate_rtdata);
hotplate_tpcdata(2, :) = sum(hotplate_filtereddata)/length(hotplate_filtereddata);
wafer_tpcdata(1, :) = sum(wafer_filteredrtdata)/length(wafer_filteredrtdata);
wafer_tpcdata(2, :) = sum(wafer_filtereddata)/length(wafer_filtereddata);

% TPC coefficients and constants
[coecos, coecos_string] = TwoPointCalibration(hotplate_tpcdata, wafer_tpcdata);

% disp();


