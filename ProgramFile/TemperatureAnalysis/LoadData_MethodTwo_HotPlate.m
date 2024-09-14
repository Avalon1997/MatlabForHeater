% Batch read all files data in the HotPlateSensorsData folder. the format 
% of filename and data in file is as follows: 
% 
% Exp. filename: temp_%set temperature%_%generation date%_%Code Version%_.txt
% Exp. data format:
% % P1 P2 P3 P4 P5 P6 P7 P1_Kp P1_Ki P1_Kd ... ... ... ... ... ... headname
% % 150.32 149.97 ... ... ... ... ... ... ... ... ... ... ... ... ... data
% % ..... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... data
% % ..... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... data
% % ..... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... data

STEADY_STATE_NUMBER = int32(1500);

% Define some status variables.
enum_way_to_draw = struct ( ... % The way to draw line charts
    DRAW_OFF = 0, ...                       % Do not run the line chart code
    DRAW_BY_DATE = 1, ...                   % Draw a basic line charts on same figure different axis
    DRAW_WITH_ONE_FILE = 2, ...             % Draw a single file
    DRAW_BY_DATE_ON_ONEFIGURE = 3 ...       % Draw a basic line charts on same figure same axis
    ...
    );

enum_fit_norm_status = struct ( ... % If fit the tempdata to a normal distribution
    FIT_NORM_ON = 1 , ...
    FIT_NORM_OFF = 2  ...
    ...
    ...
    );


% Get all the data and define variables.

% File information
HP_FOLDERPATH = "D:\EDProgram\MatlabForHeater\HotPlateSensorsData\";       % Folder path
HP_FILES = dir(HP_FOLDERPATH);                            % Files information of struct
HP_FILES = HP_FILES(~[HP_FILES.isdir]);                      % Get the real number of files
HP_FILES_NUM = length(HP_FILES);                           % The number of files

% Data variables
hp_datacell = cell(1, HP_FILES_NUM);                       % Cell for saving raw data
hp_xaxiscell = cell(1, HP_FILES_NUM);                      % Cell for saving length of X-axis
hp_namestr = strings([1, HP_FILES_NUM]);                   % Strings for saving the file ID (date).
hp_ssdatacell = cell(1, HP_FILES_NUM);                     % Cell for saving data under steady state

% Statistical data of temperature, such as average, standard deviation, 
% maximum, minimum. Format is as follow:
% statisticaldata{1, i}(1, j) - average
% statisticaldata{1, i}(2, j) - standard deviation
% statisticaldata{1, i}(2, j) - standard deviation
% statisticaldata{1, i}(2, j) - standard deviation
% statisticaldata{1, i}(2, j) - standard deviation
% statisticaldata{1, i}(3, j) - maximum
% statisticaldata{1, i}(4, j) - minimum
% statisticaldata{1, i}(2, j) - standard deviation
% i : file number
% p : position number
hp_statisticaldata = cell(1, HP_FILES_NUM);                % Cell for saving statistical data


% Read all the files in loop
for i = 1:1:HP_FILES_NUM
    str = string(strsplit(HP_FILES(i).name, '_'));
    hp_namestr{i} = str{3};
    FILENAME = fullfile(HP_FOLDERPATH, HP_FILES(i).name);
    hp_datacell{1, i} = readtable(FILENAME, "NumHeaderLines", 2);
    hp_ssdatacell{1, i} = hp_datacell{1, i}(STEADY_STATE_NUMBER:end, :);
    hp_xaxiscell{1, i} = linspace(1, height(hp_datacell{1, i}), height(hp_datacell{1, i}));
end

% Proposed that the system enter the steady state after 1500 collections, 
% with 600ms collection interval, then the timer required to
% enter the steady state is 15mins .

% According to the conditions above, get the AVG/STD/MAX/MIN value on 
% steady state during full range.
for i = 1:1:HP_FILES_NUM
    hp_statisticaldata{1, i} = zeros(8, 7);
    for j = 1:1:7
        hp_statisticaldata{1, i}(1, j) = sum(hp_ssdatacell{1, i}{:, j})/height(hp_ssdatacell{1, i}{:, j});
        hp_statisticaldata{1, i}(2, j) = std(hp_ssdatacell{1, i}{:, j});
        hp_statisticaldata{1, i}(3, j) = hp_statisticaldata{1, i}(1, j) + 3 * std(hp_ssdatacell{1, i}{:, j});
        hp_statisticaldata{1, i}(4, j) = hp_statisticaldata{1, i}(1, j) - 3 * std(hp_ssdatacell{1, i}{:, j});
        hp_statisticaldata{1, i}(5, j) = 6 * std(hp_ssdatacell{1, i}{:, j});
        hp_statisticaldata{1, i}(6, j) = max(hp_ssdatacell{1, i}{:, j});
        hp_statisticaldata{1, i}(7, j) = min(hp_ssdatacell{1, i}{:, j});
        hp_statisticaldata{1, i}(8, j) = max(hp_ssdatacell{1, i}{:, j}) - min(hp_ssdatacell{1, i}{:, j});
    end
end

