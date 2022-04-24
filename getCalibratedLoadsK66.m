function [timeArray,ftArray] = getCalibratedLoadsK66(K66inv, filePath, filterParams, sf)
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
	fl(:,i) = filter1(cutoff_f,filt_order,sr,detrend(loads9(:,i),1)); % Filtered Loads
end
fs1=abs([-0.7874,0,0]);
fs3=abs([0.635,-0.7112,0]);
fl6 = zeros(length(loads9),6);
fl6(:,1) = fl(:,1)+fl(:,2)+fl(:,3);
fl6(:,2) = fl(:,4)+fl(:,5)+fl(:,6);
fl6(:,3) = fl(:,7)+fl(:,8)+fl(:,9);
fl6(:,4) = fl(:,9)-fl(:,8);
fl6(:,5) = (fl(:,8)+fl(:,9))*(fs3(1)/fs1(1))-fl(:,7);
fl6(:,6) = (fl(:,2)-fl(:,3))*(fs3(2)/fs1(1))+fl(:,4)-(fl(:,5)+fl(:,6))*(fs3(1)/fs1(1));
ftArray = K66inv*fl6';
end