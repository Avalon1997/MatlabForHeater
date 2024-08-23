% --------------------------------------------------
% 
%               两点校正法数据预载入
% 
% --------------------------------------------------



% 读取文件中数据
folder = "D:/EDProgram/MatlabForHeater/TempCalibration/TwoPointCalibrationData";
files = dir(folder);
files = files(~[files.isdir]);
files_num = length(files);
% 判断当前文件夹文件数量是否合规
if(files_num ~= 4)
    disp("文件数量异常！ 数据未加载！");
    return;
else
    disp("文件数量正常，正在加载数据");
end
strname = cell(1,files_num);
for i = 1:1:files_num
    strname{i} = string(strsplit(files(i).name,'_'));
end

% 载入原始数据
rawdata = cell(2,fix(files_num/2));
for i = 1:1:files_num
    if (strname{i}(1,1) == "heater")
        rawdata{1, fix(str2double(strname{i}(end-1)))} = readtable(sprintf(strcat(folder,"/",files(i).name)),"VariableNamingRule","preserve");
    else
        rawdata{2, fix(str2double(strname{i}(end-1)))} = readtable(sprintf(strcat(folder,"/",files(i).name)),"VariableNamingRule","preserve");
    end
end

% 过滤数据
filtered_data = cell(2,fix(files_num/2));
for i = 1:1:fix(files_num/2)
    if (height(rawdata{2, i}) < height(rawdata{1, i}))
        filtered_data{1, i} = table2array(rawdata{1, i}(end - height(rawdata{2, i}) + 1:end, 1:7));
        filtered_data{2, i} = table2array(rawdata{2, i}(:, 3:end));
    elseif (height(rawdata{2, i}) > height(rawdata{1, i}))
        filtered_data{1, i} = table2array(rawdata{1, i}(:, 1:7));
        filtered_data{2, i} = table2array(rawdata{2, i}(end - height(rawdata{1, i}) + 1:end,3:end));
    end
end

% 整合晶元数据对应热盘数据，求得二者不同温点的平均值
average_heater_data = zeros(2, 7);
average_wafer_data = zeros(2, 7);
for i = 1:1:fix(files_num/2)
    average_heater_data(i, :) = sum(filtered_data{1, i}(:, :))./height(filtered_data{1, i});
    for j = 1:1:7
        average_wafer_data(i,j) = sum(sum(filtered_data{2,i}(:,1:9),2)./9)/height(filtered_data{2,i});
        average_wafer_data(i,j) = sum(sum(filtered_data{2,i}(:,[2 3 4 8 9]),2)./5)/height(filtered_data{2,i});
        average_wafer_data(i,j) = sum(sum(filtered_data{2,i}(:,4:8),2)./5)/height(filtered_data{2,i});
        average_wafer_data(i,j) = sum(sum(filtered_data{2,i}(:,[19 20 21 33 34]),2)./5)/height(filtered_data{2,i});
        average_wafer_data(i,j) = sum(sum(filtered_data{2,i}(:,21:25),2)./5)/height(filtered_data{2,i});
        average_wafer_data(i,j) = sum(sum(filtered_data{2,i}(:,25:29),2)./5)/height(filtered_data{2,i});
        average_wafer_data(i,j) = sum(sum(filtered_data{2,i}(:,29:33),2)./5)/height(filtered_data{2,i});
    end
end


















