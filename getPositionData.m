function [tVector, posVector] = getPositionData(filePath)
position_file=importdata(filePath);
tVector = position_file(:,1);
posVector = position_file(:,2)*(10^-3);
end