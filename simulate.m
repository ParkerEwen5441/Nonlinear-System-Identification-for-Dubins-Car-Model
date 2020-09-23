function [tResult, xResult, u] = simulate(obj)
    % Given parameters,  runs the simulation for Dubins' car:
    %
    %       x = [x, y, theta]       u = [v, omega]
    %                xdot = v*cos(theta)
    %                ydot = v*sin(theta)
    %                thetadot = omega
    
    % Set Variables
    T = obj.T;                          % Total simulation time
    dt = obj.dt;                        % Time step size
    N = T/dt;                           % Number of time samples
    v_lim = obj.velocity_limit;         % Limit for velocity input
    omega_lim = obj.omega_limit;        % Limit for steering angle input
    x0 = obj.initial_conditions;        % Initial conditions for state
    seed = obj.seed;                    % Seed used to gen. random inputs

    % Generate Random Inputs
    rng(seed)                           % Set random seed
	u = rand(N+1,2);                    % Generate rands between 0 and 1
    u(:,1) = v_lim*u(:,1);              % Scale velocity inputs
    u(:,2) = omega_lim*2*(u(:,2)-0.5);  % Scale steering angle inputs
    
    % Generate Time Vector
    time = linspace(0, T, N+1);
    
    % Vectors for Sim Results
    tResult = [];                       % Vector for state solutions
    xResult = [];                       % Vector for time sequence

    % To account for changing inputs during experiment, run ode45 and
    % advance the state using each input across a time interval specified
    % by dt.
    
    tResult = cat(1, tResult, 0);       % Initial datapoint
    xResult = cat(1, xResult, x0);      % Initial datapoint
    for index = 2:numel(time)
        af   = @(t,x) f(x, [u(index,1),u(index,2)]);    % Call ode45 for newe inputs
        tStep = time(index-1:index);                    % Get time for new ode45 calculation
        [t, x] = ode45(af, tStep, x0);                  % Solve ODE at timestep
        
        tResult = cat(1, tResult, t(end));              % Concatenate time results
        xResult = cat(1, xResult, x(end,:));            % Concatenate state results
        
        x0 = x(end, :);                                 % Set IC to current state
    end
    
end

function dx = f(x, u)
    % System representing Dubins' car.
    dx = [u(1)*cos(x(3));
          u(1)*sin(x(3));
          u(2)];
    
end