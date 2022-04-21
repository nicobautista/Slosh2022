function createFTplots(tArray,ftArray,sr,percentageToPlot,testN,testType,loadsToPlot,plotBool,saveBool,plotColor,legendStrings,fillAccFreq)
dataSize = length(ftArray);
titles = ["Fx","Fy","Fz","Tx","Ty","Tz"];
units = ["N","N","N","Nm","Nm","Nm"];
if plotBool
	figure('OuterPosition',[0,0,1350,900]);
elseif saveBool
	figure('visible','off','OuterPosition',[0,0,1350,900]);
end
if plotBool || saveBool
	tl = tiledlayout('flow');
	if size(ftArray,3) == 1
		title(tl, sprintf("%s Loads: test%d",testType,testN),'FontSize',20);
	else
		title(tl, sprintf("Loads: test%d",testN),'FontSize',20);
	end
	for i=1:size(ftArray,1)
		nexttile;
		for n=1:size(ftArray,3)
			plot(tArray,ftArray(i,:,n),plotColor(n),'DisplayName',legendStrings(n));
			hold on;
			axis padded;
		end
		hold off;
		title(titles(loadsToPlot(i)));
		ylabel(sprintf("Load [%s]",units(loadsToPlot(i))));
		xlabel("Time [s]");
		xlim(1/sr*[dataSize/2-percentageToPlot/200*dataSize,dataSize/2+percentageToPlot/200*dataSize]);
		if legendStrings ~= ""
			legend show;
		end
	end
	tl.TileSpacing = 'tight';
	tl.Padding = 'compact';
	if saveBool
		exportgraphics(tl,sprintf("./Plots/test%d-%s_forces.jpeg",testN,testType));
		close all;
	end
end
end