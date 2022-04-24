%% Section 1: Set parameters
close all;clear;clc;
% Parameters to change:
singleFileBool = false;
single_idx = 12;
prefixfilename='./FinalData/';
csvarray = {'Fx_pos_1.csv','Fx_neg_1.csv','Fy_pos_1.csv','Fy_neg_1.csv','Fz_pos_1.csv','Fz_neg_1.csv',...
			'Tx_pos_3.csv','Tx_neg_1.csv','Ty_pos_1.csv','Ty_neg_1.csv','Tz_pos_1.csv','Tz_neg_1.csv'};
caseflag=[1,1,1,1,1,1,1,1,1,1,1,1];
calsensorflag=[2,2,2,2,2,2,3,3,3,3,3,3];
sf=1*ones(9,12); %N/V scale factors. each column: [x1;x2;x3;y1;y2;y3;z1;z2;z3]
% No need to change the following. 
% Calibration load cell scale factors (constant)
sflc1=100; %lbf/V
sflc2=100; %lbf/V
sflc1N=sflc1*4.44822; %N/V
sflc2N=sflc1N; %N/V
calNames = {'Fx+','Fx-','Fy+','Fy-','Fz+','Fz-','Tx+','Tx-','Ty+','Ty-','Tz+','Tz-'};
if singleFileBool
	start_idx = single_idx;
	end_idx = single_idx;
else
	start_idx = 1;
	end_idx = 12;
end
%% Section 2: Read CSV files
Ftablefs = cell(1,12);
FtableCS = cell(1,12);
for kk=start_idx:end_idx
    csv_file_name = [prefixfilename,csvarray{kk}];
	Ftable = readtable(csv_file_name,"VariableNamingRule","preserve");
	Ftablefs{kk}=[-1*Ftable.Fx1,Ftable.Fx2,-1*Ftable.Fx3,-1*Ftable.Fy1,-1*Ftable.Fy2,-1*Ftable.Fy3,Ftable.Fz1,Ftable.Fz2,Ftable.Fz3];
	FtableCS{kk}=Ftable{:,end-1:end};
end
% Ftablefs has the format: [Fx1,Fx2,Fx3,Fy1,Fy2,Fy3,Fz1,Fz2,Fz3]
% FtableCS has the format: [CS1,CS2]
%% Section 3: Plot for Unknown Starting/Ending Points
% Run this only if the start/end points are unknown.
% Plot calibration sensor data in order to find indices of steps.
% Write down these indices in the start_pts and end_pts arrays (next section).
close all;
figure;
idxArray = (0:1:height(Ftable)-1);
cal_tl = tiledlayout('flow');
for kk=start_idx:end_idx
	nexttile;
	plot(Ftablefs{kk}(:,7));
	title(calNames{kk});
	xlabel("Index");
	ylabel("Force [N]");
	axis padded;
