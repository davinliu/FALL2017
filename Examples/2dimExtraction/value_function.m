function util = value_function(extraction, oil_stock,...
    beta, price, coeffs, fspace)

% Tomorrows state: oil reservoir size
oil_stock_tomorrow = oil_stock - extraction;

% Get continuation value given tomorrow's state
cont_value = funeval(coeffs, fspace, oil_stock_tomorrow);

% Right hand side of the Bellman
util = -(price*(sum(extraction))-sum(extraction.^2) + beta*cont_value);


end