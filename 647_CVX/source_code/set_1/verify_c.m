% constrained: (c)

% run p1_c.m before running this code

% basically we got x_opt_d = (1.2857, 0.8571) using p1_d.m
% KKT check process is the same as (d)
% so here i try to just check convergence

x_opt_c; x_sub_opt;
obj_opt_c; obj_sub_opt;
% x_opt_d = [1.2857, 0.8571];
tolerance = 1e-6;
c1_c = 3 - 2*x_opt_c(1) - x_opt_c(2);
c2_c = 3 - x_opt_c(1) - 2*x_opt_c(2);

% Obviously, the following two conditions are met
primal_feasible_c = all(x_opt_c >= 0) && (2*x_opt_c(1) + x_opt_c(2) >= 3) && (x_opt_c(1) + 2*x_opt_c(2) >= 3);
primal_con_feasible_c = (c1_c <= tolerance) && (c2_c <= tolerance);

% here check convergence
is_convergence = (obj_opt_c - obj_sub_opt) <= tolerance;
is_optimal_c = primal_feasible_c && primal_con_feasible_c && is_convergence;

if is_optimal_c == 1
    fprintf('Condition is satisfied: correct optimal solution.')
else
    fprintf('Condition is not satisfied: wrong.')
end