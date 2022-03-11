function createFTplots(ftArray,sr,percentageToPlot,testN,plotBool,saveBool)
dataSize = length(ftArray);
tArray = linspace(0,length(ftArray)/sr,length(ftArray));
titles = ["Fx","Fy","Fz","Tx","Ty","Tz"];
units = ["N","N","N","Nm","Nm","Nm"];
if plotBool
	figure;
else
	figure('visible','off','Units','inches','OuterPosition',[0,0,6.5,5]);
end
tl = tiledlayout(2,3,'Units','inches','OuterPosition',[0,0,6.5,3.5]);
title(tl, sprintf("Slosh Loads: test%d",testN));
for i=1:6
	nexttile;
	plot(tArray,ftArray(i,:)-ftArray(i,1));
	axis padded;
	title(titles(i));
	ylabel(sprintf("Load [%s]",units(i)));
	xlabel("Time [s]");
	xlim(1/sr*[dataSize/2-percentageToPlot/200*dataSize,dataSize/2+percentageToPlot/200*dataSize]);
end
tl.TileSpacing = 'tight';
tl.Padding = 'compact';
if saveBool
	exportgraphics(tl,sprintf("./Plots/slosh_forces-test%d.jpeg",testN))
end
end