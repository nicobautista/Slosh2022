function createReportPlots(posT, position, acceleration, ssT, ssLoads, emptyLoads, testName, fillLevel, thAcc, thFreq)
if ~exist(sprintf("./Plots/Report/%s",testName),'dir')
	mkdir(sprintf("./Plots/Report/%s",testName));
end
yLabels = ["Position [m] and Acceleration [g's]","Load [N]","Load [N]","Load [Nm]","Load [Nm]","Load [N]","Load [Nm]"];
legendEntries = {["Position", "Acceleration"],[],["F_y","F_z"],["T_x","T_z"],[],["Empty Tank Load","Liquid Load","Total Load"],["Empty Tank Load","Liquid Load","Total Load"]};
plotTitles = ["Position and Acceleration", "F_x Force", "F_y and F_z Forces", "T_x and T_z Torques", "T_y Torque","Liquid Force F_x","Liquid Force T_y"];
imageNames = ["position_acceleration", "fx", "fyz", "txz", "ty","three_loads_fx","three_loads_ty"];
[posIdxs,~] = findPeaks(position',thFreq,1000,false);
plotTs = {posT(posIdxs{1}(1):posIdxs{1}(end)),ssT};
if acceleration == ""
	acceleration = ((2*pi*thFreq)^2)*(1/9.81)*0.5*position(posIdxs{1}(1):posIdxs{1}(end));
plotYs = {[position(posIdxs{1}(1):posIdxs{1}(end)), acceleration],ssLoads(1,:)',ssLoads(2:3,:)',ssLoads([4,6],:)',ssLoads(5,:)',[emptyLoads(1,:)',ssLoads(1,:)'-emptyLoads(1,:)',ssLoads(1,:)'],[emptyLoads(5,:)',ssLoads(5,:)'-emptyLoads(5,:)',ssLoads(5,:)']};
for i=1:7
	pa_fig = figure('visible','off','OuterPosition',[0,0,1620,900]);
	plotTitle = sprintf("%s: FL = %d%%, a = %g g's, f = %g Hz",plotTitles(i),fillLevel,thAcc,thFreq);
	if i == 1
		plotT = plotTs{1};
	else
		plotT = plotTs{2};
	end
	for j = 1:size(plotYs{i},2)
		plot(plotT, plotYs{i}(:,j),'LineWidth',0.75);
		hold on;
	end
	title(plotTitle,'FontSize',16);
	xlabel("Time [s]",'FontSize',13);
	ylabel(yLabels{i},'FontSize',13);
	if ~isempty(legendEntries{i})
		legend(legendEntries{i},'FontSize',12);
	end
	axis padded;
	exportgraphics(pa_fig,sprintf("./Plots/Report/%s/%s_%s.png",testName,testName,imageNames(i)));
	xlim([14.5,22.5]);
	exportgraphics(pa_fig,sprintf("./Plots/Report/%s/%s_%s-zoomed.png",testName,testName,imageNames(i)));
	close all;
end
end