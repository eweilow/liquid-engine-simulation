function yPrim = odeSolve(~, y, thrustAngle, frontalArea, v_e, P_e, A_e, mdot)
    h = 1 + abs(y(4));
    
    v = sqrt(y(5)^2 + y(6)^2);
    vNorm = [y(5) y(6)]./v;
    % Cd = 0.2;
    
    mass = y(1) + y(2);
    
    g = gravityAtAltitude(h);
    rho = airDensityAtAltitude(h);
    P_a = airPressureAtAltitude(h);
        
    [~, ~, Mfn, CdFn] = dragCoefficient();
    Cd = CdFn(Mfn(v, h));
    drag = Cd * 0.5 * rho * v^2 * frontalArea / mass;
    
    throttle = y(2) > 0;
    flow = throttle * mdot;
    thrust = throttle * (v_e * mdot);
    
    
    angle = 90;
    if v > 35
        angle = thrustAngle;
    else
        if v > 25
            angle = 90 + (thrustAngle - 90) * min(1, max(0, v - 25)/35);
        end
    end
    thrustRadian = angle / 180 * pi;
    
    yPrim = [
        0 
        -flow
        y(5) 
        y(6)
        -vNorm(1)*drag + cos(thrustRadian) * thrust / mass
        -g - vNorm(2)*drag + sin(thrustRadian) * thrust / mass
    ];
end

