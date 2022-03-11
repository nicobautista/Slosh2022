function locs = findStartEndCycles(ftArray,thFreq,sr,plotCycles)
[pks,~]=findpeaks(ftArray(1,:));
[~,locs]=findpeaks(ftArray(1,:),'MinPeakHeight',mean(pks),'MinPeakDistance',0.85*sr/thFreq,'MinPeakProminence',0.2*(max(ftArray(1,:))-min(ftArray(1,:))));
if plotCycles
	figure;
	plot(ftArray(1,:));
	hold on;
	for i=1:length(locs)
	plot([locs(i),locs(i)],1.1*[min(ftArray(1,:)),max(ftArray(1,:))],'r');
	end
	plot(locs(1)+[0.5*(locs(end)-locs(1)),0.5*(locs(end)-locs(1))],1.1*[min(ftArray(1,:)),max(ftArray(1,:))],'g');
	fprintf("dt = %g\n",(locs(end)-locs(1))/1000);
end
end