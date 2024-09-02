% Batch read all files data in the folder. the format of filename and
% data in file is as follows: 
% 
% Exp. filename: temp_%set temperature%_%generation date%_%Code Version%_.txt
% Exp. data format:
% % P1 P2 P3 P4 P5 P6 P7 P1_Kp P1_Ki P1_Kd ... ... ... ... ... ... headname
% % 150.32 149.97 ... ... ... ... ... ... ... ... ... ... ... ... ... data
% % ..... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... data
% % ..... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... data
% % ..... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... data

clear;  % clear workspace

STEADY_STATE_NUMBER = int32(1500);

% Define some status variables.
enum_way_to_draw = struct ( ...     % The way to draw line charts
    DRAW_OFF = 0, ...
    DRAW_BY_DATE = 1, ...                 % Draw the basic line charts
    DRAW_WITH_ONE_FILE = 2 ...
    ...
    ...
    );

enum_fit_norm_status = struct ( ... % If fit the tempdata to a normal distribution
    FIT_NORM_ON = 1 , ...
    FIT_NORM_OFF = 2  ...
    ...
    ...
    );


% Now get all the data and define variables.

% File information
FOLDERPATH = "D:\EDProgram\MatlabForHeater\HotPlateSensorsData\";       % Folder path
FILES = dir(FOLDERPATH);                            % Files information of struct
FILES = FILES(~[FILES.isdir]);                      % Get the real number of files
FILES_NUM = length(FILES);                           % The number of files

% Data cell
datacell = cell(1, FILES_NUM);                       % Cell for saving raw data
xaxiscell = cell(1, FILES_NUM);                      % Cell for saving length of X-axis
namestr = strings([1, FILES_NUM]);                   % Strings for saving the file ID (date).
ssdatacell = cell(1, FILES_NUM);                     % Cell for saving data under steady state

% Statistical data of temperature, such as average, standard deviation, 
% maximum, minimum. Format is as follow:
% statisticaldata{1, i}(1, j) - average
% statisticaldata{1, i}(2, j) - standard deviation
% statisticaldata{1, i}(3, j) - maximum
% statisticaldata{1, i}(4, j) - minimum
% i : file number
% p : position number
statisticaldata = cell(1, FILES_NUM);                % Cell for saving statistical data


% Read all the files in loop
for i = 1:FILES_NUM
    str = string(strsplit(FILES(i).name, '_'));
    namestr{i} = str{3};
    Filename = fullfile(FOLDERPATH, FILES(i).name);
    datacell{1, i} = readtable(Filename, "NumHeaderLines", 2);
    ssdatacell{1, i} = datacell{1, i}(STEADY_STATE_NUMBER:end, :);
    xaxiscell{1, i} = linspace(1, height(datacell{1, i}), height(datacell{1, i}));
end

% Proposed that the system enter the steady state after 1500 collections, 
% with 600ms collection interval, then the timer required to
% enter the steady state is 15mins .

% According to the conditions above, get the AVG/STD/MAX/MIN value on 
% steady state during full range.
for i = 1:1:FILES_NUM
    statisticaldata{1, i} = zeros(4, 7);
    for j = 1:1:7
        statisticaldata{1, i}(1, j) = sum(ssdatacell{1, i}{:, j})/height(ssdatacell{1, i}{:, j});
        statisticaldata{1, i}(2, j) = std(ssdatacell{1, i}{:, j});
        statisticaldata{1, i}(3, j) = max(ssdatacell{1, i}{:, j});
        statisticaldata{1, i}(4, j) = min(ssdatacell{1, i}{:, j});
    end
end




















