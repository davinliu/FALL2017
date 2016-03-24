function [extract_new, val_new] = maxbell(extraction, oil_stock,...
    beta, price, coeffs, fspace)

% Define anonymous function for maximization
value_handle = @(extraction) value_function(extraction, oil_stock,...
     beta, price, coeffs, fspace);

% Turn off display
options = optimset('display','off');

% Send to fmincon, can't extract more oil than you have
[extract_new, val_new] = fmincon(value_handle, [extraction],...
    [], [], [], [], zeros(size(oil_stock)), [oil_stock], [], options);

end