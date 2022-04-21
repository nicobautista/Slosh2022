function filtered_a = processAcceleration(csv_file_path,filterParams,testN,plotBool,saveBool)
sr = filterParams(1);
cutoff_f = filterParams(2);
filt_order = filterParams(3);
data = readtable(csv_file_path,"DatetimeType","text","VariableNamingRule","preserve");
if ~ismember('Accelerometer',data.Properties.VariableNames)
	filtered_a = 0;
	return
end
raw_a = data.Accelerometer;
t = data.time - data.time(1);
filtered_a = filter1(cutoff_f,filt_order,sr,detrend(raw_a));
if plotBool
	aPlot = figure;
elseif saveBool
	aPlot = figure('visible','off','Units','inches','OuterPosition',[0,0,6.5,5]);
end

if plotBool || saveBool
	plot(t,filtered_a,'k');
	title(sprintf("test%d: Acceleration (g's) vs Time (s)",testN));
	xlabel("Time (s)");
	ylabel("Acceleration (g's)");
	axis padded;
	if saveBool
		exportgraphics(aPlot,sprintf("./Plots/acceleration-test%d.jpeg",testN));
	end
end
end