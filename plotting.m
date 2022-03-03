
clear all
close all
clc

testcase=3;
prefixfilename='/Users/nicholas/Desktop/SSC/';
% csvarray={'test_SSC5\Fx_pos_2.csv','test_SSC5\Fz_pos_Ty_neg_test_1.csv'};
csvarray={'Fx_pos_1.csv','Fz_pos_Ty_neg_test_1.csv','Fy_pos_1.csv'};
sflc1=100; %lbf/V
sflc2=100; %lbf/V
sflc1N=sflc1*4.44822; %N/V
sflc2N=sflc1N; %N/V
filename = [prefixfilename,csvarray{testcase}];
table1=importdata1(filename);
%remove variables not relevant to static system calibration
table1 = removevars(table1,{'time','Baffle1','Baffle2','Baffle3','Baffle4','Baffle5','Baffle6','PositionSensor','Accelerometer','PressureTransducer','Fx','Fy','Fz','Tx','Ty','Tz'});

% 180-(atan(0.635/0.7112)*180/pi+90)
% atan(13.2/8)*180/pi
% atan(18.3/7)*180/pi

load('ULA_K.mat');
% load('ULA_K_zeroing.mat');

%corrections for weak trends or slight trends that shouldn't exist:
% K96([4,5,6],1)=0; %Fx column corrections, Fy
% K96([7,8,9],1)=0; %Fx column corrections, Fz
% K96(7,2)=0; %Fy, Fz1=0
% K96(5,3)=0; %Fz
% K96([1,7],4)=0; %Tx
%zeroing Ty seems to make things slightly worse.
% K96(4,5)=0; %Ty
% K96([1,7,8,9],6)=0; %Tz

%force sensor locations
%ULA:
fs1=abs([-0.8509,0,0]);
fs2=abs([0.5715,0.7112,0]);
fs3=abs([0.5715,-0.7112,0]);

% Vfx_Ks=sum(K96(1:3,:));
% Vfy_Ks=sum(K96(4:6,:));
% Vfz_Ks=sum(K96(7:9,:));
% Vtx_Ks=K96(8,:)-K96(9,:);
% Vty_Ks=K96(7,:)-(K96(8,:)+K96(9,:))*(fs3(1)/fs1(1)); 
% Vtz_Ks=(K96(3,:)-K96(2,:))*(fs3(2)/fs1(1))-K96(4,:)+(K96(5,:)+K96(6,:))*(fs3(1)/fs1(1));
% K66=[Vfx_Ks;Vfy_Ks;Vfz_Ks;Vtx_Ks;Vty_Ks;Vtz_Ks];
% K66inv=inv(K66); %this is the important matrix

% table1.Fx1=table1.Fx1*5/100;


fs=1000;
cutofff=20;
order=5;
%filter force sensor data
table1f=table1;
for ii=1:9
    table1f{:,ii}=filter1(cutofff,order,fs,table1{:,ii});
end

% Vfx=table1.Fx1+table1.Fx2+table1.Fx3;
% Vfy=table1.Fy1+table1.Fy2+table1.Fy3;
% Vfz=table1.Fz1+table1.Fz2+table1.Fz3;
% Vtx=table1.Fz2-table1.Fz3;
% Vty=table1.Fz1-(table1.Fz2+table1.Fz3)*(fs3(1)/fs1(1));
% Vtz=(table1.Fx3-table1.Fx2)*(fs3(2)/fs1(1))-table1.Fy1+(table1.Fy2+table1.Fy3)*(fs3(1)/fs1(1));

Vfx=table1f.Fx1+table1f.Fx2+table1f.Fx3;
Vfy=table1f.Fy1+table1f.Fy2+table1f.Fy3;
Vfz=table1f.Fz1+table1f.Fz2+table1f.Fz3;
Vtx=table1f.Fz2-table1f.Fz3;
Vty=table1f.Fz1-(table1f.Fz2+table1f.Fz3)*(fs3(1)/fs1(1));
Vtz=(table1f.Fx3-table1f.Fx2)*(fs3(2)/fs1(1))-table1f.Fy1+(table1f.Fy2+table1f.Fy3)*(fs3(1)/fs1(1)); 

FT1=K66inv*([Vfx,Vfy,Vfz,Vtx,Vty,Vtz]');
% FT1=K66\([Vfx,Vfy,Vfz,Vtx,Vty,Vtz]');
FT1=FT1';


% figure
% plot(table1.Fy1)
% hold on
% plot(table1.Fy2)
% plot(table1.Fy3)
% % plot(table1.Fz1)
% % plot(table1.Fz2)
% % plot(table1.Fz3)
% plot(Vfy)
% hold off
% legend('F1','F2','F3','V')
% % legend('Fy1','Fy2','Fy3','Fx2','Fx3','Vtz')


torquearm=0.6645; %m radius to large bolt holes in rings.
%
% AppFx=filter1(cutofff,order,fs,table1.CalibrationSensor2).*sflc2N;

% AppFz=filter1(cutofff,order,fs,table1.CalibrationSensor2).*sflc1N;
% AppTy=AppFz.*-1*torquearm; 
%
AppFy=1*filter1(cutofff,order,fs,table1.CalibrationSensor2).*sflc1N;
%
% AppFz=filter1(cutofff,order,fs,table1.CalibrationSensor2).*sflc2N;
% AppTx=AppFz.*torquearm;
%
% AppFx=filter1(cutofff,order,fs,table1.CalibrationSensor1).*sflc2N;
%
% AppFz=filter1(cutofff,order,fs,table1.CalibrationSensor1).*sflc1N-filter1(cutofff,order,fs,table1.CalibrationSensor2).*sflc2N;
% AppTy=-1*filter1(cutofff,order,fs,table1.CalibrationSensor1).*sflc1N*torquearm+-1*filter1(cutofff,order,fs,table1.CalibrationSensor2).*sflc2N*torquearm;


figure
hold on
plot(FT1(:,1))
plot(FT1(:,2))
plot(FT1(:,3))
plot(FT1(:,4))
plot(FT1(:,5))
plot(FT1(:,6))
% plot(filter1(cutofff,order,fs,FT1(:,1)))
% plot(filter1(cutofff,order,fs,FT1(:,2)))
% plot(filter1(cutofff,order,fs,FT1(:,3)))
% plot(filter1(cutofff,order,fs,FT1(:,4)))
% plot(filter1(cutofff,order,fs,FT1(:,5)))
% plot(filter1(cutofff,order,fs,FT1(:,6)))
% plot(AppFx)
plot(AppFy)
% plot(AppFz)
% % plot(AppTx)
% plot(AppTy)
% plot(filter1(cutofff,order,fs,table1.CalibrationSensor1).*sflc1N)
% plot(filter1(cutofff,order,fs,table1.CalibrationSensor2).*sflc2N)
hold off
ylabel('Force [N] or Torque [Nm]')
% legend('Fx','Fy','Fz','Tx','Ty','Tz','Applied Fx','Applied Fz','Applied Ty');
legend('Fx','Fy','Fz','Tx','Ty','Tz','Applied Fy');
% legend('Fx','Fy','Fz','Tx','Ty','Tz','Applied Fz','Applied Ty');
% legend('Fx','Fy','Fz','Tx','Ty','Tz','Applied Fz','Applied Tx');
% legend('Fx','Fy','Fz','Tx','Ty','Tz','Applied Fx');
% legend('Fx','Fy','Fz','Tx','Ty','Tz','LC1','LC2');

%SSC5:
%within 1% on Fz and Ty, others low as expected
%