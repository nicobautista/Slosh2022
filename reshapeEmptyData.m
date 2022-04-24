function [reshapedData, startIdx, endIdx] = reshapeEmptyData(emptyData, filledData, thFreq, sr)
for i=1:size(emptyData,1)
	[locsEmpty,~] = findPeaks(emptyData(i,:),thFreq,sr,false);
% 	if i == 3 || i == 6
% 		highOrLow = 2;
% 	else
% 		highOrLow = 1;
% 	end
	highOrLow = 1;
% 	if i ~= 1 && i ~= 3
% 		highOrLow = 2;
% 	end
	startIdx = locsEmpty{highOrLow}(1);
	endIdx = locsEmpty{highOrLow}(1)+length(filledData)-1;
	if i==1
		reshapedData = zeros(size(emptyData,1),endIdx-startIdx+1);
	end
	reshapedData(i,:) = emptyData(i,startIdx:endIdx);
end
end