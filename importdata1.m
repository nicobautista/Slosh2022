function [Ftable] = importdata1(filename)
%This function imports csv data from the slosh labview program

delimiter = ',';
startRow = 8;
% endRow = inf;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
Ftable = table(dataArray{1:end-1}, 'VariableNames', {'time','Fx1','Fy1','Fz1','Fx2','Fy2','Fz2','Fx3','Fy3','Fz3','Baffle1','Baffle2','Baffle3','Baffle4','Baffle5','Baffle6','PositionSensor','Accelerometer','PressureTransducer','Fx','Fy','Fz','Tx','Ty','Tz','CalibrationSensor1','CalibrationSensor2'});
end

