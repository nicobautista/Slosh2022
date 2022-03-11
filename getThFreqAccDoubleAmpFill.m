function [thFreq, thAcc, thDoubleAmp, thFill] = getThFreqAccDoubleAmpFill(fileName, fileNamesCell, logParams)
for i=1:size(fileNamesCell,1)
	for j=1:size(fileNamesCell,2)
		if string(fileNamesCell{i,j}) == erase(fileName,".csv")
			thFreq = fileNamesCell{i,1};
			thAcc = fileNamesCell{2,j};
			thFill = fileNamesCell{1,j};
			thDoubleAmp = 2*thAcc*9.81/(2*pi*thFreq)^2;
			if logParams
				fprintf("%7s: Freq: %3g Hz | Acc: %6g g | Fill: %d %%\n",fileName,fileNamesCell{i,1},fileNamesCell{2,j},fileNamesCell{1,j});
			end
			return;
		end
	end
end

end