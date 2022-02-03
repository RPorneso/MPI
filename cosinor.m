function tau = cosinor(Y)

validateattributes(Y,{'double'},{'2d'})

%%% OUTPUT: graph of vector Y including double harmonic fit and tau
%%% INPUT: Y is a vector containing raw actigraphy data (double)

[xData, yData] = prepareCurveData([], Y);
ft = fittype('fourier2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0 0 0 0 0 0];
[fitresult, gof] = fit(xData,yData,ft,opts);  
figure;
plot(xData, yData);
hold on;
plot(fitresult); 
xlabel('Time in Minutes');
ylabel('Movement (raw actigaph)');
title('Double Harmonic Regression of Activity (with period)')
hold off;

omega = abs(fitresult.w);
omega = omega*60;
tau = 2*pi / omega;

end