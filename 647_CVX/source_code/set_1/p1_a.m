clc; clear; close all;
[x1, x2] = meshgrid(linspace(-5, 5, 100), linspace(-5, 5, 100));
obj_1 = f0(x1, x2);
figure;
subplot(2,2,1);
mesh(x1, x2, obj_1);
xlabel('x_1');
ylabel('x_2');
zlabel('f0(x_1, x_2)');

x0 = [0,0];
directions = rand(3,2);
t = linspace(-5, 5, 100);

for i = 1:3
    d = directions(i,:);
    x1_t = x0(1) + t*d(1);
    x2_t = x0(2) + t*d(2);
    f_t = f0(x1_t, x2_t);

    subplot(2,2,i+1);
    plot(t, f_t, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('f(t)')
    title(['d' num2str(i) ' = (' num2str(d(1), '%.2f') ', ' num2str(d(2), '%.2f') ')']);
end
