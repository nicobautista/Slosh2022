function ssFilledTankLoads = getSSFilledTankLoads(filledTankLoads, freq, sr)
[locsFilled,~] = findPeaks(filledTankLoads, freq, sr, false);
p2pDataPts = zeros(1,size(filledTankLoads,1));
for i=1:size(filledTankLoads,1)
	p2pDataPts(i) = locsFilled{1,i}(end)-locsFilled{1,i}(1);
end
sizeOfInterest = min(p2pDataPts);
ssFilledTankLoads = zeros(size(filledTankLoads,1),sizeOfInterest);
for i=1:size(filledTankLoads,1)
	ssFilledTankLoads(i,:) = detrend(filledTankLoads(i,locsFilled{1,i}(1):locsFilled{1,i}(1)+sizeOfInterest-1));
end
% ssFilledTankLoads = detrend(ssFilledTankLoads);
end