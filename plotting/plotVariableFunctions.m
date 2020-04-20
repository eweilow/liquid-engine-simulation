%%

figure(1);

Mv = 0:0.01:15; % Evaluate Mach Cd in these mach numbers
[M, Cd, MFn, CdFn] = dragCoefficient();

plot(Mv, CdFn(Mv))
title("Coefficient of drag as function of Mach number");
xlabel("Mach number [1]");
ylabel("Coefficient of drag [1]");

drawnow
storeFigure("./plots/coefficientOfDrag");

%%

figure(1);

hv = 0:1:150; % Evaluate Mach Cd in these mach numbers
g = gravityAtAltitude(hv.*1000);

plot(g, hv)
yticks([0, 25, 50, 75 100, 125]);
title("Gravitational acceleration as function of altitude");
ylabel("Altitude [km]");
xlabel("Gravity [m/s^2]");

storeFigure("./plots/gravity");

%%

figure(1);

hv = 0:0.1:150; % Evaluate Mach Cd in these mach numbers
rho = airDensityAtAltitude(hv.*1000);

semilogy(rho, hv)
yticks([1, 10, 20, 100]);
title("Air density as function of altitude");
ylabel("Altitude [km]");
xlabel("Air density [kg/m^3]");

storeFigure("./plots/airDensity");
