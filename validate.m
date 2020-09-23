function x_est = validate(F, x, u)
    % Function used to validate the identified nonlinear system.
    
    x_est = [];                             % Vector for estimated states
    x_est = cat(1, x_est, x(1,:));          % Add actual initial condition
    
    current_state = x(1, :);                % Set current state to IC
    for i = 1:size(x,1)
        [psi, ~, ~] = lift(current_state, current_state, u(i,:));   % Lift current state
        psi_next = F * psi;                                       % Calculate next lifted state
        next_state = [psi_next(1), psi_next(3), psi_next(6)];       % Recover state
        x_est = cat(1, x_est, next_state);                          % Add next state to vector
        current_state = next_state;                                 % Set current state
    end

end