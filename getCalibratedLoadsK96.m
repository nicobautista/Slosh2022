function ftArray = getCalibratedLoadsK96(K96, filePath, filterParams, sf)
sr = filterParams(1);
cutoff_f = filterParams(2);
filt_order = filterParams(3);
data = readtable(filePath,"DatetimeType","text","VariableNamingRule","preserve");
loads9 = sf*[data.Fx1,data.Fx2,data.Fx3,data.Fy1,data.Fy2,data.Fy3,data.Fz1,data.Fz2,data.Fz3];
fl = filter1(cutoff_f,filt_order,sr,detrend(loads9)); % Filtered Loads
ftArray = K96\fl';
end