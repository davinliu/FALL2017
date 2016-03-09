%% Estimate a MLE of a linear function, Y = X*beta + eps

% Number of observations
N = 100;

% Simulate X's
X = mvnrnd([0 0 0], 2*eye(3), N);
X = [ones(N, 1) X];

% True parameter values
true_betas = [0.1, 0.5, -0.3, 0. 2]';

% Simulate errors
epsilons = normrnd(0,true_betas(5),[N,1]);

% Simulate dependent variable
Y = X*true_betas(1:4) + epsilons;

% Initial guess
initial_rhos = [1 1 1 1 1]';

% Define anonymous function for maximization
log_handle = @(rho)loglike(Y,X,rho);

% Minimize negative log likelihood
mle = fminunc(log_handle,initial_rhos);

% Adjust error variance back into regular terms
mle(5) = exp(mle(5));

% OLS estimates of beta's for comparison
ols = (X'*X)\X'*Y;

% Return output
disp(['The estimated coefficients via MLE are ' mat2str(mle(1:4),3),...
    ' and the estimated variance of the error is ' num2str(mle(5))]);
disp(['The estimated coefficients via OLS are ' mat2str(ols(1:4),3)]);
disp(['The true coefficients are ' mat2str(true_betas(1:4),3),...
    ' and the true variance of the error is ' num2str(true_betas(5),3)]);

%% Bootstrap the standard errors

% How many samples
num_samples = 1000;
samples = zeros(num_samples,5);
for b = 1:num_samples
    samples(b,:) = bootstrap_mle(N,X,Y,initial_rhos);
end

% Calculate standard errors
bootstrapSE = std(samples,1);

% Calculate non-parametric p-values
null_dist = samples;
pvalues = zeros(4,1);

% Normalize to zero mean
for i = 1:5
    null_dist(:,i) = null_dist(:,i) - mean(null_dist(:,i));
end

for i = 1:4
    pvalues(i,1) = mean(abs(mle(i))<abs(null_dist(:,i)));
end
