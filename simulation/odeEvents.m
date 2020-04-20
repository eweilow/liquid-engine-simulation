function [value,isterminal,direction] = odeEvents(t, y)
    value = [y(2), y(4)];
    isterminal = [0, 1];
    direction = [0, 0];
end

