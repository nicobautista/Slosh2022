function [maxPeaks,minPeaks,rawEmptyCycles] = getEmptyCyclesAmplitudes(K96,thFreq,emptyTest,filterParams)
sr = filterParams(1);
[~,rawEmptyCycles] = getCalibratedLoadsK96(K96, emptyTest, filterParams,1);
[~,hlPeaks] = findPeaks(rawEmptyCycles, thFreq, sr, false);
% ssStartIdx = idxs(ceil(length(idxs)/2));
% ssEndIdx = ssStartIdx + dataPtsPerCycle-1;
% dpts = ssEndIdx-ssStartIdx;
% singleCycle = Favg_arr(:,ssStartIdx:ssEndIdx);
% maxPeaks = max(Favg_arr(:,ssStartIdx:ssEndIdx+3*dpts),[],2);
% minPeaks = min(Favg_arr(:,ssStartIdx:ssEndIdx+3*dpts),[],2);
maxPeaks = zeros(1,size(hlPeaks,2));
minPeaks = zeros(1,size(hlPeaks,2));
for i=1:size(hlPeaks,2)
	maxPeaks(i) = mean(hlPeaks{1,i});
	minPeaks(i) = mean(hlPeaks{2,i});
end
end