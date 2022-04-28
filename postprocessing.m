% Post-processing:
close all;clear;clc;
ssPercentage = 85;
logParamsBool = true;
sr = 1000; % Sample rate [Hz]
filt_order = 5; % Order of the Filter
K96 = load("K96.mat").K96;
K66inv = load("K66inv.mat").K66inv;
fileNamesCell = readcell("./Filenames.xlsx");
empty_files_path = "./EmptyTankFiles/";
pos_files_path = "./Position/";
ma = [0.7874,0;-0.635,-0.7112;-0.635,0.7112]; % Moment Arms
cutoffFreqs = [0.1, 0.5, 1:10;1.5, 2, 2.5, 4.8, 7, 8.5, 11, 13, 14.5, 16.5, 18.3, 20.9];
grayTestNumbers = [61,62,103,104,109:115];
% ----------------------
for n = 31
	if ~ismember(n,grayTestNumbers)
		testName = sprintf("test%d",n);
		[thFreq, thAcc, thDoubleAmp, thFill] = getThFreqAccDoubleAmpFill(testName, fileNamesCell, logParamsBool);
		cutoff_f = cutoffFreqs(2,cutoffFreqs(1,:)==thFreq);
		filterParams = [sr,cutoff_f,filt_order];
		[tVectorPos, posVector] = getPositionData(sprintf("%s%s.txt",pos_files_path,testName));
		csv_file_name = sprintf("./Slosh_Data/%s.csv",testName);
		[tStamps, ftArray, accVector] = getCalibratedLoadsK96(K96, csv_file_name, filterParams, 1);
		empty_file = sprintf("%s%gg-%gHz.csv",empty_files_path,thAcc,thFreq);
		ssLoads = getSSFilledTankLoads(ftArray, thFreq, sr, ssPercentage);
		[maxAmpls, minAmpls,rawEmptyCycles] = getEmptyCyclesAmplitudes(K96,thFreq,empty_file,filterParams);
		ssEmptyTankLoads = getEmptyTankLoads(maxAmpls,minAmpls,thFreq,sr,tStamps(end));
		fprintf("Empty Tank Single Amplitude Cutoff %d Hz: Actual = %.2f N | Expected = %.2f N\n",cutoff_f,(maxAmpls(1)-minAmpls(1))/2,thAcc*9.81*170);
		[reshapedData, startIdxTrimmed, endIdxTrimmed] = reshapeEmptyData(ssEmptyTankLoads, ssLoads, thFreq, sr); %Empty Loads
		tStampsTrimmed = tStamps(startIdxTrimmed:endIdxTrimmed);
		sloshResults = ssLoads-reshapedData;
		createReportPlots(tVectorPos, posVector, accVector, tStampsTrimmed, ssLoads, reshapedData, testName, thFill, thAcc, thFreq);
	end
end