function [cons_new, val_new] = maxbell(consumption, cakesize, beta, coeffs, fspace)

% Define anonymous function for maximization
value_handle = @(consumption)value_function(consumption, cakesize, beta,...
    coeffs, fspace);

% Turn off display
options = optimset('display','off');

% Send to fmincon, can't consume more cake than you have
[cons_new, val_new] = fmincon(value_handle, consumption,...
    [], [], [], [], [], cakesize, [], options);

end