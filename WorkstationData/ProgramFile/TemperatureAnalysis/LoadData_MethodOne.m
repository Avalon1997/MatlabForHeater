% 批量读取文件夹内文件数据, 提供所有绘图所需要的参数
clear;

% ----- 定义结构体变量，替代枚举类型
% 绘图方式
way = struct ( ...
    'CertainFileDifferentFigureDifferentPointOneAxesWithAV', 1, ...
    'CertainFileOneFigureOnePointDifferentAxesWithAVWith90OA', 2, ...
    'CertainFileOneFigureOnePointOneAxesWithAVWith80OA', 3, ...
    'CertainFileOneFigureOnePointOneAxesWithAVWith90OA', 4, ...
    'CertainFileOneFigureDifferentPointOneAxesWithAVWith90OA', 5 ...
    );
% 是否绘制PID参数比较图
PIC_p_c_status = struct ( ...
    'PIDParametersComparesOn', 1, ...
    'PIDParametersComparesOff', 2 ...
    );
% 是否拟合正态分布
Fit_norm_status = struct ( ...
    'FitNormOn', 1, ...
    'FitNormOff', 2 ...
    );
% -----


% 获取所有绘图所用的资源数据
% Folder = "E:/MatlabWorkStation/Compare/";  % 文件夹路径
Folder = "D:\EDProgram\MatlabForHeater\Compare\";
Files = dir(Folder);                        % 获取文件夹路径下文件，结构体类型
Files = Files(~[Files.isdir]);              % 去掉本身和父文件夹，剩余的即为文件个数
FilesNum = length(Files);                   % 获取文件个数
DataCell = cell(4,FilesNum);                % 创建文件数据存储元胞
XCell = cell(1,FilesNum);                   % 创建 X 轴长度存储元胞=   
namestr = strings([1, FilesNum]);           % 字典 key 值字符串缓存数组
pidcell = cell(1,FilesNum);                 % 字典 values 值缓存元胞
pidbuff = strings([7, 3]);                  % 预设 PID 参数字符串缓存数组    
TableColumnNames = {'pt1','pt2','pt3','pt4','pt5','pt6','pt7',...               % table 表名
                    'pst1','pst2','pst3','pst4','pst5','pst6','pst7',...        
                    'pp1','pp2','pp3','pp4','pp5','pp6','pp7'};  

% 轮询文件夹下所有文件
for i = 1:FilesNum
    str = string(strsplit(Files(i).name,'_'));
    %提取单个文件中七个点的 PID 参数
    for p_i = 1:7
        for p_j = 3:-1:1
            pidbuff(p_i,(4 - p_j)) = str(p_i*3 - p_j + 2);
        end
    end
    % 获取文件路径，读取文件中数据，重命名 table 表头
    Filename = fullfile(Folder, Files(i).name);
    DataCell{1, i} = readtable(Filename);
    DataCell{1, i}.Properties.VariableNames = TableColumnNames;
    % 获取 X 轴数据绘制长度
    XCell{i} = linspace(1,height(DataCell{1, i}),height(DataCell{1, i}));
    % 获取创建字典所需要的 keys 和 values
    namestr{i} = str{1};
    pidcell{i} = pidbuff;
end

piddic = dictionary(namestr,pidcell);       % 创建 PID 参数字典

% 拟定稳态为 1500 个采样之后，平均 600ms 采样一次，可得进入稳态的时间为：15分钟。
% 计算稳点稳态后的最大/最小值
for i = 1:1:FilesNum
    DataCell{2, i} = zeros(7, 2);
    for j = 1:1:7
        DataCell{2, i}(j, 1) = max(DataCell{1, i}{1500:end, j});
        DataCell{2, i}(j, 2) = min(DataCell{1, i}{1500:end, j});
    end
end

% 排序稳态后的温度值，从均值点开始向上向下分别取总数的40%，并计算这80%的温度点的最大最小值。
for i = 1:1:FilesNum
    DataCell{3, i} = zeros(7, 2);
    for j = 1:1:7
        buffer = sortrows(DataCell{1, i}{1500:end,j},1,"ascend");
        buffer = buffer(floor((length(buffer) - length(buffer)*0.8)/2):floor((length(buffer) + floor(length(buffer)*0.8))/2),1);
        DataCell{3, i}(j, 1) = max(buffer);
        DataCell{3, i}(j, 2) = min(buffer);
    end
end

% 排序稳态后的温度值，从均值点开始向上向下分别取总数的45%，并计算这90%的温度点的最大最小值。
for i = 1:1:FilesNum
    DataCell{4, i} = zeros(7, 2);
    for j = 1:1:7
        buffer = sortrows(DataCell{1, i}{1500:end,j},1,"ascend");
        buffer = buffer(floor((length(buffer) - length(buffer)*0.9)/2):floor((length(buffer) + floor(length(buffer)*0.9))/2),1);
        DataCell{4, i}(j, 1) = max(buffer);
        DataCell{4, i}(j, 2) = min(buffer);
    end
end

% 计算稳态的实际中心温度值(平均温度值）
SSDataCell = cell(1, FilesNum);
for i = 1:1:FilesNum % 获取稳态时的温度数据（截取原始数据500以后的值）
    SSDataCell{i} = DataCell{1, i}(1500:end,:);
end
CenterValue = zeros(FilesNum, 7);
for i = 1:1:7
    for j = 1:1:FilesNum
        CenterValue(j, i) = ...
        sum(table2array(SSDataCell{j}(:,i)) - table2array(SSDataCell{j}(:,i+7)))...
        /height(SSDataCell{j}) + 150;
    end
end
