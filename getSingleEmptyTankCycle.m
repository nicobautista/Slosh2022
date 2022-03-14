function [singleCycle] = getSingleEmptyTankCycle(K96,dataPtsPerCycle,thFreq,emptyTest,filterParams)
sr = filterParams(1);
Favg_arr = getCalibratedLoadsK96(K96, emptyTest, filterParams,1);
idxs = findStartEndCycles(Favg_arr, thFreq, sr, false);
ssStartIdx = idxs(ceil(length(idxs)/2));
ssEndIdx = ssStartIdx + dataPtsPerCycle-1;
singleCycle = Favg_arr(:,ssStartIdx:ssEndIdx);
end