function plotSimulations(Isp, chosenMassFlow, accLO, accMax, accMin, propellantMass, massFlowMin, massFlowMax, apoapsides, allMassFlows, thrusts, masses, dryMasses, burnTimes)
    goodAcc = 3;

    v_e = Isp * 9.8066;
    
    figure(1);
    clf
    
    ax1 = axes;
    dy = 0.03;
    set(ax1, 'Position', ax1.Position + [0 dy 0 -dy]);
    
    yyaxis left
    data = [allMassFlows; apoapsides];
    data = sortrows(data', 1)';
    
    plot(data(1,:), data(2,:), '-');
    xlim([massFlowMin, massFlowMax]);
    grid on
    ylabel("Maximum altitude [km]");
    xlabel("Thrust [kg/s]");
    title(sprintf("Altitude as function of mass flow. Isp = %.0f s, m_p = %.0f kg", Isp, propellantMass));
    
    
    yyaxis right
    data = [allMassFlows; accLO - 1];
    data = sortrows(data', 1)';
    plot(data(1,:), data(2,:), '--', 'DisplayName', 'Liftoff');
    
    hold on
    data = [allMassFlows; accMax - 1];
    data = sortrows(data', 1)';
    plot(data(1,:), data(2,:), '-', 'DisplayName', 'Maximum');
    
    hold on
    data = [allMassFlows; accMin - 1];
    data = sortrows(data', 1)';
    plot(data(1,:), data(2,:), '-', 'DisplayName', 'Minimum');
    
    hold on
    plot([massFlowMin massFlowMax], [goodAcc goodAcc], '-.', 'DisplayName', 'Target');
    ylim([0, 10]);
    plot([chosenMassFlow chosenMassFlow], ylim, '--')
    ylabel("Acceleration [G]");
    xlabel("Massflow [kg/s]");
    
    %title(sprintf("Altitude as function of mass flow. Isp = %.0f s, m_p = %.0f kg", Isp, propellantMass));
    
    ax2 = axes('Position',ax1.Position,...
        'XAxisLocation','bottom',...
        'YAxisLocation','right',...
        'Color','none',...
        'YColor','none',...
        'XLim', [massFlowMin, massFlowMax] * v_e);
    ax2.GridLineStyle = 'none';
    ax2.Position(2) = ax2.Position(2) - 0.075;
    xlabel(ax2, 'Thrust [N]');
    
    figure(2);
    clf
    
    ax1 = axes;
    dy = 0.03;
    set(ax1, 'Position', ax1.Position + [0 dy 0 -dy]);
    
    yyaxis left
    data = [allMassFlows; burnTimes];
    data = sortrows(data', 1)';
    
    plot(data(1,:), data(2,:), '-');
    ylim([0, 100]);
    xlim([massFlowMin, massFlowMax]);
    grid on
    ylabel("Burn time [s]");
    xlabel("Thrust [kg/s]");
    title(sprintf("Burn time as function of mass flow. Isp = %.0f s, m_p = %.0f kg", Isp, propellantMass));
    
    
    yyaxis right
    data = [allMassFlows; accLO - 1];
    data = sortrows(data', 1)';
    plot(data(1,:), data(2,:), '--', 'DisplayName', 'Liftoff');
    
    hold on
    data = [allMassFlows; accMax - 1];
    data = sortrows(data', 1)';
    plot(data(1,:), data(2,:), '-', 'DisplayName', 'Maximum');
    
    hold on
    data = [allMassFlows; accMin - 1];
    data = sortrows(data', 1)';
    plot(data(1,:), data(2,:), '-', 'DisplayName', 'Minimum');
    
    hold on
    plot([massFlowMin massFlowMax], [goodAcc goodAcc], '-.', 'DisplayName', 'Target');
    ylim([0, 10]);
    plot([chosenMassFlow chosenMassFlow], ylim, '--')
    ylabel("Acceleration [G]");
    xlabel("Massflow [kg/s]");
    %title(sprintf("Altitude as function of mass flow. Isp = %.0f s, m_p = %.0f kg", Isp, propellantMass));
    
    ax2 = axes('Position',ax1.Position,...
        'XAxisLocation','bottom',...
        'YAxisLocation','right',...
        'Color','none',...
        'YColor','none',...
        'XLim', [massFlowMin, massFlowMax] * v_e);
    ax2.GridLineStyle = 'none';
    ax2.Position(2) = ax2.Position(2) - 0.075;
    xlabel(ax2, 'Thrust [N]');
    drawnow
    
    
    figure(3);
    clf
    
    ax1 = axes;
    dy = 0.03;
    set(ax1, 'Position', ax1.Position + [0 dy 0 -dy]);
    
    yyaxis left
    data = [allMassFlows; masses];
    data = sortrows(data', 1)';
    
    plot(data(1,:), data(2,:), '-');
    xlim([massFlowMin, massFlowMax]);
    grid on
    ylabel("Total mass");
    xlabel("Thrust [kg/s]");
    title(sprintf("Rocket mass as function of mass flow. Isp = %.0f s, m_p = %.0f kg", Isp, propellantMass));
    
    
    yyaxis right
    data = [allMassFlows; accLO - 1];
    data = sortrows(data', 1)';
    plot(data(1,:), data(2,:), '--', 'DisplayName', 'Liftoff');
    
    hold on
    data = [allMassFlows; accMax - 1];
    data = sortrows(data', 1)';
    plot(data(1,:), data(2,:), '-', 'DisplayName', 'Maximum');
    
    hold on
    data = [allMassFlows; accMin - 1];
    data = sortrows(data', 1)';
    plot(data(1,:), data(2,:), '-', 'DisplayName', 'Minimum');
    
    hold on
    plot([massFlowMin massFlowMax], [goodAcc goodAcc], '-.', 'DisplayName', 'Target');
    ylim([0, 10]);
    plot([chosenMassFlow chosenMassFlow], ylim, '--')
    ylabel("Acceleration [G]");
    xlabel("Massflow [kg/s]");
    %title(sprintf("Altitude as function of mass flow. Isp = %.0f s, m_p = %.0f kg", Isp, propellantMass));
    
    ax2 = axes('Position',ax1.Position,...
        'XAxisLocation','bottom',...
        'YAxisLocation','right',...
        'Color','none',...
        'YColor','none',...
        'XLim', [massFlowMin, massFlowMax] * v_e);
    ax2.GridLineStyle = 'none';
    ax2.Position(2) = ax2.Position(2) - 0.075;
    xlabel(ax2, 'Thrust [N]');
    drawnow
end