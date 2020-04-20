function guess = gradientOptim(optimFn, step, tol, steps, initialGuess)

        guess = initialGuess;
        for i = 1:steps
            error = optimFn(guess);
            if isnan(error)
                error = rand();
            end  

            %fprintf("%.2f %.2f\n", guess, error);
            guess = guess - error * step;

            if abs(error) < tol
               break 
            end
        end
end