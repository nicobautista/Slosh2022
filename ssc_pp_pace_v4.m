%This script filters and chops up the static system calibration data,
%then uses it to calculate the K matrix. 

%Instructions: run section 1 once. Run section 2, record step start and end
%points in section 3, run section 3, go back to section 2 and change k,
%repeat these steps for k=1:12. 
%Change r and fs's

%v3: adds a true zero point and enforces it using linear fit weights. Did
%not have much of an effect. 

%run this section once at beginning
clear all
close all
clc

single_idx = 12;

prefixfilename='./FinalData/';
csvarray={'Fx_pos_1.csv','Fx_neg_1.csv','Fy_pos_1.csv','Fy_neg_1.csv',...
    'Fz_pos_1.csv','Fz_neg_1.csv','Tx_pos_1.csv','Tx_neg_1.csv',...
    'Ty_pos_1.csv','Ty_neg_1.csv','Tz_pos_1.csv','Tz_neg_1.csv'};

%scale factor corrections for each file. Only necessary if mess up the
%scale factor entry in the Labview (which multiplies by the
%scale factor). Scale factors in labview should be the same as those on the
%charge amplifiers, which divide by SF before transmitting the voltage,
%thus requiring labview to multiply by SF. 
sf=ones(9,12); %N/V scale factors. each column: [x1;x2;x3;y1;y2;y3;z1;z2;z3]
% sf(:,1)=[100/30;100/30;100/30;5/10;5/10;5/10;5/10;5/10;5/10]; %Fx_pos_1.csv
% sf(:,7)=[1;1;1;1;1;0.1;1;1;1]; %Tx_pos_1.csv
% sf(:,8)=[1;1;1;1;1;0.1;1;1;1]; %Tx_neg_1.csv
%correct orientation to frame axes:
% sf(1,:)=sf(1,:)*-1;
% sf(2,:)=sf(2,:)*-1;
% sf(4,:)=sf(4,:)*-1;
% sf(7,:)=sf(7,:)*-1;
% sf(8,:)=sf(8,:)*-1;
% sf(9,:)=sf(9,:)*-1;
%calibration load cell scale factors (constant)
sflc1=100; %lbf/V
sflc2=100; %lbf/V
sflc1N=sflc1*4.44822; %N/V
sflc2N=sflc1N; %N/V

%Fx's, Fy's, Tz's used weights, so are step ups. Fz's, Tx's, and Ty's used
%the crane, so are step downs. The step downs will need to have sign
%negated. Cannot mix currently, i.e. can't use weights for +Fz and crane
%for -Fz. Would have to add logic for that.
caseflag=[1,1,1,1,1,1,1,1,1,1,1,1]; %0: steps go low-high (weights). 1: steps go high-low (crane).

%Have two calibration load cells. Which one did which case use?
calsensorflag=[2,2,2,2,2,2,3,3,3,3,3,3]; %1: CalLC 1, 2: CalLC 2, 3: Both CalLC's torque, 4: Both CalLC's force

%filters on calibration sensors cause a lag. turned these down after
%collecting this data, so need to shift start and end pts of force sensors
phaseshift=0; %300; %subtract from all force sensor start and end pts

%% Read in all data section
%Run this section repeatedly for different kk's

%can't really automate this because don't know the start and end points. 
for kk=1:1:12
% kk=single_idx;
    % import data file
    filename = [prefixfilename,csvarray{kk}];
    Ftable=importdata1(filename);
    %remove variables not relevant to static system calibration
    Ftable = removevars(Ftable,{'time','Baffle1','Baffle2','Baffle3','Baffle4','Baffle5','Baffle6','PositionSensor','Accelerometer','PressureTransducer','Fx','Fy','Fz','Tx','Ty','Tz'});
    temp=table2array(Ftable);
    %force sensors only. rearrange to [Fx1,Fx2,Fx3,Fy1,Fy2,Fy3,Fz1,Fz2,Fz3].
    %Different columns, different axes vs. time. 
    Ftablefs{kk}=[temp(:,1),temp(:,4),temp(:,7),temp(:,2),temp(:,5),temp(:,8),temp(:,3),temp(:,6),temp(:,9)];
    %calibration load cells only. [CS1,CS2]. Different columns, different load cells vs. time.
    FtableCS{kk}=table2array(Ftable(:,10:11)); 
    clear Ftable temp
    
    %plot calibration sensor data in order to find indices of steps. record
    %these indices in the start_pts and end_pts arrays.
    %Also check one of the higher load force sensor axes.
