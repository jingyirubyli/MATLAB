% unconstrained: verify (b)
% first-order optimality condition

% run p1_b.m before running this code

x_opt_b;
grad_b = df0(x_opt_b(1),x_opt_b(2));
tolerance = 1e-6;
if norm(grad)<=tolerance
    fprintf('Condition is satisfied: correct optimal solution.')
else
    fprintf('Condition is not satisfied: wrong.')
end