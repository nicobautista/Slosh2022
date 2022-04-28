function ssFilledTankLoads = getSSFilledTankLoads(filledTankLoads, freq, sr, ssPercentage)
[idxs, ~] = findPeaks(filledTankLoads, freq, sr, false);
startIdx = idxs{1,1}(1);
endIdx = idxs{1,1}(end);
cyclesDuration = endIdx-startIdx;
ssStart = startIdx+ceil(0.5*0.01*(100-ssPercentage)*cyclesDuration);
ssEnd = endIdx-floor(0.5*0.01*(100-ssPercentage)*cyclesDuration);
filledTankLoads = filledTankLoads(:,ssStart:ssEnd); %Loads with liquid
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