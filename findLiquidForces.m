function [] = findLiquidForces(fileName, fileNamesCell, uncalibratedLoads)
% ft_xyz: 6 column vector with forces and torques of the system
sr = 1000;
[thFreq, thAcc, thDoubleAmp, thFill] = getThFreqAccDoubleAmpFill(fileName, fileNamesCell);
cyclesPerFreq = [60,100,100,60*(2:10)];
freq = FFT_natfreq(posvecf,sr);
empty_files_path = "./EmptyFiles/";
empty_file = sprintf("%s%gg-%gHz.csv",empty_files_path,thAcc,thFreq);
FrequencyShift(freq,empty_file,sr);
% t0 = FindSteadyState(posvecf,Amplitude,freq,sr);
end