function [m, L, Vp] = pressureTank(Vf, Vo, P, Pp, R, gamma)
    eq = @(a, b, c) a * b^c;
    
    optimFn = @(x) (eq(Pp, x(1), gamma) - eq(P, x(1) + Vf + Vo, gamma)).^2;
    
    if exist("fsolve", "builtin")
        options = optimoptions('fsolve','Display', 'off', 'Diagnostics', 'off','MaxFunctionEvaluations', 500, 'MaxIterations',500, 'StepTolerance', 1e-6);
        options.Algorithm = "interior-point";
        options = optimoptions('fsolve');
        Y = fsolve(optimFn, [(Vf + Vo)], options);

        Vp = Y(1);
    else
        guess = gradientOptim(optimFn, 1e-12, 1e-12, 100, Vf + Vo);
        Vp = guess; %Y(1);
    end
    
%     options = optimoptions('fsolve','Display', 'off', 'Diagnostics', 'off','MaxFunctionEvaluations', 500, 'MaxIterations',500, 'StepTolerance', 1e-6);
    %options.Algorithm = "interior-point";
    %options = optimoptions('fsolve');
%     Y = fsolve(optimFn, [(Vf + Vo)], options);
    
    % Vp = Y(1);
        
    L = (Vp - 4/3 * pi * R.^3) ./ (R.^2 * pi);
 
    m = 2300 * R.^2 * (R + L);
end