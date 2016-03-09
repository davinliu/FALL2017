function samples = bootstrap_mle(N,X,Y,initial_rhos)

    % Bootstrap our sample
    sample_index = datasample(1:N,N);
    X_boot = X(sample_index,:);
    Y_boot = Y(sample_index,:);
    
    % Minimize negative log likelihood on our bootstrapped sample
    samples = fminunc(@(rho)loglike(Y_boot,X_boot,rho),initial_rhos);
    samples(5) = exp(samples(5));
    
end