function rho = airDensityAtAltitude(h)
    [~,~,~, rho] = atmosisa(h);
    
    for i = 1:length(h)
        if h(i) > 20000
            rho(i) = rho(i) * max(0, 1-((h(i)-20000)/100000));
            %rho = rho * ((h-20000)/100000);
        end
    end
end