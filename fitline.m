function [K] = fitline(x,y,weights,plotBool)
% This function takes a X column vector and Y column vector and creates a
% linear fit. It then returns the slope of that line, which is the K [V/N]
% coefficient. 
% X should be the calibration load cell data points
% Y should be the force sensor voltage axis data points
% tvec is a time vector for plotting

[fitFV,gof] = fit(x,y,'poly1','Weights',weights);
xlimlow=min(x);
xlimhigh=max(x);
xvec=linspace(xlimlow,xlimhigh);
cfs=coeffvalues(fitFV);
fitFVvec=feval(fitFV,xvec);
if plotBool
	figure
	hold on
	scatter(x,y)
	plot(xvec,fitFVvec)
	title('V vs. F')
	legend('data points','fit')
	hold off
end
K=cfs(1); %V/N

if gof.rsquare < 0.9
    warning('Linear fit R^2 < 0.9')
end
end

