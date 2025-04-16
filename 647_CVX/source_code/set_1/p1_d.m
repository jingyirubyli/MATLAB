clc; clear; close all;
lr_s = 0.001;
lr_m = 0.1;
lr_r = 0.5;
gammas = [lr_s, lr_m, lr_r];
iters = 500;

[x1, x2]=meshgrid(linspace(-2,2,100), linspace(-2,2,100));
z=f0(x1,x2);

% % L(x,lambda) = f0(x) + lambda1*(3- 2*x1 - x2) + lambda2*(3 - x1 - 2*x2)
% % dL/dx1 = 2*x1 + 3*x2 + 2 - 2*lambda1 - lambda2 = 0
% % dL/dx2 = 3*x1 + 18*x2 - 5 - lambda1 - 2*lambda2 = 0

function x = primal_sol(lambda)
    A=[2,3;3,18];
    b=[2*lambda(1) + lambda(2) - 2; lambda(1) + 2*lambda(2) + 5];
    x=A\b;
    x=max(x,0); 
end

function g = dual_gradient(lambda)
    x = primal_sol(lambda);
    g = [3 - 2*x(1) - x(2); 3 - x(1) - 2*x(2)];
    g = -g;
end

for i=1:3
    gamma=gammas(i);
    lambda=[2;0];
    x=primal_sol(lambda);
    trajectory=x';
    lambda_trajectory=lambda';

    for k=1:iters
        g=dual_gradient(lambda);
        lambda_new=lambda-gamma*g;
        lambda_new=max(lambda_new,0);
        lambda=lambda_new;
        x=primal_sol(lambda);
        trajectory=[trajectory;x'];
        lambda_trajectory=[lambda_trajectory;lambda'];
    end

    subplot(4, 3, i);
    plot(0:iters, trajectory(:, 1), 'LineWidth', 1.5);
    hold on;
    plot(0:iters, trajectory(:, 2), 'LineWidth', 1.5);
    xlabel('Iterations (k)');
    ylabel('Primal solutions');
    title(['\gamma = ', num2str(gamma)]);
    legend('x_1(k)', 'x_2(k)');
    grid on;

    subplot(4, 3, i+3);
    plot(0:iters, lambda_trajectory(:, 1), 'LineWidth', 1.5);
    hold on;
    plot(0:iters, lambda_trajectory(:, 2), 'LineWidth', 1.5);
    xlabel('Iterations (k)');
    ylabel('Dual lambda value');
    title(['\gamma = ', num2str(gamma)]);
    legend('lambda_1(k)', 'lambda_2(k)');
    grid on;

    subplot(4, 3, i+6);
    contour(x1, x2, z, 20);
    hold on;

    x1_line = 0:0.1:3;
    x2_c1 = 3 - 2*x1_line;
    x2_c2 = (3 - x1_line)/2;
    plot(x1_line, x2_c1, 'r--', 'LineWidth', 1.5);
    plot(x1_line, x2_c2, 'g--', 'LineWidth', 1.5);
    
    A = [2, 1; 1, 2];
    b = [3; 3];
    intersection = A\b;
    vertices = [intersection'; [3, 0]; [0, 3]];
    fill(vertices(:,1), vertices(:,2), 'blue', 'FaceAlpha', 0.2);

    plot(trajectory(:,1), trajectory(:,2), 'b-o', 'LineWidth', 1.5, 'MarkerSize', 3);
    plot(trajectory(1,1), trajectory(1,2), 'go', 'MarkerSize', 6, 'LineWidth', 2); % Start
    plot(trajectory(end,1), trajectory(end,2), 'ro', 'MarkerSize', 6, 'LineWidth', 2); % End

    subplot(4, 3, i+9);
    mesh(x1, x2, z);
    hold on;
    
    traj_z = zeros(size(trajectory, 1), 1);
    for j = 1:size(trajectory, 1)
        traj_z(j) = f0(trajectory(j,1), trajectory(j,2));
    end
    plot3(trajectory(:,1), trajectory(:,2), traj_z, 'r-o', 'LineWidth', 1.5, 'MarkerSize', 3);
    
    xlabel('x_1');
    ylabel('x_2');
    zlabel('f(x_1, x_2)');
    title(['3D Trajectory with \gamma = ', num2str(gamma)]);
    grid on;

end

fprintf('For gamma = %.3f, optimal (x1, x2) = (%.4f, %.4f), f(x) = %.4f\n', ...
        gamma(end), trajectory(end,1), trajectory(end,2), f0(trajectory(end,1), trajectory(end,2)));

x_opt_d = [trajectory(end,1),trajectory(end,2)];
lambda_opt_d = [lambda_trajectory(end,1),lambda_trajectory(end,2)];
obj_opt_d = f0(trajectory(end,1),trajectory(end,2));
