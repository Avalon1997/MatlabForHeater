% --------------------------------------------------
% 
%               两点校正法数据预载入 第一版
% 
% --------------------------------------------------



% 读取文件中数据
folder = "D:/EDProgram/MatlabForHeater/TempClibrationData/TwoPointCalibrationData";
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
% for i = 1:1:fix(files_num/2)
%     if (height(rawdata{2, i}) < height(rawdata{1, i}))
%         filtered_data{1, i} = table2array(rawdata{1, i}(end - height(rawdata{2, i}) + 1:end, 1:7));
%         filtered_data{2, i} = table2array(rawdata{2, i}(:, 3:end));
%     elseif (height(rawdata{2, i}) > height(rawdata{1, i}))
%         filtered_data{1, i} = table2array(rawdata{1, i}(:, 1:7));
%         filtered_data{2, i} = table2array(rawdata{2, i}(end - height(rawdata{1, i}) + 1:end,3:end));
%     end
% end

% 直接取定值范围
filtered_data{1, 1} = table2array(rawdata{1, 1}(end-4499:end, 1:7));
filtered_data{1, 2} = table2array(rawdata{1, 2}(end-4499:end, 1:7));
filtered_data{2, 1} = table2array(rawdata{2, 1}(end-4499:end, 3:end));
filtered_data{2, 2} = table2array(rawdata{2, 2}(end-4499:end, 3:end));


% 整合晶元数据对应热盘数据，求得二者不同温点的平均值
average_heater_data = zeros(2, 7);
average_wafer_data = zeros(2, 7);
% for i = 1:1:fix(files_num/2)
%     average_heater_data(i, :) = sum(filtered_data{1, i}(:, :))./height(filtered_data{1, i});
%     average_wafer_data(i, 1) = sum((sum(filtered_data{2, i}(:, 1), 2).*0.9) + (sum(filtered_data{2, i}(:, 2:9), 2).*0.0125))/height(filtered_data{2, i});
%     average_wafer_data(i, 2) = sum( sum(filtered_data{2, i}(:, 2), 2).*0.91 + sum(filtered_data{2, i}(:, [3 4 9]), 2).*0.03 )/height(filtered_data{2, i});
%     average_wafer_data(i, 3) = sum( sum(filtered_data{2, i}(:, 6), 2).*0.91 + sum(filtered_data{2, i}(:, [5 7 8]), 2).*0.03 )/height(filtered_data{2, i});
%     average_wafer_data(i, 4) = sum(sum(filtered_data{2, i}(:, [19 20 34]), 2).*0.3 + sum(filtered_data{2, i}(:, [10 11 18 21 33]), 2).*0.02)/height(filtered_data{2, i});
%     average_wafer_data(i, 5) = sum(sum(filtered_data{2, i}(:, [22 23 24]), 2).*0.3 + sum(filtered_data{2, i}(:, [12 13 21 25]), 2).*0.025)/height(filtered_data{2, i});
%     average_wafer_data(i, 6) = sum(sum(filtered_data{2, i}(:, [26 27 28]), 2).*0.3 + sum(filtered_data{2, i}(:, [14 15 25 29]), 2).*0.025)/height(filtered_data{2, i});
%     average_wafer_data(i, 7) = sum(sum(filtered_data{2, i}(:, [30 31 32]), 2).*0.3 + sum(filtered_data{2, i}(:, [16 17 29 33]), 2).*0.025)/height(filtered_data{2, i});
% end

for i = 1:1:fix(files_num/2)
    average_heater_data(i, :) = sum(filtered_data{1, i}(:, :))./height(filtered_data{1, i});
    average_wafer_data(i, 1) = sum(filtered_data{2, i}(:, 3))/height(filtered_data{2, i}(:, 3));
    average_wafer_data(i, 2) = sum(filtered_data{2, i}(:, 12))/height(filtered_data{2, i}(:, 12));
    average_wafer_data(i, 3) = sum(filtered_data{2, i}(:, 16))/height(filtered_data{2, i}(:, 16));
    average_wafer_data(i, 4) = sum(filtered_data{2, i}(:, 21))/height(filtered_data{2, i}(:, 21));
    average_wafer_data(i, 5) = sum(filtered_data{2, i}(:, 25))/height(filtered_data{2, i}(:, 25));
    average_wafer_data(i, 6) = sum(filtered_data{2, i}(:, 29))/height(filtered_data{2, i}(:, 29));
    average_wafer_data(i, 7) = sum(filtered_data{2, i}(:, 33))/height(filtered_data{2, i}(:, 33));
end









