function reshapedData = reshapeEmptyData(emptyData, filledData, thFreq, sr)
locsFilled = findStartEndCycles(filledData,thFreq,sr,false);
sizeDiff = length(emptyData)-length(filledData);
reshapedData = [emptyData(:,end-locsFilled(1)+2:end),emptyData(:,1:end-locsFilled(1)-sizeDiff+1)];
end