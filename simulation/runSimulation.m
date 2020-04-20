function [ ...
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
] = runSimulation(...
    mdot, ...
    Isp, ...
    payloadMass, ...
    propellantMass, ...
    fuelRatio, ...
    fuelDensity, ...
    oxidDensity, ...
    presTankPressure, ...
    tankPressure, ...
    tankMassFactor, ...
    gamma, ...
    optimalSkinninessRatio, ...
    optimizeRadius, doPrint...
)
    burnTime = propellantMass / mdot;

    fuelMass = propellantMass / (fuelRatio + 1);
    oxidMass = propellantMass * fuelRatio / (fuelRatio + 1);

    fuelVolume = fuelMass / fuelDensity;
    oxidVolume = oxidMass / oxidDensity;

    tankRadius = 5e-2;
    
    if optimizeRadius
        optimFn = @(r) getSkinniness(fuelVolume, oxidVolume, r, tankPressure, tankMassFactor, presTankPressure, gamma) - optimalSkinninessRatio;

        if exist("fsolve")
            options = optimoptions('fsolve','Display', 'off', 'Diagnostics', 'off','MaxFunctionEvaluations', 500, 'MaxIterations',500, 'StepTolerance', 1e-6);
            % options.Algorithm = "interior-point";
            % options = optimoptions('fsolve');
            Y = fsolve(optimFn, tankRadius, options);

            tankRadius = Y(1);
        else
            guess = gradientOptim(optimFn, 1e-12, 1e-12, 10, tankRadius);
            tankRadius = guess; %Y(1);
        end
    end
    [fuelTankMass, fuelTankLength, oxidTankMass, oxidTankLength, presTankMass, presTankLength, presVolume, totalTankLength, skinninessRatio] = computeSkinniness(fuelVolume, oxidVolume, tankRadius, tankPressure, tankMassFactor, presTankPressure, gamma);

    frontalArea = pi * tankRadius * tankRadius;

    v_e = Isp * 9.8066;
    P_e = 2 * 101300;
    A_e = frontalArea * 0.8;

    mdot = propellantMass / burnTime;

    twr = 20;

    thrust = mdot * v_e;


    engineMass = thrust / (9.82 * twr);

    rStar = 0.05;
    dStar = rStar*2;
    lStar = 2.5;
    mStar = 3;
    mBulkStar = 1;

    tubeMass = mStar * tankRadius / 0.05 * totalTankLength/lStar;
    bulkheadMass = 4 * mBulkStar  * (tankRadius / dStar)^2;
    airframeMass = tubeMass + bulkheadMass;
    dryMass = fuelTankMass + oxidTankMass + presTankMass + engineMass + airframeMass + payloadMass; % plus others
    wetMass = dryMass + propellantMass;
    
    if doPrint
        fprintf("\n")
        fprintf("Skinniness ratio %.2f achieved with radius %.2f cm\n", skinninessRatio, tankRadius * 100);
        fprintf("Total tank length: %.2f cm\n", totalTankLength * 100);
        fprintf("Propellant mass: %.2f kg\n", propellantMass);
        fprintf("Fuel mass: %.2f kg\n", fuelMass);
        fprintf("Oxidizer mass: %.2f kg\n", oxidMass);
        fprintf("Burn time: %.1f s\n", burnTime);
        fprintf("Mass flow: %.1f kg/s\n", mdot);
        fprintf("Thrust: %.0f N\n", thrust);
        fprintf("Engine mass: %.1f kg\n", engineMass);
        fprintf("Fuel tank mass: %.1f kg\n", fuelTankMass);
        fprintf("Oxidizer tank mass: %.1f kg\n", oxidTankMass);
        fprintf("Pressure tank mass: %.1f kg\n", presTankMass);
        fprintf("Airframe mass: %.1f kg\n", airframeMass);
        fprintf("  - tube: %.1f kg\n", tubeMass);
        fprintf("  - bulkheads: %.1f kg\n", bulkheadMass);
        fprintf("Dry mass: %.1f kg\n", dryMass);
    end

    dv = v_e * log((propellantMass + dryMass) / dryMass);

    tspan = [0 1000];
    initial = [ dryMass propellantMass 0 0 0.001 0.1 ];
    thrustAngle = 89;

    solveFn = @(t,y) odeSolve(t,y, thrustAngle, frontalArea, v_e, P_e, A_e, mdot);

    opts = odeset('Events', @odeEvents, 'RelTol', 1e-7, 'AbsTol', 1e-7);

    [t,y] = ode45(solveFn, tspan, initial, opts);
    
    vel = y(:,5:6)';
    vel = sqrt(vel(1,:).^2 + vel(2,:).^2);
    
    acc = diff(vel) ./ diff(t)' / 9.8066;
    
    
    tv = t(2:end)';
    range = tv < (burnTime - 1);
    
    liftoffAcceleration = acc(1);
    maximumAcceleration = max(acc(range));
    minimumAcceleration = min(acc(range));
end

function skinninessRatio = getSkinniness(fuelVolume, oxidVolume, tankRadius, tankPressure, tankMassFactor, presTankPressure, gamma)
    [~, ~, ~, ~, ~, ~, ~, ~, skinninessRatio] = computeSkinniness(fuelVolume, oxidVolume, tankRadius, tankPressure, tankMassFactor, presTankPressure, gamma);
end

function [fuelTankMass, fuelTankLength, oxidTankMass, oxidTankLength, presTankMass, presTankLength, presVolume, totalTankLength, skinninessRatio] = computeSkinniness(fuelVolume, oxidVolume, tankRadius, tankPressure, tankMassFactor, presTankPressure, gamma)
    [fuelTankMass, fuelTankLength] = capsuleTank(fuelVolume, tankRadius, tankPressure, tankMassFactor);
    [oxidTankMass, oxidTankLength] = capsuleTank(oxidVolume, tankRadius, tankPressure, tankMassFactor);
    [presTankMass, presTankLength, presVolume] = pressureTank(fuelVolume, oxidVolume, tankPressure, presTankPressure, tankRadius, gamma);
    
    totalTankLength = tankRadius * 6 + fuelTankLength + oxidTankLength + presTankLength;
    
    skinninessRatio = totalTankLength / (tankRadius*2);
end