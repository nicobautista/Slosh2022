function [natfreq,resolutionf] = FFT_natfreq(force3,fs)
%This function returns the primary frequency of a waveform.
	%FFT:
	m=1E6; %forces fft to pad a ton of 0's, increasing the resolution of the peak
	n=pow2(nextpow2(m));
	dftf=fft(force3,n);
	frange=(0:n-1)*(fs/n);
	resolutionf=frange(2)-frange(1);
	frange2=0:resolutionf:10; % Only care about 0-10Hz range
	power_dftf=dftf.*conj(dftf)/n;
	power_dftf2=power_dftf(1:length(frange2));
	%find peak:
	[~,imaxP]=max(power_dftf2);
	natfreq=frange(imaxP);
end

