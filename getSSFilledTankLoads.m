function ssFilledTankLoads = getSSFilledTankLoads(filledTankLoads, freq, sr)
[locsFilled,~] = findPeaks(filledTankLoads, freq, sr, false);
ssFilledTankLoads = filledTankLoads(:,locsFilled{1,1}(1):locsFilled{1,1}(end));
end