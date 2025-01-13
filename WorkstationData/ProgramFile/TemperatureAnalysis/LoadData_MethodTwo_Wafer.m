% Batch read all files data in the WaferSensorsData folder. The layout 
% format of the data has been determined, so just read the file with the
% format. 



WAFER_STEADY_STATE_NUMBER = int32(1500);

% Define some status variables.
enum_way_to_draw_wafer = struct ( ...   % The way to draw line charts
    DRAW_OFF = 0, ...               % Do not run the line chart code
    DRAW_BY_POSITION = 1, ...       % Draw a basic line charts
    DRAW_WITH_ONE_FILE = 2, ...
    DRAW_WITH_ONE_FILE_IN_3D = 3 ...      % Draw a line charts of single file
    ...
    );


% Get all the data and define variables.

% File information
WF_FOLDERPATH = "D:\EDProgram\MatlabForHeater\WaferSensorsData\";
WF_FILES = dir(WF_FOLDERPATH);
WF_FILES = WF_FILES(~[WF_FILES.isdir]);
WF_FILES_NUM = length(WF_FILES);

% Data variables
wf_raw_datacell = cell(1, WF_FILES_NUM);
wf_datacell = cell(1, WF_FILES_NUM);
wf_xaxiscell = cell(1, WF_FILES_NUM);
wf_ssxaxiscell = cell(1, WF_FILES_NUM);
wf_ssdatacell = cell(1, WF_FILES_NUM);
wf_namestr = strings([1, WF_FILES_NUM]);
wf_statisticaldata = cell(1, WF_FILES_NUM);




% Read all the files in loop to get the data we need.
for i = 1:1:WF_FILES_NUM
    str = string(strsplit(WF_FILES(i).name, '_'));
    wf_namestr{i} = [str{1}, str{3}];
    FILENAME = fullfile(WF_FOLDERPATH, WF_FILES(i).name);
    wf_raw_datacell{1, i} = readtable(FILENAME, "NumHeaderLines", 1);
    wf_datacell{1, i} = wf_raw_datacell{1, i}(:,3:end);
    wf_ssdatacell{1, i} = wf_datacell{1, i}(WAFER_STEADY_STATE_NUMBER:end, :);
    wf_xaxiscell{1, i} = linspace(1, height(wf_datacell{1, i}), height(wf_datacell{1, i}));
    wf_ssxaxiscell{1, i} = linspace(1, height(wf_ssdatacell{1, i}), height(wf_ssdatacell{1, i}));
end


% Statistical data of temperature, such as average, standard deviation, 
% maximum, minimum. Format is as follow:
% statisticaldata{1, i}(1, j) - average
% statisticaldata{1, i}(2, j) - maximum
% statisticaldata{1, i}(3, j) - minimum
% statisticaldata{1, i}(4, j) - range
% statisticaldata{1, i}(5, j) - standard deviation
% statisticaldata{1, i}(6, j) - avg + 3sigma
% statisticaldata{1, i}(7, j) - avg - 3sigma
% statisticaldata{1, i}(8, j) - range with 6sigma
for i = 1:1:WF_FILES_NUM
    wf_statisticaldata{1 ,i} = zeros(8, 34);
    for j = 1:1:34
        wf_statisticaldata{1, i}(1, j) = sum(table2array(wf_ssdatacell{1, i}(:, j)))/height(table2array(wf_ssdatacell{1, i}(:, j)));
        wf_statisticaldata{1, i}(2, j) = max(table2array(wf_ssdatacell{1, i}(:, j)));
        wf_statisticaldata{1, i}(3, j) = min(table2array(wf_ssdatacell{1, i}(:, j)));
        wf_statisticaldata{1, i}(4, j) = max(table2array(wf_ssdatacell{1, i}(:, j))) - min(table2array(wf_ssdatacell{1, i}(:, j)));
        wf_statisticaldata{1, i}(5, j) = std(table2array(wf_ssdatacell{1, i}(:, j)));
        wf_statisticaldata{1, i}(6, j) = wf_statisticaldata{1, i}(1, j) + 3 * std(table2array(wf_ssdatacell{1, i}(:, j)));
        wf_statisticaldata{1, i}(7, j) = wf_statisticaldata{1, i}(1, j) - 3 * std(table2array(wf_ssdatacell{1, i}(:, j)));
        wf_statisticaldata{1, i}(8, j) = 6 * std(table2array(wf_ssdatacell{1, i}(:, j)));
    end
end


































