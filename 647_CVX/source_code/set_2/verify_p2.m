% KKT

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