end
cal_tl.TileSpacing = 'tight';
%% Section 4: Start and End Points for All Steps
kk=1;
start_pts{kk}=[39e3,44e3,73e3,78e3,101e3,104.5e3];
end_pts{kk}=[40e3,45e3,74e3,79e3,102e3,105.5e3];
kk=2;
start_pts{kk}=[31e3,35.5e3,54e3,58e3,76e3,81e3];
end_pts{kk}=[32e3,36.5e3,55e3,58e3,77e3,82e3];
kk=3;
start_pts{kk}=[16e3,19e3,42.5e3,45.5e3,60e3,62e3];
end_pts{kk}=[17e3,20e3,43.5e3,46.5e3,60.9e3,63e3];
kk=4;
start_pts{kk}=[17e3,21e3,43.5e3,47e3,55.5e3,58.5e3];
end_pts{kk}=[18e3,22e3,44.5e3,48e3,56.5e3,59.3e3];
kk=5;
start_pts{kk}=[9e3,11e3,28e3,30e3,41e3,43e3];
end_pts{kk}=[10e3,12e3,29e3,31e3,42e3,44e3];
kk=6;
start_pts{kk}=[50e3,53e3,71e3,77e3,91e3,95e3];
end_pts{kk}=[51e3,54e3,72e3,78e3,92e3,96e3];
kk=7;
start_pts{kk}=[33.5e3,37e3,63e3,67e3];
end_pts{kk}=[34.e3,38e3,64e3,68e3];
kk=8;
start_pts{kk}=[22e3,24e3,53e3,64e3];
end_pts{kk}=[23e3,25e3,54e3,65e3];
kk=9;
start_pts{kk}=[10e3,12e3,45e3,47e3];
end_pts{kk}=[11e3,13e3,46e3,48e3];
kk=10;
start_pts{kk}=[15e3,25e3,50.8e3,58e3];
end_pts{kk}=[16e3,26e3,51.8e3,59e3];
kk=11;
start_pts{kk}=[12e3,16e3,29e3,36e3];
end_pts{kk}=[13e3,17e3,30e3,37e3];
kk=12;
start_pts{kk}=[11e3,17e3,46e3,55e3];
end_pts{kk}=[12e3,18e3,47e3,56e3];
%% Section 5: Check Start and End Points
% Run this section to check if the selection of start and end points are ok.
negateflag=[1,-1,1,-1,1,-1,1,1,1,1,1,1];
close all;
plotNames = {'Fx1','Fx2','Fx3','Fy1','Fy2','Fy3','Fz1','Fz2','Fz3'};
for kk=1:1%start_idx:end_idx
	fh = figure;
	fh.WindowState = 'maximized';
	tiledlayout(3,3,"TileSpacing","compact","Padding","compact");
	for jj=1:9 % loop over jj for fx1,fx2,fx3,fy1,fy2,fy3,fz1,fz2,fz3
		nexttile;
		temp=Ftablefs{kk}(:,jj);
		plot(temp);
		yhigh1=max(temp);
		ylow1=min(temp);
		hold on;
		if calsensorflag(kk)==1
    		temp=negateflag(kk)*FtableCS{kk}(:,1).*sflc1N;
    		plot(temp);
    		yhigh2=max(temp);
    		ylow2=min(temp);
		elseif calsensorflag(kk)==2
    		temp=negateflag(kk)*FtableCS{kk}(:,2).*sflc1N;
    		plot(temp);
    		yhigh2=max(temp);
    		ylow2=min(temp);
		elseif calsensorflag(kk)==3 || calsensorflag(kk)==4
    		temp=negateflag(kk)*FtableCS{kk}(:,1).*sflc1N;
    		plot(temp);
    		yhigh3=max(temp);
    		ylow3=min(temp);
    		temp=negateflag(kk)*FtableCS{kk}(:,2).*sflc1N;
    		plot(temp);
    		yhigh4=max(temp);
    		ylow4=min(temp);
    		yhigh2=max([yhigh3,yhigh4]);
    		ylow2=min([ylow3,ylow4]);         
		end
		yhigh=max([yhigh1,yhigh2]);
		ylow=min([ylow1,ylow2]);
		for mm=1:length(start_pts{kk})
   		plot(ones(1,2)*start_pts{kk}(mm),[ylow,yhigh],'m');
   		plot(ones(1,2)*end_pts{kk}(mm),[ylow,yhigh],'k');
		end
		hold off;
		legend('Kistler Sensor',strcat('S-Sensor:'," ",calNames{kk}), 'Interpreter', 'none');
		title(plotNames{jj});
		axis padded;
	end
end
%% Section 6: Create Diagram
close all;
calNames = {'Fx+','Fx-','Fy+','Fy-','Fz+','Fz-','Tx+','Tx-','Ty+','Ty-','Tz+','Tz-'};
fd = figure;
fdtl = tiledlayout('flow');
fd.WindowState = 'maximized';
for kk=start_idx:end_idx
	nexttile;
	diagramcreate(Ftablefs{kk},start_pts{kk},end_pts{kk});
	title(calNames{kk});
