function [ dataVec2 ] = filter1(cutoff,order,fs,dataVec)
%This script simplifies the filtering of the slosh data vectors
    %15-30 is generally a good cutoff frequency
    %7-9 is generally a good order
    %dataVec needs to be detrended and only the part being filtered, e.g.
    %force(start_pt:end_pt); 

    Wst=cutoff/(fs/2); %Wst*(fs/2) = stopband freq. passband freq is about 1.5X lower
    [z,p,k] = cheby2(order,50,Wst);   
    %sos = zp2sos(z,p,k);
    %fvtool(sos,'Analysis','freq')
    [b,a]=zp2tf(z,p,k);

    dataVec2 = filtfilt(b,a,dataVec);

end

