%% Eating Cake
% Utility: log(c_t)
% Cake size: W_t
% Discount factor: beta
% Transition: W_t+1 = W_t - c_t

clear

% Parameterize the model
initial_cake = 100;
beta = .90;
tolerance = 1e-7;

% Initialize the domain
cakemax = initial_cake;
cakemin = 0;

% Define function space
degree = 10;
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

% Perform value function iteration
while (error > tolerance) && its < 1000
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

% Simulate a solution, any error is because you have reached 0 (numerical
% not analytic) cake
time_horizon = 25;
cons_trajectory = zeros(time_horizon,1);
cons_start = 50;
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