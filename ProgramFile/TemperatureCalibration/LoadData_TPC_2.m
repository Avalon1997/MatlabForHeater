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





















