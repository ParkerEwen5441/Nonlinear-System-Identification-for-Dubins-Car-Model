clc
clear all
close all

%% 1. SIMULATION SETUP
% Simulation Parameters
obj.T = 25;                             % Simulation time
obj.dt = 0.01;                          % Sample time
obj.initial_conditions = [10, -5, 2];     % Sim initial condition
obj.velocity_limit = 1;                 % Limit for velocity input
obj.omega_limit = 10;                   % Limit for omega input
obj.seed = 1;                           % Random seed for input generation
     
%% 2. COLLECT DATA
[t, x, u] = simulate(obj);                          % Simulate Dubins Car
plotting('sim_results',x,0,u,obj,t);                  % Plot sim results

%% 3. LIFT DATA
[psi_x, psi_y] = lift_data(x, u);                   % Lift data to Koopman space

%% 4. CALCULATE DISCRETE-TIME KOOPMAN OPERATOR 
% K = pinv(psi_x) * psi_y;                          % Calculate K (Eq. 17)
K = lsqminnorm(psi_x,psi_y);                        % Calculate K (Eq. 17)

%% 5. CALCULATE CONTINUOUS-TIME KOOPMAN OPERATOR
A = 1/obj.dt * logm(K);                             % Calculate A (Eq. 18)

%% 6. CALCULATE NONLINEAR VECTOR FIELD
% Get analytical Jacobian for psi at initial condition
dpsi_dx = [1, 0, 0, 0, 0, 2*x(1,1), x(1,2), 0, x(1,3), 0, 0, u(1,1), 0, 0, 0, u(1,2), 0, 0, 0, 0;
            0, 1, 0, 0, 0, 0, x(1,1), 2*x(1,2), 0, x(1,3), 0, 0, u(1,1), 0, 0, 0, u(1,2), 0, 0, 0;
            0, 0, 1, 0, 0, 0, 0, 0, x(1,1), x(1,2), 2*x(1,3), 0, 0, u(1,1), 0, 0, 0, u(1,2), 0, 0];
        
F = dpsi_dx.' \ A.';                                % Calculate F (Eq. 21)

%% 7. VALIDATE
x_est = validate(F, x, u, t);                       % Rerun sim using F
plotting('validate_results', ...                    % Plot validation results
         x(1:700,:), ...
         x_est(1:700,:), ...
         u(1:700,:), ...
         obj,...
         t(1:700));