%     figure
%     plot(FtableCS{kk}(:,1))
%     title('CS1')
%     
%     figure
%     plot(FtableCS{kk}(:,2))
%     title('CS2')
    
%     Fx1f=filter1(10,5,1000,Ftablefs{kk}(:,1));
    
%     figure
%     plot(Ftablefs{kk}(:,7))
%     hold on
% %     plot(filter1(10,5,1000,-Ftablefs{kk}(:,9)))
%     plot(FtableCS{kk}(:,1).*sflc1N)
%     plot(FtableCS{kk}(:,2).*sflc1N)
%     hold off
%     title('FS')
    
end
%%
    %start and end points for all steps that will be averaged
    %First level portion is a zero. Ignore end level portion because force sensors have residual charge. 
    %0, step, step, step
%first SSC:
%     kk=single_idx;
%     start_pts{kk}=[22000,24500,52500,58000];
%     end_pts{kk}=[23000,25500,53500,59000];   
    kk=1;
    start_pts{kk}=[39000,44000,73000,78000,101000,105000];
    end_pts{kk}=[40000,45000,74000,79000,102000,106000];
    kk=2;
    start_pts{kk}=[31000,35000,53500,58000,76000,81000];
    end_pts{kk}=[32000,36000,54500,59000,77000,82000];
    kk=3;
    start_pts{kk}=[16000,20000,43000,46000,60000,62000];
    end_pts{kk}=[17000,21000,44000,47000,61000,63000];
    kk=4;
    start_pts{kk}=[17500,20500,44000,47000,56000,58300];
    end_pts{kk}=[18500,21500,45000,48000,57000,59300];
    kk=5;
    start_pts{kk}=[9000,11000,28000,30000,41500,43000];
    end_pts{kk}=[10000,12000,29000,31000,42500,44000];
    kk=6;
    start_pts{kk}=[50000,53500,71000,76000,91000,95000];
    end_pts{kk}=[51000,54500,72000,77000,92000,96000];  
    kk=7;
    start_pts{kk}=[6500,9000,24500,26500];
    end_pts{kk}=[7500,10000,25500,27500];  
    kk=8;
    start_pts{kk}=[22000,24500,52500,58000];
    end_pts{kk}=[23000,25500,53500,59000]; 
    kk=9;
    start_pts{kk}=[10000,13000,45000,48000];
    end_pts{kk}=[11000,14000,46000,49000]; 
    kk=10;
    start_pts{kk}=[14500,22000,50000,57000];
    end_pts{kk}=[15500,23000,51000,58000];
    kk=11;
    start_pts{kk}=[12500,16000,29500,34000];
    end_pts{kk}=[13500,17000,30500,35000];
    kk=12;
    start_pts{kk}=[11000,16000,46000,53000];
    end_pts{kk}=[12000,17000,47000,54000];
%% check start and end pts
negateflag=[1,1,1,1,1,1,1,1,1,1,1,1];
%loop over kk
for kk=1:12
% kk=single_idx;
% loop over jj
    for jj=1:9
% jj=8;
        figure
        temp=Ftablefs{kk}(:,jj);
        plot(temp)
        yhigh1=max(temp);
        ylow1=min(temp);
        hold on
        if calsensorflag(kk)==1
            temp=negateflag(kk)*FtableCS{kk}(:,1).*sflc1N;
            plot(temp)
            yhigh2=max(temp);
            ylow2=min(temp);
        elseif calsensorflag(kk)==2
            temp=negateflag(kk)*FtableCS{kk}(:,2).*sflc1N;
            plot(temp)
            yhigh2=max(temp);
            ylow2=min(temp);
        elseif calsensorflag(kk)==3 || calsensorflag(kk)==4
            temp=negateflag(kk)*FtableCS{kk}(:,1).*sflc1N;
            plot(temp)
            yhigh3=max(temp);
            ylow3=min(temp);
            temp=negateflag(kk)*FtableCS{kk}(:,2).*sflc1N;
            plot(temp)
            yhigh4=max(temp);
            ylow4=min(temp);
            yhigh2=max([yhigh3,yhigh4]);
            ylow2=min([ylow3,ylow4]);         
        end
        yhigh=max([yhigh1,yhigh2]);
        ylow=min([ylow1,ylow2]);
        for mm=1:length(start_pts{kk})
           plot(ones(1,2)*start_pts{kk}(mm),[ylow,yhigh],'m')
           plot(ones(1,2)*end_pts{kk}(mm),[ylow,yhigh],'k')
        end
        hold off
        legend('FS','Cal')
        title([num2str(kk),' ',num2str(jj)])
    end
end

