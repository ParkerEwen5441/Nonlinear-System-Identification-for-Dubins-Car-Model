clc
clear all

%% 1. SIMULATION SETUP
% Simulation Parameters
obj.T = 50;                             % Simulation time
obj.dt = 0.01;                          % Sample time
obj.initial_conditions = [0, 0, 0];     % Sim initial condition
obj.velocity_limit = 1;                 % Limit for velocity input
obj.omega_limit = 10;                   % Limit for omega input
obj.seed = 1;                           % Random seed for input generation
     
%% 2. COLLECT DATA
[t, x, u] = simulate(obj);                          % Simulate Dubins Car
plotting('sim_results',x,0,u,obj);                  % Plot sim results

%% 3. LIFT DATA
[psi_x, psi_y, dpsi] = lift_data(x, u);             % Lift data to Koopman space

%% 4. CALCULATE DISCRETE-TIME KOOPMAN OPERATOR 
K = pinv(psi_x) * psi_y;                            % Calculate K (Eq. 17)

%% 5. CALCULATE CONTINUOUS-TIME KOOPMAN OPERATOR
A = 1/obj.dt * logm(K);                             % Calculate A (Eq. 18)

%% 6. CALCULATE NONLINEAR VECTOR FIELD
A_stacked = [];                                     % Make stacked A matrix
for i = 1:size(dpsi,1)/size(dpsi,2)
    A_stacked = cat(1, A_stacked, A);
end
F = pinv(dpsi) * A_stacked;                         % Calculate F (Eq. 21)

%% 7. VALIDATE
x_est = validate(K, x, u);                          % Rerun sim using F
plotting('validate_results', x, x_est, u, obj)      % Plot validation results

