run setup.m;

close all
clf
clear

allMassFlows = [];
apoapsides = [];
thrusts = [];
masses = [];
dryMasses = [];
burnTimes = [];
accLO = [];
accMax = [];
accMin = [];

%%

figure(1)
clf

Isp = 200;

chosenMassFlow = 0.6;

optimizeRadius = 1;
print = 1;

propellantMass = 7;
optimalSkinninessRatio = 15;

tankMassFactor = 1.35e-5; % rho / sigma

presTankPressure = 35e6;
tankPressure = 5e6;

payloadMass = 5;
    
fuelDensity = 789;
oxidDensity = 1230;

fuelRatio = 5;
    
gamma = 1.4;

massFlows = 20;

massFlowMin = 0.3;
massFlowMax = 1;

%allMassFlows = zeros(1, massFlows);
%apoapsides = zeros(1, massFlows);

%%

clc
for j = 1:massFlows
    massFlow = rand(1) * (massFlowMax - massFlowMin) + massFlowMin;
    
    [ ...
        t, ...
        y, ...
        vel, ...
        acc,...
        liftoffAcceleration, ...
        maximumAcceleration, ...
        minimumAcceleration, ...
        v_e, ...
        dv, ...
        burnTime, ...
        dryMass, ...
        wetMass, ...
        thrust ...
    ] = runSimulation(massFlow, Isp, payloadMass, propellantMass, fuelRatio, fuelDensity, oxidDensity, presTankPressure, tankPressure, tankMassFactor, gamma, optimalSkinninessRatio, optimizeRadius, print);
        
    apoapsis = max(y(:,4)) / 1000;
    apoapsides(length(apoapsides) + 1) = apoapsis;
    allMassFlows(length(allMassFlows) + 1) = massFlow;
    thrusts(length(thrusts) + 1) = thrust;
    
    masses(length(masses) + 1) = wetMass;
    dryMasses(length(dryMasses) + 1) = dryMass;
    burnTimes(length(burnTimes) + 1) = burnTime;
    
    accLO(length(accLO) + 1) = liftoffAcceleration;
    accMax(length(accMax) + 1) = maximumAcceleration;
    accMin(length(accMin) + 1) = minimumAcceleration;
    
    if mod(j, 10) == 0
        plotSimulations(Isp, chosenMassFlow, accLO, accMax, accMin, propellantMass, massFlowMin, massFlowMax, apoapsides, allMassFlows, thrusts, masses, dryMasses, burnTimes)
    end
end
%%


[ ...
    t, ...
    y, ...
    vel, ...
    acc, ...
    liftoffAcceleration, ...
    maximumAcceleration, ...
    minimumAcceleration, ...
    v_e, ...
    dv, ...
    burnTime, ...
    dryMass, ...
    wetMass, ...
    thrust, ...
    tankRadius, ...
    fuelTankMass, ...
    fuelTankLength, ...
    oxidTankMass, ...
    oxidTankLength, ...
    presTankMass, ...
    presTankLength, ...
    presVolume, ...
    totalTankLength, ...
    skinninessRatio ...
] = runSimulation(chosenMassFlow, Isp, payloadMass, propellantMass, fuelRatio, fuelDensity, oxidDensity, presTankPressure, tankPressure, tankMassFactor, gamma, optimalSkinninessRatio, 1, 1);




figure('IntegerHandle', 'off', 'Name', 'Tanks', 'DefaultAxesFontSize',14);

clf;
hold on
drawTank('Fuel tank', tankRadius, fuelTankLength, 0);
drawTank('Oxidizer tank', tankRadius, oxidTankLength, fuelTankLength + tankRadius*2);
drawTank('Pressurizer tank', tankRadius, presTankLength, fuelTankLength + oxidTankLength + tankRadius*4);
axis equal;
legend('show', 'Location', 'best');
xlabel("x [m]");
ylabel("y [m]");
title("Tank dimensions");



figure('IntegerHandle', 'off', 'Name', 'Single trajectory', 'DefaultAxesFontSize',14);

clf;
subplot(2,3,1);
plot(t,y(:,4));
xlabel('Time (s)');
ylabel('Altitude (m)');
ax = gca;
ax.YRuler.Exponent = 0;
ax.XRuler.Exponent = 0;
title("Altitude over time");

subplot(2,3,2);
vel = y(:,5:6)';
velVals = sqrt(vel(1,:).^2 + vel(2,:).^2);
plot(t,velVals);
plot(t, velVals);
xlabel('Time (s)');
ylabel('Velocity (m/s)');
ax = gca;
ax.YRuler.Exponent = 0;
ax.XRuler.Exponent = 0;
title("Velocity over time");

subplot(2,3,3);
plot(t,y(:,1)+y(:,2));
xlabel('Time (s)');
ylabel('Mass (kg)');
ax = gca;
ax.YRuler.Exponent = 0;
ax.XRuler.Exponent = 0;
title("Mass over time");

subplot(2,3,4);
plot(y(:,3),y(:,4));
xlabel('Downrange distance (m)');
ylabel('Altitude (m)');
axis equal;
ax = gca;
ax.YRuler.Exponent = 0;
ax.XRuler.Exponent = 0;
title("Trajectory");

subplot(2,3,5);
plot(t(2:end), diff(velVals)' ./ diff(t) / 9.8066);
xlabel('Time (s)');
ylabel('Acceleration (G)');
ax = gca;
ax.YRuler.Exponent = 0;
ax.XRuler.Exponent = 0;
title("Acceleration over time");

subplot(2,3,6);
massFlow = -diff(y(:,2))./diff(t);
plot(t(2:end), massFlow); % * v_e  + (P_e - P_a) * A_e);
ax = gca;
ax.YRuler.Exponent = 0;
ax.XRuler.Exponent = 0;


