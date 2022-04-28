function [maxPeaks,minPeaks,emptyLoads] = getEmptyCyclesAmplitudes(K96,thFreq,emptyTest,filterParams)
sr = filterParams(1);
[~,emptyLoads,~] = getCalibratedLoadsK96(K96, emptyTest, filterParams,1);
% [~,emptyLoads] = getCalibratedLoadsK66(K96, emptyTest, filterParams,1);
for i = 1:2
	if i == 1
		[hlIdxs,hlPeaks] = findPeaks(emptyLoads, thFreq, sr, false);
		startEnd = zeros(2,size(hlIdxs,2)-1);
		for j = 1:size(hlIdxs,2)
			if j ~= 6 && size(hlIdxs{2,j},2) ~= 0 && size(hlIdxs{1,j},2) ~= 0
				startEnd(1,j) = min(hlIdxs{1,j}(1),hlIdxs{2,j}(1));
				startEnd(2,j) = max(hlIdxs{1,j}(end),hlIdxs{2,j}(end));
			elseif size(hlIdxs{2,j},2) == 0
				startEnd(1,j) = hlIdxs{1,j}(1);
				startEnd(2,j) = hlIdxs{1,j}(end);
			elseif size(hlIdxs{1,j},2) == 0
				startEnd(1,j) = hlIdxs{2,j}(1);
				startEnd(2,j) = hlIdxs{2,j}(end);
			end
		end
		startIdx = min(startEnd(1,:));
		endIdx = max(startEnd(2,:));
		dataLength = endIdx-startIdx;
	else
		hlPeaks = cell(2,size(emptyLoads,1));
		for j = 1:size(emptyLoads,1)
			[~,hlPeaks(:,j)] = findPeaks(detrend(detrend(emptyLoads(j,ceil(startIdx+0.1*dataLength):floor(endIdx-0.1*dataLength))),1), thFreq, sr, false);
		end
	end
end
maxPeaks = zeros(1,size(hlPeaks,2));
minPeaks = zeros(1,size(hlPeaks,2));
for i=1:size(hlPeaks,2)
	maxPeaks(i) = mean(hlPeaks{1,i});
	minPeaks(i) = mean(hlPeaks{2,i});
end
end