end
fdtl.TileSpacing = 'tight';
fdtl.Padding = 'tight';
%% Section 7: K-Matrix Creation Section
%K matrix columns:
%[Kx1Fx;Kx2Fx;Kx3Fx;Ky1Fx;Ky2Fx;Ky3Fx;Kz1Fx;Kz2Fx;Kz3Fx]
K96=zeros(9,6);
%loop to create K matrix:
for kk = 1:2:12
	nsteps = length(end_pts{kk});
	npoints = nsteps/2;
	%Vs=[Vx1,Vx2,Vx3,Vy1,Vy2,Vy3,Vz1,Vz2,Vz3]. Each column is a different V, rows are different steps
	%Want both + and - steps in Vs.
    Vs=zeros(nsteps*2,9);
    CSs=zeros(nsteps*2,2);
	for ii=1:nsteps
		for jj=1:9
            Vs(ii,jj)=mean(Ftablefs{kk}(start_pts{kk}(ii):end_pts{kk}(ii),jj))*sf(jj,kk);
            Vs(ii+nsteps,jj)=mean(Ftablefs{kk+1}((start_pts{kk+1}(ii)):(end_pts{kk+1}(ii)),jj))*sf(jj,kk+1); %negative axis
		end
		% CSs=[CS1,CS2]. Each column is a different calibration force, rows are different steps
		for nn=1:2
            CSs(ii,nn)=mean(FtableCS{kk}(start_pts{kk}(ii):end_pts{kk}(ii),nn))*sflc1N;
            %calibration load cells always measure + tension. Must negate
            CSs(ii+nsteps,nn)=-1*mean(FtableCS{kk+1}(start_pts{kk+1}(ii):end_pts{kk+1}(ii),nn))*sflc1N; %negative axis
		end
	end
    %step differences = points for fit. Each column is different V, rows are different points.
	Vss = zeros(nsteps+1,9);
	CSss = zeros(nsteps+1,2);
	for ii = 1:nsteps
		for jj = 1:9
			Vss(ii+1,jj) = Vs(2*ii-caseflag(kk),jj) - Vs(2*ii+(caseflag(kk)-1),jj);
		end
		for nn = 1:2
			CSss(ii+1,nn) = CSs(2*ii-caseflag(kk),nn) - CSs(2*ii+(caseflag(kk)-1),nn);
		end
	end
    %calibration load cell points in N:
    %includes logic to account for if a + axis used Cal1 and - axis used Cal2
    ApLoad = zeros(nsteps+1,1); 
	if calsensorflag(kk) == 1 && calsensorflag(kk+1) == 1
		ApLoad = CSss(:,1); %Applied load, force, in N
	elseif calsensorflag(kk) == 2 && calsensorflag(kk+1) == 2
		ApLoad = CSss(:,2);
	elseif calsensorflag(kk) == 1 && calsensorflag(kk+1) == 2
		ApLoad(1) = CSss(1,1);
		ApLoad(2:npoints+1) = CSss(2:npoints+1,1);
		ApLoad(npoints+2:2*npoints+1) = CSss(npoints+2:2*npoints+1,2);
	elseif calsensorflag(kk) == 2 && calsensorflag(kk+1) == 1
		ApLoad(1) = CSss(1,2);
		ApLoad(2:npoints+1) = CSss(2:npoints+1,2);
		ApLoad(npoints+2:2*npoints+1) = CSss(npoints+2:2*npoints+1,1);
	elseif calsensorflag(kk) == 3
		%calculate torque
		r = 0.4699; %m moment arm for torque, bolt hole pattern radius (18.5in)
		ApLoad = CSss(:,1).*r + CSss(:,2).*r; %Applied load, torque, in N/m
	elseif calsensorflag(kk) == 2 && calsensorflag(kk+1) == 4
		Apload(1) = CSss(1,1);%true zero
		ApLoad(2:npoints+1) = CSss(2:npoints+1,2); %positive steps
		ApLoad(npoints+2:2*npoints+1) = CSss(npoints+2:2*npoints+1,1) + CSss(npoints+2:2*npoints+1,2); %Total applied load, force, in N
	elseif calsensorflag(kk) == 4 && calsensorflag(kk+1) == 4
		ApLoad = CSss(:,1)+CSss(:,2); %Total applied load, force, in N
	end
    %K column:
    %[Kx1Fx;Kx2Fx;Kx3Fx;Ky1Fx;Ky2Fx;Ky3Fx;Kz1Fx;Kz2Fx;Kz3Fx]
    weights = ones(nsteps+1,1);
    weights(1) = 50;
    for jj = 1:9
        K96(jj,(kk+1)/2) = fitline(ApLoad,Vss(:,jj),weights,0);
    end
end
%% Section 8: Get Matrix Inverse
fs1=abs([-0.7874,0,0]);
fs2=abs([0.635,0.7112,0]);
fs3=abs([0.635,-0.7112,0]);

Vfx_Ks=sum(K96(1:3,:));
Vfy_Ks=sum(K96(4:6,:));
Vfz_Ks=sum(K96(7:9,:));
Vtx_Ks=K96(9,:)-K96(8,:);
Vty_Ks=(K96(8,:)+K96(9,:))*(fs3(1)/fs1(1))-K96(7,:);
Vtz_Ks=(K96(2,:)-K96(3,:))*(fs3(2)/fs1(1))+K96(4,:)-(K96(5,:)+K96(6,:))*(fs3(1)/fs1(1));

K66=[Vfx_Ks;Vfy_Ks;Vfz_Ks;Vtx_Ks;Vty_Ks;Vtz_Ks];
K66inv=inv(K66); %this is the important matrix
disp(K66inv);
%{
%example:
V1=[2523.8,5015.4,4960.8,-25.724,1.9633,23.761,261.89,-134.26,-127.63];
Vfx=V1(1)+V1(2)+V1(3);
Vfy=V1(4)+V1(5)+V1(6);
Vfz=V1(7)+V1(8)+V1(9);
Vtx=V1(8)-V1(9);
Vty=V1(7)-(V1(8)+V1(9))*(fs3(1)/fs1(1));
Vtz=(V1(3)-V1(2))*(fs3(2)/fs1(1))-V1(4)+(V1(5)+V1(6))*(fs3(1)/fs1(1)); 
FT1=K66inv*[Vfx;Vfy;Vfz;Vtx;Vty;Vtz];
%}