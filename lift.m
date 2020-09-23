function [psi, psi_next, dpsi] = lift(x, y, u)
    % Function to lift a given data point x and u (along with its output y)
    % into Koopman space. Basis for Koopman space shown below:
    %
    % basis = [x1, x1^2, x2, x1x2, x2^2, x3, x1x3, x2x3, x3^2, sinx3, x1sinx3, x2sinx3, x3sinx3, sin^2x3,
    %          u1, x1u1, x2u1, x3u1, u1sinx3, u1^2, u2, x1u2, x2u2, x3u2, u2sinx3, u1u2, u2^2]
    %
    % In addition, we need the derivative of the lifted data used in Eq 21
    % to calculate the nonlinear vector field. The Jacobian for the basis
    % is calculated analytically ans shown below:
    %
    % dpsi = [1 2*x(1) 0 x(2) 0 0 x(3) 0 0 0 sin(x(3)) 0 0 0 0 u(1) 0 0 0 0 0 u(2) 0 0 0 0 0;
    %         0 0 1 x(2) 2*x(2) 0 0 0 x(3) 0 0 0 sin(x(3)) 0 0 0 0 u(1) 0 0 0 0 0 u(2) 0 0 0;
    %         0 0 0 0 0 1 x(1) x(2) 2*x(3) cos(x(3)) x(1)*cos(x(3)) x(2)*cos(x(3)) sin(x(3))+x(3)*cos(x(3)) 2*sin(x(3))cos(x(3)) 0 0 0 u(1) u(1)*cos(x(3)) 0 0 0 0 u(2) u(2)*cos(x(3)) 0 0];

    % Set up basis coefficients for monomials
    [X1,X2,X3,X4,X5,X6] = ndgrid(0:2);
    basis = [X1(:),X2(:),X3(:),X4(:),X5(:),X6(:)];
    basis(sum(basis,2)>2,:) = [];
    basis(sum(basis,2) == 0,:) = [];
    
    % Get psis to calculate Koopman Operator (Eq. 16)
    psi = x(1).^basis(:,1) .* x(2).^basis(:,2) .* x(3).^basis(:,3) .* sin(x(3)).^basis(:,4) .* u(1).^basis(:,5) .* u(2).^basis(:,6);
    psi_next = y(1).^basis(:,1) .* y(2).^basis(:,2) .* y(3).^basis(:,3) .* sin(y(3)).^basis(:,4) .* u(1).^basis(:,5) .* u(2).^basis(:,6);
    
    % Get analytical Jacobian for psi used in Eq. 21 
    dpsi = [1 2*x(1) 0 x(2) 0 0 x(3) 0 0 0 sin(x(3)) 0 0 0 0 u(1) 0 0 0 0 0 u(2) 0 0 0 0 0;
            0 0 1 x(2) 2*x(2) 0 0 0 x(3) 0 0 0 sin(x(3)) 0 0 0 0 u(1) 0 0 0 0 0 u(2) 0 0 0;
            0 0 0 0 0 1 x(1) x(2) 2*x(3) cos(x(3)) x(1)*cos(x(3)) x(2)*cos(x(3)) sin(x(3))+x(3)*cos(x(3)) 2*sin(x(3))*cos(x(3)) 0 0 0 u(1) u(1)*cos(x(3)) 0 0 0 0 u(2) u(2)*cos(x(3)) 0 0];
        
end