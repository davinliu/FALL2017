function nloglikelihood = loglike(Y,X,rho)
    % Coefficients
    beta = rho(1:4);
    
    % Ensure positive variance guesses, will have to re-transform the
    % maximizing guess in the main_script
    sigma2 = exp(rho(5));
    
    % Residual in equation
    residual = Y - X*beta;
    
    % Negative log likelihood of normal
    nloglikelihood = normlike([0, sigma2], residual);
    
end