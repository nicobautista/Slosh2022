function [peaksIdx, peaksValues] = findPeaks(ftArray,thFreq,sr,plotCycles)
for ul = 1:2 %First upper then lower
	if ul == 2
		ftArray = -1*ftArray;
	end
	for i = 1:size(ftArray,1)
		[pks,~]=findpeaks(ftArray(i,:),'MinPeakHeight',0);
		[peaksValues{ul,i},peaksIdx{ul,i}]=findpeaks(ftArray(i,:),'MinPeakHeight',0.85*mean(pks),'MinPeakDistance',0.85*sr/thFreq,'MinPeakProminence',0.2*(max(ftArray(i,:))-min(ftArray(i,:))));
		if ul == 2
			peaksValues{ul,i} = -1*peaksValues{ul,i};
		end
	end
% 	peaksValues = ftArray(:,peaksIdx);
	if plotCycles
		for n=1:6
			figure;
			plot(ftArray(n,:));
			hold on;
			for i=1:length(peaksIdx)
				plot(peaksIdx(i),ftArray(n,peaksIdx(i)),'r*');
			end
			yline(mean(peaksValues(n,:)));
		% 	plot(locs(1)+[0.5*(peaksIdx(end)-peaksIdx(1)),0.5*(peaksIdx(end)-peaksIdx(1))],1.1*[min(ftArray(1,:)),max(ftArray(1,:))],'g');
		% 	fprintf("dt = %g\n",(peaksIdx(end)-peaksIdx(1))/1000);
			axis padded;
		end
	end
end
end