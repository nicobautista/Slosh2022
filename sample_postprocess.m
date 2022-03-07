% Post-processing:
close all;clear;clc;
sr=1000; %sample rate Hz
cutoff_f = 15;
filt_order = 5;
% csv_file_name = "./Sample_Slosh_Data/test248.csv";
csv_file_name = "./FinalData/Fx_neg_1.csv";
titles = ["Fx","Fy","Fz","Tx","Ty","Tz"];
data = readtable(csv_file_name,"VariableNamingRule","preserve");
forces9 = [data.Fx1,data.Fx2,data.Fx3,data.Fy1,data.Fy2,data.Fy3,data.Fz1,data.Fz2,data.Fz3];
fl = filter1(cutoff_f,filt_order,sr,detrend(forces9)); %filtered_loads (fl)
s_sensors = [data{:,end-1:end}];
ma=[0.7874,0;-0.635,-0.7112;-0.635,0.7112]; %moment_arms (ma)
%% Using K66
k_matrix = load("k_matrix.mat").K66inv;
v_F_x = fl(:,1) + fl(:,2) + fl(:,3);
v_F_y = fl(:,4) + fl(:,5) + fl(:,6);
v_F_z = fl(:,7) + fl(:,8) + fl(:,9);
v_T_x = fl(:,9) - fl(:,8);
v_T_y = (fl(:,8) + fl(:,9))*abs(ma(3,1))/abs(ma(1,1)) - fl(:,7);
v_T_z = (fl(:,2)-fl(:,3))*abs(ma(3,2))/abs(ma(1,1)) - fl(:,4) - (fl(:,5)+fl(:,6))*abs(ma(3,1))/abs(ma(1,1));
FT1=k_matrix*[v_F_x,v_F_y,v_F_z,v_T_x,v_T_y,v_T_z]';
figure;
title("K66");
tiledlayout('flow');
for i=1:6
	nexttile;
	plot(FT1(i,:)-FT1(i,1));
	title(sprintf("%s - K66",titles(i)));
	ylabel("Force [N]");
end
%% Using K96
K96 = load("K96.mat").K96;
forces = K96\forces9';
figure;
title("K96");
tiledlayout('flow');
for i=1:6
	nexttile;
	plot(forces(i,:)-forces(i,1));
	title(sprintf("%s - K96",titles(i)));
	ylabel("Force [N]");
end