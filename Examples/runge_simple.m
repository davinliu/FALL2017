clear
N = 10; % Number of points
cheb = 1; %switch for cheb
f = @(x) 1./(1+25*x.^2);
x  = linspace(-1,1,500);
y_true = f(x);

plot(x,y_true, 'r', 'linewidth', 2);
hold on;


fspace = fundef({'cheb',N+1,-1,1});
nodes = funnode(fspace);
xdata = linspace(-1,1,N+1);
if cheb
    ydata = f(nodes);
else
    ydata = f(xdata);
end
if cheb
    p = polyfit(nodes,ydata,N);
else
    p = polyfit(xdata,ydata,N);
end
y_fit = polyval(p,x);

plot(x,y_fit,'g','linewidth',2);
if cheb
    plot(nodes,ydata,'k.', 'markersize', 30);
else
    plot(xdata,ydata,'k.', 'markersize', 30);
end
