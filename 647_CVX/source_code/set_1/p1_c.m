clc; clear; close all;
lr_s = 0.00001;
lr_m = 0.01;
lr_r = 0.0002;
gammas = [lr_s, lr_m, lr_r];
iters = 10000;

[x1, x2]=meshgrid(linspace(-5,5,100), linspace(-5,5,100));
z=f0(x1,x2);

function x_proj = project_to_constraints(x)
    x = max(x, 0);
    
    c1 = 2*x(1) + x(2) - 3;  % 2x1 + x2 >= 3
    c2 = x(1) + 2*x(2) - 3;  % x1 + 2x2 >= 3
    
    if c1 >= 0 && c2 >= 0
        x_proj = x;
        return;
    end
    
    if c1 < 0 && c2 >= 0
        d = [2; 1];
        d = d / norm(d);
        x_proj = x + d * (-c1);
        x_proj = max(x_proj, 0);
        return;
    end
    
    if c2 < 0 && c1 >= 0
        d = [1; 2];
        d = d / norm(d);
        x_proj = x + d * (-c2);
        x_proj = max(x_proj, 0);
        return;
    end
    
    d1 = [2; 1];
    d1 = d1 / norm(d1);
    x_proj1 = x + d1 * (-c1);
    x_proj1 = max(x_proj1, 0);
    
    d2 = [1; 2];
    d2 = d2 / norm(d2);
    x_proj2 = x + d2 * (-c2);
    x_proj2 = max(x_proj2, 0);
    
    c1_1 = 2*x_proj1(1) + x_proj1(2) - 3;
    c2_1 = x_proj1(1) + 2*x_proj1(2) - 3;
    
    c1_2 = 2*x_proj2(1) + x_proj2(2) - 3;
    c2_2 = x_proj2(1) + 2*x_proj2(2) - 3;
    
    if c1_1 >= 0 && c2_1 >= 0
        x_proj = x_proj1;
    elseif c1_2 >= 0 && c2_2 >= 0
        x_proj = x_proj2;
    else

        A = [2, 1; 1, 2];
        b = [3; 3];
        x_proj = A\b;
    end
end

figure;

for i = 1:3
    gamma = gammas(i);
    x = [-2; 0]; 
    trajectory = x';
    
    for k = 1:iters
        grad = df0(x(1), x(2));
        x_new = x - gamma * grad';
        x = project_to_constraints(x_new);
        trajectory = [trajectory; x'];
    end
    
    subplot(3, 3, i);
    plot(0:iters, trajectory(:, 1), 'LineWidth', 1.5);
    hold on;
    plot(0:iters, trajectory(:, 2), 'LineWidth', 1.5);
    xlabel('Iterations (k)');
    ylabel('Value');
    title(['\gamma = ', num2str(gamma)]);
    legend('x_1(k)', 'x_2(k)');
    grid on;
    
    subplot(3, 3, i+3);
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
    fill(vertices(:,1), vertices(:,2), 'cyan', 'FaceAlpha', 0.2);
    
    plot(trajectory(:,1), trajectory(:,2), 'b-o', 'LineWidth', 1.5, 'MarkerSize', 3);
    plot(trajectory(1,1), trajectory(1,2), 'go', 'MarkerSize', 6, 'LineWidth', 2); % Start
    plot(trajectory(end,1), trajectory(end,2), 'ro', 'MarkerSize', 6, 'LineWidth', 2); % End
    
    xlabel('x_1');
    ylabel('x_2');
    axis([0 3 0 3]);
    title(['Trajectory with \gamma = ', num2str(gamma)]);
    grid on;
    
    subplot(3, 3, i+6);
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

    fprintf('For gamma = %.5f, optimal (x1, x2) = (%.4f, %.4f), f(x) = %.4f\n', ...
        gamma, trajectory(end,1), trajectory(end,2), f0(trajectory(end,1), trajectory(end,2)));
end
x_opt_c = [trajectory(end,1),trajectory(end,2)];
x_sub_opt = [trajectory(end-1,1),trajectory(end-1,2)];
obj_opt_c = f0(trajectory(end,1),trajectory(end,2));
obj_sub_opt = f0(trajectory(end-1,1),trajectory(end-1,2));
sgtitle('Gradient Projection Method for Convex Optimization');