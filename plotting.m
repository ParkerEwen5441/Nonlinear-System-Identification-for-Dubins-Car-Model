function plotting(type, x, x_est, u, obj, t)
    if contains(type, 'sim_results')
       plot_sim_results(x, u, obj); 
    elseif contains(type, 'validate_results')
        plot_validation_results(x_est, x, t)        
    end

end

function plot_sim_results(x, u, obj)
    figure('Name', 'Dubins Car Simulation Results')
    subplot(2,2,[1,2]);
    plot(x(:,1),x(:,2));
    title('Dubins Car Path')
    xlabel('x [m]')
    ylabel('y [m]')

    subplot(2,2,3);
    velocity = downsample(u(:,1), 100);
    plot(linspace(0,obj.T, length(velocity)), velocity);
    title('Sampled Velocity Inputs')
    xlabel('Time [s]')
    ylabel('Velocity [m/s]')

    subplot(2,2,4);
    omega = downsample(u(:,2), 100);
    plot(linspace(0,obj.T, length(omega)), omega);
    title('Sampled Steering Angle Changes')
    xlabel('Time [s]')
    ylabel('Omega [deg/s]')

end

function plot_validation_results(x_est, x, t)    
    figure('Name', 'Identified System vs Actual System')
    subplot(2,2,[1,2]);
    plot(x(:,1),x(:,2));
    hold on
    plot(x_est(:,1),x_est(:,2));
    title('Dubins Car Path')
    xlabel('x [m]')
    ylabel('y [m]')
    legend('Actual Model', 'Koopman Identified Model')

    subplot(2,2,3);
    plot(t, abs((x_est(:,1)-x(:,1))./x(:,1)*100));
    title('Percentage Error In Time Over X')
    xlabel('Time [s]')
    ylabel('Error [%]')

    subplot(2,2,4);
    plot(t,abs((x_est(:,2)-x(:,2))./x(:,2)*100));
    title('Percentage Error In Time Over Y')
    xlabel('Time [s]')
    ylabel('Error [%]')
end