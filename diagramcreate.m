function [] = diagramcreate(fdata,startpts,endpts)
%This function creates a load diagram for a calibration test
%fdata: FtableFS{kk}: matrix
%startpts: start_pts{kk}: array
%endpts: end_pts{kk}: array

fs1=[0.7874,0];
fs2=[-0.635,-0.7112];
fs3=[-0.635,0.7112];
m_arms = [fs1;fs2;fs3];
for i=1:3
	plot(m_arms(i,1), m_arms(i,2), 'ks','MarkerSize',40,'LineWidth',3.5);
	hold on;
end
%X,Y,Z forces
avgs_1=mean(fdata(startpts(3):endpts(3),:));
avgs_2=mean(fdata(startpts(4):endpts(4),:));
deltas=avgs_1-avgs_2;
% XY Arrow Drawing:
arrow_size = 0.25;
arrow_thickness = 3;
arrow_dims = [0,arrow_size];
txt_padding = [0.55*arrow_dims(2),-0.075;-0.05,1.15*arrow_dims(2)];
arrows_X = [fs1(1),fs2(1),fs3(1)];
arrows_Y = [fs1(2),fs2(2),fs3(2)];
colors = ['b','r','g'];
count = 1;
for xy_idx = 1:2
	for sensors_idx = 1:3
		quiver(arrows_X(sensors_idx),arrows_Y(sensors_idx),arrow_dims(3-xy_idx),arrow_dims(xy_idx),colors(sensors_idx),'LineWidth',arrow_thickness);
		text(arrows_X(sensors_idx)+txt_padding(xy_idx,1),arrows_Y(sensors_idx)+txt_padding(xy_idx,2),sprintf('%.1f N',deltas(count)));
		count = count + 1;
	end
end
line_th = 2;
plot(fs1(1),fs1(2),'o','Color',[0,0,0.45],'MarkerSize',17,'LineWidth',line_th);
plot(fs2(1),fs2(2),'o','Color',[0.45,0,0],'MarkerSize',17,'LineWidth',line_th);
plot(fs3(1),fs3(2),'o','Color',[0,0.45,0],'MarkerSize',17,'LineWidth',line_th);
if deltas(7) > 0
    plot(fs1(1),fs1(2),'o','Color',[0,0,0.45],'MarkerFaceColor',[0,0,0.45],'MarkerSize',10);
else
    plot(fs1(1),fs1(2),'x','Color',[0,0,0.45],'MarkerSize',17,'LineWidth',line_th*1.75);
end
if deltas(8) > 0
    plot(fs2(1),fs2(2),'o','Color',[0.45,0,0],'MarkerFaceColor',[0.45,0,0],'MarkerSize',10);
else
    plot(fs2(1),fs2(2),'x','Color',[0.45,0,0],'MarkerSize',17,'LineWidth',line_th*1.75);
end
if deltas(9) > 0
    plot(fs3(1),fs3(2),'o','Color',[0,0.45,0],'MarkerFaceColor',[0,0.45,0],'MarkerSize',10);
else
    plot(fs3(1),fs3(2),'x','Color',[0,0.45,0],'MarkerSize',17,'LineWidth',line_th*1.75);
end
text(m_arms(1,1)-0.15,m_arms(1,2)-0.21,sprintf("%.1f N",deltas(7)));
text(m_arms(2,1)-0.15,m_arms(2,2)-0.21,sprintf("%.1f N",deltas(8)));
text(m_arms(3,1)-0.15,m_arms(3,2)-0.21,sprintf("%.1f N",deltas(9)));

%total F's and T's
netFx=sum(deltas(1:3));
netFy=sum(deltas(4:6));
netFz=sum(deltas(7:9));
netTx=(deltas(9)-1*deltas(8))*abs(fs2(2));
netTy=-1*deltas(7)*abs(fs1(1))+(deltas(8)+deltas(9))*abs(fs2(1));
netTz=deltas(2)*abs(fs2(2))-1*deltas(3)*abs(fs3(2))+deltas(4)*abs(fs1(1))-1*(deltas(5)+deltas(6))*abs(fs2(1));

txt = {	[sprintf('Net Fx: %10.1f N ',netFx)],...
    	[sprintf('Net Fy: %10.1f N ',netFy)],...
    	[sprintf('Net Fz: %10.1f N ',netFz)],...
    	[sprintf('Net Tx: %10.1f Nm',netTx)],...
    	[sprintf('Net Ty: %10.1f Nm',netTy)],...
    	[sprintf('Net Tz: %10.1f Nm',netTz)]};
text(0,0,txt);
ylim([1.6*m_arms(2,1),1.4*m_arms(1,1)]);
hold off;
xticklabels([]);
yticklabels([]);
end