% Post-processing:
close all;clear;clc;
testNumber = 249;
percentageToPlot = 100;
ssPercentage = 85;
plotBool = false;
logParamsBool = true;
sr = 1000; % Sample rate [Hz]
cutoff_f = 11; % Cutoff Frequency [Hz]
filt_order = 5; % Order of the Filter
filterParams = [sr,cutoff_f,filt_order];
% ----------------------
testName = sprintf("test%d",testNumber);
empty_files_path = "./EmptyTankFiles/";
csv_file_name = sprintf("./Sample_Slosh_Data/%s.csv",testName);
ma=[0.7874,0;-0.635,-0.7112;-0.635,0.7112]; % Moment Arms
titles = ["Fx","Fy","Fz","Tx","Ty","Tz"];
units = ["N","N","N","Nm","Nm","Nm"];
cyclesPerFreq = [0.1,0.5,1:10;60,100,100,60*(2:10)];
fileNamesCell = readcell("./Filenames.xlsx");
data = readtable(csv_file_name,"VariableNamingRule","preserve");
forces9 = [data.Fx1,data.Fx2,data.Fx3,data.Fy1,data.Fy2,data.Fy3,data.Fz1,data.Fz2,data.Fz3];
fl = filter1(cutoff_f,filt_order,sr,detrend(forces9)); % Filtered Loads
s_sensors = [data{:,end-1:end}];
dataSize = length(forces9);
tArray = linspace(0,length(forces9)/sr,length(forces9));
K96 = load("K96.mat").K96;
ftArray = getCalibratedLoadsK96(K96, csv_file_name, filterParams);
[thFreq, thAcc, thDoubleAmp, thFill] = getThFreqAccDoubleAmpFill(testName, fileNamesCell, logParamsBool);
empty_file = sprintf("%s%gg-%gHz.csv",empty_files_path,thAcc,thFreq);
idxs = findStartEndCycles(ftArray, thFreq, sr);
startIdx = idxs(1);
endIdx = idxs(end);
centerPeaksIdx = ceil(length(idxs)/2);
lowerPeaksIdx = centerPeaksIdx - ceil(0.85/2*length(idxs));
upperPeaksIdx = centerPeaksIdx + floor(0.85/2*length(idxs));
ssDataLength = round(length(idxs(lowerPeaksIdx):idxs(upperPeaksIdx))/1e3)*1e3;
lowerDataIdx = idxs(lowerPeaksIdx);
upperDataIdx = idxs(lowerPeaksIdx)+ssDataLength-1;
ssLoads = ftArray(:,lowerDataIdx:upperDataIdx); %Loads with liquid
freq = FFT_natfreq(ssLoads(1,:),sr);
nb_cycl = cyclesPerFreq(2,cyclesPerFreq(1,:)==thFreq);
nb_ss_cycles = upperPeaksIdx-lowerPeaksIdx;
cyclDataPts = round(ssDataLength/nb_ss_cycles);
singleEmptyCycle = getSingleEmptyTankCycle(K96,cyclDataPts,thFreq,empty_file,filterParams);
ssEmptyTankLoads = repmat(singleEmptyCycle,1,nb_ss_cycles); %Empty Loads
sloshResults = ssLoads-ssEmptyTankLoads;
createFTplots(sloshResults,sr,percentageToPlot,false);