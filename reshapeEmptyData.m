function reshapedData = reshapeEmptyData(emptyData, fullData, thFreq, sr)
locsFull = findStartEndCycles(fullData,thFreq,sr,false);
sizeDiff = length(emptyData)-length(fullData);
reshapedData = [emptyData(:,end-locsFull(1)+2:end),emptyData(:,1:end-locsFull(1)-sizeDiff+1)];
end