%% Create diagram
kk=single_idx;
%This plots a top down view with force vectors for the highest load test
%point. It also estimates the net forces and torques. However, the net
%forces and torques are raw and not calibrated. The rule of thumb is that
%the off-axis forces and torques (the ones not being forced) should be low,
%
%ideally < 1% (and definitely <5%) of the max applied load in the forced axis.
%You have to be careful though, sometimes a off-axis force or torque is
%expected. For example, +Fy should cause a net +Tz due to where the center
%of9209hg
%the force sensors are vs. center of the tank.

diagramcreate(Ftablefs{kk},FtableCS{kk},start_pts{kk},end_pts{kk})


%% K matrix creation section


%K matrix columns:
%[Kx1Fx;Kx2Fx;Kx3Fx;Ky1Fx;Ky2Fx;Ky3Fx;Kz1Fx;Kz2Fx;Kz3Fx]
K96=zeros(9,6);

%loop to create K matrix:
for kk=1:2:12
 %make time array:
%     dt=0.001; %time step [s]
%     tvec=0:dt:dt*(length(FtableCS{kk}(:,1))-1);
%     tvec=tvec';
    
    nsteps=length(end_pts{kk});
    if nsteps==6
        npoints=3; %number of low-high or high-low steps
    elseif nsteps==4
        npoints=2;
    end

    %Vs=[Vx1,Vx2,Vx3,Vy1,Vy2,Vy3,Vz1,Vz2,Vz3]. Each column is a different V, rows are different steps
    %Want both + and - steps in Vs. 
    Vs=zeros(nsteps*2,9);
    for ii=1:nsteps
        for jj=1:9
%             if ii==1 %no phaseshift on start pt if 0 step
%                 Vs(ii,jj)=mean(Ftablefs{kk}((start_pts{kk}(ii)):(end_pts{kk}(ii)-phaseshift),jj))*sf(jj,kk);
%                 Vs(ii+nsteps,jj)=mean(Ftablefs{kk+1}((start_pts{kk+1}(ii)):(end_pts{kk+1}(ii)-phaseshift),jj))*sf(jj,kk+1); %negative axis 
%             else
                Vs(ii,jj)=mean(Ftablefs{kk}((start_pts{kk}(ii)-phaseshift):(end_pts{kk}(ii)-phaseshift),jj))*sf(jj,kk);
                Vs(ii+nsteps,jj)=mean(Ftablefs{kk+1}((start_pts{kk+1}(ii)-phaseshift):(end_pts{kk+1}(ii)-phaseshift),jj))*sf(jj,kk+1); %negative axis
%             end
        end
    end
    
    %move second 0 load step to the front:
%     temp=Vs(nsteps+1,:);
%     Vs(nsteps+1,:)=[];
%     Vs=[temp;Vs];
%     clear temp

    % CSs=[CS1,CS2]. Each column is a different calibration force, rows are different steps
    %calibration load cell forces in N 
    CSs=zeros(nsteps*2,2);
    for ii=1:nsteps
        for jj=1:2
            CSs(ii,jj)=mean(FtableCS{kk}(start_pts{kk}(ii):end_pts{kk}(ii),jj))*sflc1N;
            %calibration load cells always measure + tension. Must negate
            %for negative axes:
            CSs(ii+nsteps,jj)=-1*mean(FtableCS{kk+1}(start_pts{kk+1}(ii):end_pts{kk+1}(ii),jj))*sflc1N; %negative axis
        end
    end
    
    %move second 0 load step to the front:
%     temp=CSs(nsteps+1,:);
%     CSs(nsteps+1,:)=[];
%     CSs=[temp;CSs];
%     clear temp

    %step differences = points for fit. Each column is different V, rows are different points.
    Vss=zeros(npoints*2,9);
    for ii=1:npoints*2
        if caseflag(kk)==0 %weights, low-high steps
            for jj=1:9
                Vss(ii,jj)=Vs(2*ii,jj)-Vs(2*ii-1,jj);
            end
        elseif caseflag(kk)==1 %crane or stage, high-low steps
            for jj=1:9
                Vss(ii,jj)=Vs(2*ii-1,jj)-Vs(2*ii,jj);
            end
        end
    end
%     Vss=[Vs(2,:);Vss]; %add zero point
%     Vss=[Vs(1,:);Vss]; %add zero point
    Vss=[zeros(1,9);Vss]; %add true zero point

    %Vss should be 1+2*npoints x 9 now. 
    
    %calibration load cell points in N:
    CSss=zeros(npoints*2,2);
    for ii=1:npoints*2
        if caseflag(kk)==0 %weights, low-high steps
            for jj=1:2
                CSss(ii,jj)=CSs(2*ii,jj)-CSs(2*ii-1,jj);
            end
        elseif caseflag(kk)==1 %crane or stage, high-low steps
            for jj=1:2
                CSss(ii,jj)=CSs(2*ii-1,jj)-CSs(2*ii,jj);
            end
        end
    end
