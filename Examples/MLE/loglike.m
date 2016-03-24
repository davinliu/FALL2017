function nloglikelihood = loglike(Y,X,rho)
    % Coefficients
    beta = rho(1:end-1);
    
    % Ensure positive variance guesses, will have to re-transform the
    % maximizing guess in the main_script
    sigma2 = exp(rho(end));
    
    % Residual in equation
    residual = Y - X*beta;
    
    % Negative log likelihood of normal
    nloglikelihood = normlike([0, sigma2], residual);
    
end