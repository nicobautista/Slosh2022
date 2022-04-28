function filtered_a = processAcceleration(csv_file_path,filterParams,testN,plotBool,saveBool)
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