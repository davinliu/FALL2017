%% Extracting oil
% Price: P
% Oil reservoir stock: W^i
% Discount factor: beta
% Transition: W^i_t+1 = W^i_t - e^i_t
% Cost: e^i_t^2
% Optimally extract oil from n identical reservoirs
clear all

% Parameterize the model
initial_oil = 500; % 500 thousands of barrels
price = 30; % 30 thousands of dollars
beta = .95;
tolerance = 1e-4;
n = 2; % number of reservoirs

% Initialize the domain
oilmax = initial_oil;
oilmin = 0;

% Define function space
degree = 10;
fspace = fundefn('cheb', degree*ones(1,n), oilmin*ones(1,n), oilmax*ones(1,n));
grid = funnode(fspace);
grid = gridmake(grid);

% Set initial guess
extraction = grid/2;

% Initialize
coeffs = zeros(size(grid,1),1);
val_old = coeffs(:,1);
its = 1;
error = 50000;

% Perform value function iteration
while (error > tolerance) && its < 1000
    % Parallelize
    parfor pt = 1:length(grid)
        [extract_new(pt,:), val_new(pt,:)] = maxbell(extraction(pt,:), grid(pt,:),...
            beta, price, coeffs, fspace);
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
extract_trajectory = zeros(time_horizon,n);
extract_start = 50*ones(1,n);
oil_level = zeros(time_horizon+1,n);
oil_level(1,:) = initial_oil;

% Simulate by solving the Bellman, calculating next period's state and
% looping
for t = 1:time_horizon
    extract_trajectory(t,:) = maxbell(extract_start, oil_level(t,:), beta, price,...
        coeffs, fspace);
    oil_level(t+1,:) = oil_level(t,:) - extract_trajectory(t,:);
    extract_start = oil_level(t+1,:)/2;
end
plot(1:time_horizon,extract_trajectory); hold on;
plot(1:time_horizon+1,oil_level);