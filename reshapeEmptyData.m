function [reshapedData, startIdx, endIdx] = reshapeEmptyData(emptyData, filledData, thFreq, sr)
[locsEmpty,~] = findPeaks(emptyData,thFreq,sr,false);
startIdx = locsEmpty{1,1}(1);
endIdx = locsEmpty{1,1}(1)+length(filledData)-1;
reshapedData = emptyData(:,startIdx:endIdx);
end