clc; clear; close all;
lr_s = 0.01;
lr_m = 0.5;
lr_r = 0.1;
gammas = [lr_s, lr_m, lr_r];
iters = 100;

[x1, x2]=meshgrid(linspace(-2,2,100), linspace(-2,2,100));
z=f0(x1,x2);

figure;
for i =1:3
    gamma = gammas(i);
    x = [0, 0];
    trajectory = x;

    for k = 1:iters
        grad = df0(x(1),x(2));
        x = x - gamma*grad;
        trajectory = [trajectory; x];
    end

    subplot(3,3,i);
    plot(1:iters, trajectory(2:end,1), 'LineWidth', 1.5);
    hold on;
    plot(1:iters, trajectory(2:end,2), 'LineWidth', 1.5);
    xlabel('iters: k');
    ylabel('trajectory');
    title(['\gamma =', num2str(gamma)]);
    legend('x1(k)','x2(k)');

    subplot(3,3,i+3);
    contour(x1, x2, z);
    hold on;
    plot(trajectory(:,1), trajectory(:,2), 'r', 'LineWidth', 2);
    xlabel('x1');
    ylabel('x2');
    title(['path of \gamma =', num2str(gamma)]);

    plot(trajectory(1,1), trajectory(1,2), 'go', 'MarkerSize', 6, 'LineWidth', 2); % Start
    plot(trajectory(end,1), trajectory(end,2), 'ro', 'MarkerSize', 6, 'LineWidth', 2); % End

    subplot(3,3,i+6);
    mesh(x1, x2, z);
    hold on;
    plot3(trajectory(:,1),trajectory(:,2),f0(trajectory(:,1),trajectory(:,2)), 'r', 'LineWidth', 2);


end
sgtitle('b')
x_opt_b = [x(1),x(2)];
obj_opt_b = f0(x(1),x(2));
fprintf('For gamma = %.2f, optimal (x1, x2) = (%.4f, %.4f)\n', gamma, x(1), x(2))