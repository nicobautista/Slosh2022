function [timeArray,ftArray] = getCalibratedLoadsK96(K96, filePath, filterParams, sf)
sr = filterParams(1);
cutoff_f = filterParams(2);
filt_order = filterParams(3);
data = readtable(filePath,"DatetimeType","text","VariableNamingRule","preserve");
if ismember('time',data.Properties.VariableNames)
	timeArray = data.time - data.time(1);
else
	timeArray = 0:1/sr:height(data)/sr-1/sr;
loads9 = sf*[-1*data.Fx1,data.Fx2,-1*data.Fx3,-1*data.Fy1,-1*data.Fy2,-1*data.Fy3,data.Fz1,data.Fz2,data.Fz3];
fl = zeros(size(loads9));
for i = 1:min(size(fl))
	fl(:,i) = filter1(cutoff_f,filt_order,sr,detrend(detrend(loads9(:,i),1))); % Filtered Loads
end
ftArray = K96\fl';
end