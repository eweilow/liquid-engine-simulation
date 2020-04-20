function storeFigure(name)
    set(gca,'FontSize',14)
    saveas(gcf,sprintf('%s.svg', name))
    saveas(gcf,sprintf('%s.png', name))
    %clf
    
    fprintf("Saved to %s.png\n", name);
end

