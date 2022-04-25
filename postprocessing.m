% Post-processing:
close all;clear;clc;
percentageToPlot = 10;
ssPercentage = 85;
logParamsBool = true;
plotBoolSystem = false; %Wether to create a window showing the plot
saveBoolSystem = false; %Whether to save the plot to storage
loadsToPlotSystem = 1:6;
plotBoolSlosh = false; %Wether to create a window showing the plot
saveBoolSlosh = false; %Whether to save the plot to storage
loadsToPlotSlosh = 1:6;
plotBoolAcc = false; %Wether to create a window showing the plot
saveBoolAcc = false; %Whether to save the plot to storage
loadsToPlotCombined = 1:6;
plotBoolCombined = false; %Wether to create a window showing the plot
saveBoolCombined = true; %Whether to save the plot to storage
sr = 1000; % Sample rate [Hz]
cutoff_f = 15; % Cutoff Frequency [Hz]
filt_order = 5; % Order of the Filter
K96 = load("K96.mat").K96;
K66inv = load("K66inv.mat").K66inv;
fileNamesCell = readcell("./Filenames.xlsx");
empty_files_path = "./EmptyTankFiles/";
pos_files_path = "./Position/";
ma = [0.7874,0;-0.635,-0.7112;-0.635,0.7112]; % Moment Arms
cyclesPerFreq = [0.1,0.5,1:10;60,100,100,60*(2:10)];
filterParams = [sr,cutoff_f,filt_order];
grayTestNumbers = [61,62,103,104,109:115];
% ----------------------
for n = 30:298
	if n == 30 || n == 226 || n == 267
		filterParams(2) = 35;
	else
		filterParams(2) = 15;
	end
	if ~ismember(n,grayTestNumbers)
		testName = sprintf("test%d",n);
		[thFreq, thAcc, thDoubleAmp, thFill] = getThFreqAccDoubleAmpFill(testName, fileNamesCell, logParamsBool);
		[tVectorPos, posVector] = getPositionData(sprintf("%s%s.txt",pos_files_path,testName));
		csv_file_name = sprintf("./Slosh_Data/%s.csv",testName);
		[tStamps, ftArray] = getCalibratedLoadsK96(K96, csv_file_name, filterParams, 1);
% 		[tStamps, ftArray] = getCalibratedLoadsK66(K66inv, csv_file_name, filterParams, 1);
% 		createFTplots(tStamps,ftArray(loadsToPlotSystem,:),sr,percentageToPlot,n,"System",loadsToPlotSystem,plotBoolSystem,saveBoolSystem,'k',"");
		empty_file = sprintf("%s%gg-%gHz.csv",empty_files_path,thAcc,thFreq);
		[idxs, ~] = findPeaks(ftArray, thFreq, sr, false);
		startIdx = idxs{1,1}(1);
		endIdx = idxs{1,1}(end);
		cyclesDuration = endIdx-startIdx;
		ssStart = startIdx+ceil(0.5*0.01*(100-ssPercentage)*cyclesDuration);
		ssEnd = endIdx-floor(0.5*0.01*(100-ssPercentage)*cyclesDuration);
		filledTankLoads = ftArray(:,ssStart:ssEnd); %Loads with liquid
		ssLoads = getSSFilledTankLoads(filledTankLoads, thFreq, sr);
		[maxAmpls, minAmpls,rawEmptyCycles] = getEmptyCyclesAmplitudes(K96,thFreq,empty_file,filterParams);
		ssEmptyTankLoads = getEmptyTankLoads(maxAmpls,minAmpls,thFreq,sr,tStamps(end));
		fprintf("Empty Tank Single Amplitude Cutoff %d Hz: Actual = %.2f N | Expected = %.2f N\n",cutoff_f,(maxAmpls(1)-minAmpls(1))/2,thAcc*9.81*170);
		[reshapedData, startIdxTrimmed, endIdxTrimmed] = reshapeEmptyData(ssEmptyTankLoads, ssLoads, thFreq, sr); %Empty Loads
		tStampsTrimmed = tStamps(startIdxTrimmed:endIdxTrimmed);
		sloshResults = ssLoads-reshapedData;
% 		createFTplots(tStampsTrimmed,sloshResults(loadsToPlotSlosh,:),sr,percentageToPlot,n,"Slosh",loadsToPlotSlosh,plotBoolSlosh,saveBoolSlosh,'b',"");
% 		createFTplots(tStampsTrimmed,cat(3,ssLoads(loadsToPlotCombined,:),sloshResults(loadsToPlotCombined,:),reshapedData(loadsToPlotCombined,:)),sr,percentageToPlot,n,"AllLoads",loadsToPlotCombined,plotBoolCombined,saveBoolCombined,['g','b','k'],["Total Loads","Liquid Loads","Empty Tank Loads"]);
		filtered_acc = processAcceleration(csv_file_name,filterParams,n,plotBoolAcc,saveBoolAcc);
		createReportPlots(tVectorPos, posVector, tStamps(startIdx:endIdx), ssLoads, tStampsTrimmed, ssLoads, reshapedData, testName, thFill, thAcc, thFreq);
	end
end