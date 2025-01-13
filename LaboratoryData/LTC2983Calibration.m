% ---------------------------------------------------------------------- %
% 
% 
% LTC2983 collector calibration code - version 1.0
% lab environment/TPC Algorithm
% 
%                                      CharlesYu (http://www.Lhy1997.com)
% ---------------------------------------------------------------------- %

% Root directory of Res TPC data.
% file_path = "D:\EDProgram\MatlabForHeater\LaboratoryTemperatureData" + ...
%     "\TPC_Data_1\Calibration_TPC_Data_1.xlsx";
file_path = "LTC2983CalibrationData\00001_AlphaVersion\Calibration_TPC_Data_1.xlsx";
% Raw data
raw_data = readtable(file_path, "VariableNamingRule","preserve");
% Average data
average_data = mean(raw_data{:, :},'omitnan');
% Split data
collect_data = [average_data(1:7); average_data(8:14)];
calibration_data = [0, 0, 0, 0, 0, 0, 0; ...
                    266.351,266.351,266.351,266.351,266.351,266.351,266.351,];

[coecos, coecos_string] = TwoPointCalibration(collect_data, calibration_data);

disp(0*coecos(1,1) + coecos(2,1));