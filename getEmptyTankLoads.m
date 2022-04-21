function emptyTankLoads = getEmptyTankLoads(maxA, minA, freq, sr, duration)
t = 0:1/sr:duration;
totalAmp = (maxA-minA)/2;
% emptyTankLoads = totalAmp*cos(2*pi*freq*t)+(maxA-totalAmp);
emptyTankLoads = zeros(length(maxA),length(t));
for i=1:length(maxA)
	emptyTankLoads(i,:) = totalAmp(i)*cos(2*pi*freq*t)+(maxA(i)-totalAmp(i));
end
end