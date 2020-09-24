function [psi_x, psi_y, dpsi, normalize_factors] = lift_data(x, u)
    % Purpose of this function is to lift the entire sequence of data from
    % the simulation into Koopman space and return the psi vectors (Eq. 16)
    
    psi_x = [];                     % Input psi vector (Eq. 16)
    psi_y = [];                     % Output psi vector (Eq.16)
    
    for i = 1:size(x,1)-1
        [psi, psi_next] = lift(x(i,:), x(i+1,:), u(i,:)); % Lift to Koopman space
             
        psi_x = cat(1, psi_x, psi);           % Concatenate input psi
        psi_y = cat(1, psi_y, psi_next);      % Concatenate output psi
  
    end
    
    % For Koopman Operator calculation, we need the dimensions of the psi
    % matrix to agree with the other matrices used in Eq. 21, so we
    % truncate.
    samples = size(psi_x,1);                % Number of rows in psi
    dim = size(psi_x, 2);                   % Number of sim samples
    k = dim*floor(samples/dim);             % Rescaling factor
    
    psi_x = psi_x(1:k,:);                   % Rescale input psi
    psi_y = psi_y(1:k,:);                   % Rescale output psi
    
end