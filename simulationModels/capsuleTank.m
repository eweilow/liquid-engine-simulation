function [m, L, R] = capsuleTank(V, R, P, rhoOverSigma)
    L = (V - 4/3 * pi * R.^3) ./ (R.^2 * pi);
    m = 2 * pi * R.^2 .* (R + L) * P * rhoOverSigma;
end