%     CSss=[CSs(2,:);CSss];  %add zero point
%     CSss=[CSs(1,:);CSss];  %add zero point
    CSss=[zeros(1,2);CSss]; %add true zero point
 

    %includes logic to account for if a + axis used Cal1 and - axis used Cal2
    ApLoad=zeros((2*npoints+1),1); 
    if calsensorflag(kk)==1 && calsensorflag(kk+1)==1
        ApLoad=CSss(:,1); %Applied load, force, in N
    elseif calsensorflag(kk)==2 && calsensorflag(kk+1)==2
        ApLoad=CSss(:,2);
    elseif calsensorflag(kk)==1 && calsensorflag(kk+1)==2
        ApLoad(1)=CSss(1,1);
        ApLoad(2:npoints+1)=CSss(2:npoints+1,1);
        ApLoad(npoints+2:2*npoints+1)=CSss(npoints+2:2*npoints+1,2);
    elseif calsensorflag(kk)==2 && calsensorflag(kk+1)==1
        ApLoad(1)=CSss(1,2);
        ApLoad(2:npoints+1)=CSss(2:npoints+1,2);
        ApLoad(npoints+2:2*npoints+1)=CSss(npoints+2:2*npoints+1,1);
    elseif calsensorflag(kk)==3
        %calculate torque
        r=0.3937; %m moment arm for torque, bolt hole pattern radius (15.5in)
        ApLoad=CSss(:,1).*r+CSss(:,2).*r; %Applied load, torque, in N/m
    elseif calsensorflag(kk)==2 && calsensorflag(kk+1)==4
        Apload(1)=CSss(1,1);%true zero
        ApLoad(2:npoints+1)=CSss(2:npoints+1,2); %positive steps
        ApLoad(npoints+2:2*npoints+1)=CSss(npoints+2:2*npoints+1,1)+CSss(npoints+2:2*npoints+1,2); %Total applied load, force, in N
    elseif calsensorflag(kk)==4 && calsensorflag(kk+1)==4
        ApLoad=CSss(:,1)+CSss(:,2); %Total applied load, force, in N
    end
    
%     figure
%     scatter(ApLoad,Vss(:,1))

%     diagramcreate(stepM,npoints) %creates arrow diagram

    %K column:
    %[Kx1Fx;Kx2Fx;Kx3Fx;Ky1Fx;Ky2Fx;Ky3Fx;Kz1Fx;Kz2Fx;Kz3Fx]
    weights=ones((2*npoints+1),1);
    weights(1)=50;
    for jj=1:9
        K96(jj,(kk+1)/2)=fitline(ApLoad,Vss(:,jj),weights);
%         jj
%         (kk+1)/2
    end
end


%%

%now have a K96
%corrections for weak trends or slight trends that shouldn't exist:
% K96([4,5,6,7,8,9],1)=0; %Fx column corrections
% K96([1,7,8,9],2)=0; %Fy
% K96(5,3)=0; %Fz
% K96([1,7],4)=0; %Tx
%zeroing Ty and Tz seem to make things slightly worse.
% K96(4,5)=0; %Ty
% K96([1,7,8,9],6)=0; %Tz

%force sensor locations
%PACE: 
fs1=abs([-0.7874,0,0]);
fs2=abs([0.635,0.7112,0]);
fs3=abs([0.635,-0.7112,0]);

Vfx_Ks=sum(K96(1:3,:));
Vfy_Ks=sum(K96(4:6,:));
Vfz_Ks=sum(K96(7:9,:));
Vtx_Ks=K96(8,:)-K96(9,:);
Vty_Ks=K96(7,:)-(K96(8,:)+K96(9,:))*(fs3(1)/fs1(1)); 
Vtz_Ks=(K96(3,:)-K96(2,:))*(fs3(2)/fs1(1))-K96(4,:)+(K96(5,:)+K96(6,:))*(fs3(1)/fs1(1));

K66=[Vfx_Ks;Vfy_Ks;Vfz_Ks;Vtx_Ks;Vty_Ks;Vtz_Ks];
% check=(K66-K66new)./K66new;
K66inv=inv(K66); %this is the important matrix
%K66inv*V(6x1)=FT(6x1)
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