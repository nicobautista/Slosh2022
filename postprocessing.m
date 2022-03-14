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
loadsToPlotSlosh = [1,5];
sr = 1000; % Sample rate [Hz]
cutoff_f = 15; % Cutoff Frequency [Hz]
filt_order = 5; % Order of the Filter
K96 = load("K96.mat").K96;
fileNamesCell = readcell("./Filenames.xlsx");
empty_files_path = "./EmptyTankFiles/";
ma = [0.7874,0;-0.635,-0.7112;-0.635,0.7112]; % Moment Arms
cyclesPerFreq = [0.1,0.5,1:10;60,100,100,60*(2:10)];
filterParams = [sr,cutoff_f,filt_order];
grayTestNumbers = [61,62,103,104,109:115];
% ----------------------
for n = 248:250
	if ~ismember(n,grayTestNumbers)
		testName = sprintf("test%d",n);
		csv_file_name = sprintf("./Slosh_Data/%s.csv",testName);
		data = readtable(csv_file_name,"VariableNamingRule","preserve");
	% 	s_sensors = [data{:,end-1:end}]; %Not used for anything atm
		ftArray = getCalibratedLoadsK96(K96, csv_file_name, filterParams, 1);
		createFTplots(ftArray,sr,percentageToPlot,n,"System",loadsToPlotSystem,plotBoolSystem,saveBoolSystem);
		[thFreq, thAcc, thDoubleAmp, thFill] = getThFreqAccDoubleAmpFill(testName, fileNamesCell, logParamsBool);
		empty_file = sprintf("%s%gg-%gHz.csv",empty_files_path,thAcc,thFreq);
		idxs = findStartEndCycles(ftArray, thFreq, sr, false);
		startIdx = idxs(1);
		endIdx = idxs(end);
		cyclesDuration = endIdx-startIdx;
		ssStart = startIdx+ceil(0.5*0.01*(100-ssPercentage)*cyclesDuration);
		ssEnd = endIdx-floor(0.5*0.01*(100-ssPercentage)*cyclesDuration);
		ssLoads = ftArray(:,ssStart:ssEnd); %Loads with liquid
	% 	freq = FFT_natfreq(ssLoads(1,:),sr); %Measured Frequency - Not used for anything atm
		% nb_cycl = cyclesPerFreq(2,cyclesPerFreq(1,:)==thFreq); %Number of cycles for each test
		singleCycleDuration = sr/thFreq; % # of data pts
		singleEmptyCycle = getSingleEmptyTankCycle(K96,singleCycleDuration,thFreq,empty_file,filterParams);
		ssEmptyTankLoads = repmat(singleEmptyCycle,1,1+ceil(length(ssLoads)/singleCycleDuration));
		reshapedData = reshapeEmptyData(ssEmptyTankLoads, ssLoads, thFreq, sr); %Empty Loads
		sloshResults = ssLoads-reshapedData;
		createFTplots(sloshResults,sr,percentageToPlot,n,"Slosh",loadsToPlotSlosh,plotBoolSlosh,saveBoolSlosh);
	end
end