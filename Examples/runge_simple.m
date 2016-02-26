clear
% Number of points
N = 10; 
% Switch for cheb vs evenly spaced
cheb = 1; 

% Runge function
f = @(x) 1./(1+25*x.^2);
x  = linspace(-1,1,500);
y_true = f(x);

plot(x,y_true, 'r', 'linewidth', 2);
hold on;

% Generate Chebyshev nodes
fspace = fundef({'cheb',N+1,-1,1});
nodes = funnode(fspace);

% Evenly spaced nodes
xdata = linspace(-1,1,N+1);

% Generate y values
if cheb
    ydata = f(nodes);
else
    ydata = f(xdata);
end

% Fit to y-values
if cheb
    p = polyfit(nodes,ydata,N);
else
    p = polyfit(xdata,ydata,N);
end
y_fit = polyval(p,x);

% Plot
plot(x,y_fit,'g','linewidth',2);
if cheb
    plot(nodes,ydata,'k.', 'markersize', 30);
else
    plot(xdata,ydata,'k.', 'markersize', 30);
end
