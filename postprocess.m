% Post-processing:
close all;clear;clc;
sr=1000; %sample rate Hz
cutoff_f = 15;
filt_order = 5;
% csv_file_name = "./Sample_Slosh_Data/test248.csv";
csv_file_name = "C:/Users/nicob/Downloads/je/test250.csv";
titles = ["Fx","Fy","Fz","Tx","Ty","Tz"];
units = ["N","N","N","Nm","Nm","Nm"];
data = readtable(csv_file_name,"VariableNamingRule","preserve");
forces9 = [data.Fx1,data.Fx2,data.Fx3,data.Fy1,data.Fy2,data.Fy3,data.Fz1,data.Fz2,data.Fz3];
fl = filter1(cutoff_f,filt_order,sr,detrend(forces9)); %filtered_loads (fl)
s_sensors = [data{:,end-1:end}];
ma=[0.7874,0;-0.635,-0.7112;-0.635,0.7112]; %moment_arms (ma)
dataSize = length(forces9);
tArray = linspace(0,length(forces9)/sr,length(forces9));
percentageToPlot = 10;
%% Using K66
K66inv = load("K66inv.mat").K66inv;
v_F_x = fl(:,1) + fl(:,2) + fl(:,3);
v_F_y = fl(:,4) + fl(:,5) + fl(:,6);
v_F_z = fl(:,7) + fl(:,8) + fl(:,9);
v_T_x = fl(:,9) - fl(:,8);
v_T_y = (fl(:,8) + fl(:,9))*abs(ma(3,1))/abs(ma(1,1)) - fl(:,7);
v_T_z = (fl(:,2)-fl(:,3))*abs(ma(3,2))/abs(ma(1,1)) - fl(:,4) - (fl(:,5)+fl(:,6))*abs(ma(3,1))/abs(ma(1,1));
FT1=K66inv*[v_F_x,v_F_y,v_F_z,v_T_x,v_T_y,v_T_z]';
figure;
title("K66");
tl = tiledlayout('flow');
for i=1:6
	nexttile;
	plot(tArray,(FT1(i,:)-FT1(i,1)));
	title(sprintf("%s - K66",titles(i)));
	ylabel(sprintf("Load [%s]",units(i)));
	xlabel("Time [s]");
	xlim(1/sr*[dataSize/2-percentageToPlot/200*dataSize,dataSize/2+percentageToPlot/200*dataSize]);
end
tl.TileSpacing = 'tight';
tl.Padding = 'compact';
%% Using K96
K96 = load("K96.mat").K96;
forces = K96\fl';
figure;
title("K96");
tl = tiledlayout('flow');
for i=1:6
	nexttile;
	plot(tArray,forces(i,:)-forces(i,1));
	title(sprintf("%s - K96",titles(i)));
	ylabel(sprintf("Load [%s]",units(i)));
	xlabel("Time [s]");
	xlim(1/sr*[dataSize/2-percentageToPlot/200*dataSize,dataSize/2+percentageToPlot/200*dataSize]);
end
tl.TileSpacing = 'tight';
tl.Padding = 'compact';