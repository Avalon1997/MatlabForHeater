% --------------------------------------------------
% 
%               两点校正法数据预载入 第二版
% 
% --------------------------------------------------



% 获取文件夹中的文件，判断类型并根据类型读取相应的数据并暂存。
folder = "D:/EDProgram/MatlabForHeater/TempClibrationData/TwoPointCalibrationData";
file = dir(folder); 
file = file(~[file.isdir]);
file_num = length(file);

% 判断文件夹内文件数量是否合规
if (file_num ~= 4)
    disp("文件数量异常！ 数据未加载！");
    return;
else
    disp("文件数量正常，正在加载数据！");
end

% 分割文件名
filenamecell = cell(1, file_num);
for i = 1:1:file_num
    filenamecell{i} = string(strsplit(file(i).name, '_'));
end

% 载入原始数据
rawdatacell = cell(2, fix(file_num/2));
for i = 1:1:file_num    
    if (filenamecell{i}(1, 1) == "heater")
        rawdatacell{1, fix(str2double(filenamecell{i}(end-1)))} = readtable (sprintf(strcat(folder,"/",file(i).name)),"VariableNamingRule","preserve");
    else
        rawdatacell{2, fix(str2double(filenamecell{i}(end-1)))} = readtable (sprintf(strcat(folder,"/",file(i).name)),"VariableNamingRule","preserve");
    end
end

% Get the average data about every position for heater.
average_heater_data = zeros(2, 7);
average_heater_data(1, :) = sum(table2array(rawdatacell{1, 1}(:, :))./height(rawdatacell{1, 1}));

filtered_heat_data = cell(1, 7);
j = 1;
for i = 1:1:height(rawdatacell{1, 2})
    if (table2array(rawdatacell{1, 2}(i, 1)) ~= 0)
        filtered_heat_data{1, j} = [filtered_heat_data{1, j}; rawdatacell{1, 2}(i, j + 1)];
    end
    if (table2array(rawdatacell{1, 2}(i, 1)) == 2399)
        average_heater_data(2, j) = sum(table2array(filtered_heat_data{1, j}(500:end, :)))/height(filtered_heat_data{1, j}(500:end, :));
        j = j + 1;
    end
end

% Get average data of the corresponding position for wafer.
average_wafer_data = zeros(2, 7);
fileter_wafer_data = cell(1, 7);

average_wafer_data(1, 1) = sum(table2array(rawdatacell{2, 1}(:, 3)))/height(rawdatacell{2, 1}(:, 3));
average_wafer_data(1, 2) = sum(table2array(rawdatacell{2, 1}(:, 12)))/height(rawdatacell{2, 1}(:, 12));
average_wafer_data(1, 3) = sum(table2array(rawdatacell{2, 1}(:, 16)))/height(rawdatacell{2, 1}(:, 16));
average_wafer_data(1, 4) = sum(table2array(rawdatacell{2, 1}(:, 21)))/height(rawdatacell{2, 1}(:, 21));
average_wafer_data(1, 5) = sum(table2array(rawdatacell{2, 1}(:, 25)))/height(rawdatacell{2, 1}(:, 25));
average_wafer_data(1, 6) = sum(table2array(rawdatacell{2, 1}(:, 29)))/height(rawdatacell{2, 1}(:, 29));
average_wafer_data(1, 7) = sum(table2array(rawdatacell{2, 1}(:, 33)))/height(rawdatacell{2, 1}(:, 33));

fileter_wafer_data{1, 1} = rawdatacell{2, 2}(1:4470,3);
fileter_wafer_data{1, 2} = rawdatacell{2, 2}(4471:8698, 12);
fileter_wafer_data{1, 3} = rawdatacell{2, 2}(8699:13102, 16);
fileter_wafer_data{1, 4} = rawdatacell{2, 2}(13103:17251, 21);
fileter_wafer_data{1, 5} = rawdatacell{2, 2}(17252:21305, 25);
fileter_wafer_data{1, 6} = rawdatacell{2, 2}(21306:25468, 29);
fileter_wafer_data{1, 7} = rawdatacell{2, 2}(25469:end, 33);

for i = 1:1:7
    average_wafer_data(2, i) = sum(table2array(fileter_wafer_data{1, i}(500:2500, :)))/height(fileter_wafer_data{1, i}(500:2500, :));
end

clear i j fileter_wafer_data filtered_heat_data  ;




