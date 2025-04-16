Num_Links=12;
Num_Flows=7;
Max_Links_On_Path=4;

Link_Capacity=[1.0 1.0 1.0 1.0 1.0 1.0 2.0 2.0 2.0 2.0 2.0 2.0];
Flow_Weight=[1.0 1.0 1.0 1.0 2.0 2.0 2.0];

Flow_Path=[ [3 9 -1 -1]; ...
    [4 9 -1 -1]; ...
    [3 10 -1 -1]; ...
    [4 10 -1 -1]; ...
    [5 8 -1 -1]; ...
    [5 9 -1 -1]; ...
    [1 6 11 -1]];

G = zeros(Num_Links, Num_Flows);
for i = 1:Num_Flows
    for j = 1:Max_Links_On_Path
        link = Flow_Path(i,j);
        if link ~= -1
            G(link, i) = 1;
        end
    end
end

flow_links = cell(Num_Flows, 1);
for i = 1: Num_Flows
    path = Flow_Path(i,:);
    flow_links{i} = path(path ~= -1);
end

% I have check several other values of gamma and iter, trun out not indeed optimal.
% for example, if set iter = 500, output is incorrect.
gamma = 0.1;
iter = 1000; 
lambda = ones(Num_Links, 1);
x_trajectory = zeros(iter, Num_Flows);
lambda_trajectory = zeros(iter, Num_Links);
tol = 1e-6;
for t = 1:iter
    x = zeros(Num_Flows, 1);
    for i = 1:Num_Flows
        sum_lambda = sum(lambda(flow_links{i}));
            x(i)=Flow_Weight(i)/sum_lambda;
    end

    total_flow = G *x;
    lambda = max(lambda+gamma*(total_flow - Link_Capacity'), 0);

    x_trajectory(t,:)=x';
    lambda_trajectory(t,:)=lambda';

end

figure;
subplot(2,1,1);
plot(1:iter, x_trajectory, 'LineWidth', 1.5);
title('Flow Rate');
xlabel('iterations k');
ylabel('flow rate');
legend('flow 1', 'flow 2', 'flow 3','flow 4', 'flow 5', 'flow 6', 'flow 7');

subplot(2,1,2);
plot(1:iter,lambda_trajectory, 'LineWidth', 1.5);
title('Dual variable \lambda');
xlabel('iterations k');
ylabel('\lambda');
legend('link 1', 'link 2', 'link 3','link 4', 'link 5', 'link 6', 'link 7', 'link 8', 'link 9','link 10', 'link 11', 'link 12');

% KKT
% also see in verify_p2.m

x_opt = x_trajectory(end,:)';
lambda_opt = lambda_trajectory(end,:)';

total_flow_opt = G * x_opt;
primal_feasible = all(total_flow_opt <= Link_Capacity'+tol);
dual_feasible = all(lambda_opt>=0);
complement_feasible = all(abs(lambda_opt .* (total_flow_opt - Link_Capacity'))< tol);
stationary = true;
for i = 1:Num_Flows
    sum_lambda = sum(lambda_opt(flow_links{i}));
    if abs(x_opt(i)-Flow_Weight(i)/sum_lambda)>tol
        stationary = false;
        break;
    end
end

fprintf('Primal Feasible: %d\n', primal_feasible);
fprintf('Dual Feasible: %d\n', dual_feasible);
fprintf('Complementary Slackness: %d\n', complement_feasible);
fprintf('Stationarity: %d\n', stationary);

if all(primal_feasible && dual_feasible && complement_feasible && stationary)==1
    fprintf('KKT conditions satisfied. Optimal.\n')
end

