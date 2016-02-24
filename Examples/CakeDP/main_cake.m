%% Eating Cake
% Utility: c_t^(1-eta)/(1-eta), eta=2
% Cake size: W_t
% Discount factor: beta
% Transition: W_t+1 = W_t - c_t
% 0 <= c_t <= W_t

clear

% Parameterize the model
initial_cake = 100;
beta = .90;
tolerance = 1e-7;

% Initialize the domain
cakemax = initial_cake;
cakemin = 0;

% Define function space
degree = 12;
fspace = fundefn('cheb', degree, cakemin, cakemax);
grid = funnode(fspace);
grid = gridmake(grid);

% Set initial guess
consumption = grid/2;

% Initialize
coeffs = zeros(size(grid));
val_old = coeffs;
its = 1;
error = 50000;
value_grid = 0:1:cakemax;
% Perform value function iteration
while (error > tolerance) && its < 1000
    value_plot(:,its) = funeval(coeffs, fspace, value_grid');
    for pt = 1:length(grid)
        [cons_new(pt,:), val_new(pt,:)] = maxbell(consumption(pt), grid(pt), beta, coeffs, fspace);
    end
    % Update guesses
    consumption = cons_new;
    coeffs = funfitxy(fspace, grid, -val_new);
    
    error = max(abs(val_new-val_old));
    val_old = val_new;
    its = its+1;
    display(['Iteration ' num2str(its-1) ' solved with error ' num2str(error)]);
end

% Plot value function over iterations
for i = 1:20:size(value_plot,2)
    plot(1:size(value_plot,1),value_plot(:,i));
    hold on;
end

% Simulate a solution, any error is because you have reached 0 (numerical
% not analytic) cake
time_horizon = 25;
cons_trajectory = zeros(time_horizon,1);
cons_start = cakemax/2;
cake_level = zeros(time_horizon+1,1);
cake_level(1) = initial_cake;

% Simulate by solving the Bellman, calculating next period's state and
% looping
for t = 1:time_horizon
    cons_trajectory(t,1) = maxbell(cons_start, cake_level(t), beta, coeffs, fspace);
    cake_level(t+1) = cake_level(t) - cons_trajectory(t,1);
    cons_start = cake_level(t+1)/2;
end
plot(1:time_horizon,cons_trajectory); hold on;
plot(1:time_horizon+1,cake_level);

% Euler error calculation
for t = 1:time_horizon-1
    euler_error(t) = log(abs(beta*(1/cons_trajectory(t+1)^2)./(1/cons_trajectory(t)^2)-1));
end

disp(['Mean and max Euler error: (' num2str(mean(euler_error)), ',' num2str(max(euler_error)), ').']);

disp(['This implies our average loss from numerical error is $1 for every: $' num2str(10^-mean(euler_error),8), ' dollars spent.']);