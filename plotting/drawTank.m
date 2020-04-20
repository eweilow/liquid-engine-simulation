function drawTank(name, R, L, Y)
    thetaBottom = linspace(0, pi, 50);
    thetaTop = linspace(pi, 2*pi, 50);
    
    x = [R*cos(thetaBottom) R*cos(thetaTop) R];
    y = Y + [-R*sin(thetaBottom) (L+R*sin(thetaBottom)) 0] + R;
    
    plot(x,y, 'DisplayName', name);
end