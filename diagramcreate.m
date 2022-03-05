function [] = diagramcreate(fdata,csdata,startpts,endpts)
%This function creates a load diagram for a calibration test
%fdata: FtableFS{kk}, so it's a matrix. 
%csdata: FtableCS{kk}, also a matrix
%startpts: start_pts{kk}, array
%endpts: end_pts{kk}, array

%****change these if change tank:****
fs1=[0.7874,0,0];
fs2=[-0.635,-0.7112,0];
fs3=[-0.635,0.7112,0];
r=0.3937; %m moment arm for torque, bolt hole pattern radius (15.5 in)

%generate squares: force sensor plates
% figure

w=1*0.2; %m
x1=-w/2+fs1(1);
x2=w/2+fs1(1);
y1=-w/2+fs1(2);
y2=w/2+fs1(2);
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
plot(x, y, 'k-', 'LineWidth', 2);
hold on
x3=-w/2+fs2(1);
x4=w/2+fs2(1);
y3=-w/2+fs2(2);
y4=w/2+fs2(2);
x = [x3, x4, x4, x3, x3];
y = [y3, y3, y4, y4, y3];
plot(x, y, 'k-', 'LineWidth', 2);
x5=-w/2+fs3(1);
x6=w/2+fs3(1);
y5=-w/2+fs3(2);
y6=w/2+fs3(2);
x = [x5, x6, x6, x5, x5];
y = [y5, y5, y6, y6, y5];
plot(x, y, 'k-', 'LineWidth', 2);

%X,Y,Z forces
avgs_1=mean(fdata(startpts(1):endpts(1),:));
avgs_2=mean(fdata(startpts(2):endpts(2),:));
deltas=avgs_1-avgs_2;
% XY Arrow Drawing:
arrow_size = 0.25;
arrow_thickness = 3;
arrow_dims = [0,arrow_size];
txt_padding = [0.5*arrow_dims(2),-0.05;-0.05,1.15*arrow_dims(2)];
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
text(x1,y1-0.05,sprintf("%.1f N",deltas(7)));
text(x3,y3-0.05,sprintf("%.1f N",deltas(8)));
text(x5,y5-0.05,sprintf("%.1f N",deltas(9)));

%total F's and T's
netFx=sum(deltas(1:3));
netFy=sum(deltas(4:6));
netFz=sum(deltas(7:9));

netTx=(deltas(9)-1*deltas(8))*abs(fs2(2));
netTy=-1*deltas(7)*abs(fs1(1))+(deltas(8)+deltas(9))*abs(fs2(2));
netTz=deltas(2)*abs(fs2(2))-1*deltas(3)*abs(fs3(2))+deltas(4)*abs(fs1(1))-1*(deltas(5)+deltas(6))*abs(fs2(1));

txt = {[sprintf('Net Fx: %10.1f N',netFx)],...
    [sprintf('Net Fy: %10.1f N',netFy)],...
    [sprintf('Net Fz: %10.1f N',netFz)],...
    [sprintf('Net Tx: %10.1f Nm',netTx)],...
    [sprintf('Net Ty: %10.1f Nm',netTy)],...
    [sprintf('Net Tz: %10.1f Nm',netTz)]};
text(0,0,txt)
axis padded
hold off
xticklabels([]);
yticklabels([]);


%plot squares at each force sensor center, add number
%view down
%if npoints=2, second row is highest mag positive axis, 4th row is highest
%mag negative axis. If npoints=3, second row is highest mag positive axis,
%5th row is highest mag negative axis. 2+npoints
%one arrow for each entry in Vss row, arrow length by magnitude.
%do X or circle dot for Z
%do net force and torque calcs and write those on the diagram. 


end

