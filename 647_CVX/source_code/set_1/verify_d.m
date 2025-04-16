% constrained: (d) 
% KKT conditions

% run p1_d.m before running this code

x_opt_d;
lambda_opt_d;
tolerance = 1e-6;
primal_feasible = all(x_opt_d >= -tolerance);
c1_d = 3 - 2*x_opt_d(1) - x_opt_d(2);
c2_d = 3 - x_opt_d(1) - 2*x_opt_d(2);
primal_con_feasible = (c1_d <= tolerance) && (c2_d <= tolerance);

dual_feasible = all(lambda >= -tolerance);

complement_slack1 = abs(lambda(1)*c1_d)<=tolerance;
complement_slack2 = abs(lambda(2)*c2_d)<=tolerance;

grad = df0(x_opt_d(1),x_opt_d(2));

grad_condition = [grad(1) - 2*lambda(1) - lambda(2), grad(2) - 2*lambda(2) - lambda(1)];

stationary = all(abs(grad_condition)<=tolerance);

is_optimal = primal_feasible && primal_con_feasible && dual_feasible && complement_slack1 && complement_slack2 && stationary;
if is_optimal == 1
    check = 'Yes';
else
    check = 'No';
end

fprintf('KKT Verification:\n');
fprintf('1. Primal feasibility: x (%d), constraints (%d)\n', primal_feasible, primal_con_feasible);
fprintf('2. Dual feasibility: lambda (%d)\n', dual_feasible);
fprintf('3. Complementary slackness:(%d) \n', complement_slack1 && complement_slack2);
fprintf('4. Stationarity: (%d) \n',stationary);
fprintf('Solution is optimal:  %s\n', check);

