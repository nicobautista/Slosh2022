function [K] = fitline(x,y,weights,plotBool)
% This function takes a X column vector and Y column vector and creates a
% linear fit. It then returns the slope of that line, which is the K [V/N]
% coefficient. 
% X should be the calibration load cell data points
% Y should be the force sensor voltage axis data points

[fitFV,gof] = fit(x,y,'poly1','Weights',weights);
xvec=linspace(min(x),max(x));
cfs=coeffvalues(fitFV);
fitFVvec=feval(fitFV,xvec);
K=cfs(1); %V/N
if gof.rsquare < 0.9
    warning('Linear fit R^2: %.2f < 0.9',gof.rsquare)
end
if plotBool
	figure;
	scatter(x,y);
	hold on;
	plot(xvec,fitFVvec);
	title('V vs. F');
	legend('Data points','Fit');
	hold off;
end
end

