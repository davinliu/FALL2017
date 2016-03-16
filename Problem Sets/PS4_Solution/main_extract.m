%% Extracting oil
% Price: P
% Oil reservoir stock: W
% Discount factor: beta
% Transition: W_t+1 = W_t - e_t
% Cost: e_t^2

clear all

% Parameterize the model
initial_oil = 500; % 500 thousands of barrels
price = 30; % 30 thousands of dollars
beta = .95;
tolerance = 1e-4;

% Initialize the domain
oilmax = initial_oil;
oilmin = 0;

% Define function space
degree = 4;
fspace = fundefn('cheb', degree, oilmin, oilmax);
grid = funnode(fspace);
grid = gridmake(grid);

% Set initial guess
extraction = grid/2;

% Initialize
coeffs = zeros(size(grid));
val_old = coeffs;
its = 1;
error = 50000;

% Perform value function iteration
while (error > tolerance) && its < 1000
    for pt = 1:length(grid)
        [extract_new(pt,:), val_new(pt,:)] = maxbell(extraction(pt), grid(pt),...
            beta, price, initial_oil, coeffs, fspace);
    end
    % Update guesses
    extraction = extract_new;
    coeffs = funfitxy(fspace, grid, -val_new);
    
    error = max(abs(val_new-val_old));
    val_old = val_new;
    its = its+1;
    display(['Iteration ' num2str(its-1) ' solved with error ' num2str(error)]);
end

% Simulate a solution, any error is because you have reached 0 (numerical
% not analytic) oil
time_horizon = 50;
extract_trajectory = zeros(time_horizon,1);
extract_start = 50;
oil_level = zeros(time_horizon+1,1);
oil_level(1) = initial_oil;

% Simulate by solving the Bellman, calculating next period's state and
% looping
for t = 1:time_horizon
    extract_trajectory(t,1) = maxbell(extract_start, oil_level(t), beta, price,...
        initial_oil, coeffs, fspace);
    oil_level(t+1) = oil_level(t) - extract_trajectory(t,1);
    extract_start = oil_level(t+1)/2;
end
plot(1:time_horizon,extract_trajectory); hold on;
plot(1:time_horizon+1,oil_level);