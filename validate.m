function x_est = validate(F, x, u, time)
    % Function used to validate the identified nonlinear system.
      
    x0 = x(1,:);
    tResult = [];
    xResult = [];
    for i = 2:size(x,1)
        % simulate nonlinear model
        af   = @(t,x) f(F, x, u(i,:));             % Call ode45 for new inputs
        tStep = time(i-1:i);                    % Get time for new ode45 calculation
        [t, psi] = ode45(af, tStep, x0);           % Solve ODE at timestep
        
        x_next = [psi(end, 1), psi(end, 2), psi(end, 3)];
        
        tResult = cat(1, tResult, t(end));              % Concatenate time results
        xResult = cat(1, xResult, x_next);              % Concatenate state results
        x0 = x_next;
    end
    
    x_est = xResult;
end

function dx = f(F, x, u)
    % System representing Dubins' car.
    [psi, ~] = lift(x, x, u);
    dx = F * psi.';
end