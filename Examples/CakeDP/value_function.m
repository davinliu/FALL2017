function util = value_function(consumption, cakesize, beta,...
    coeffs, fspace)

% Tomorrows state: cake size
cakesize_tomorrow = cakesize - consumption;

% Get continuation value given tomorrow's state
cont_value = funeval(coeffs, fspace, cakesize_tomorrow);

% Right hand side of the Bellman
util = -(-1/consumption + beta*cont_value);


end