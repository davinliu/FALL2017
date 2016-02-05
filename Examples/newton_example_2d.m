% Solve 2-firm cournot model with:
% C(q_i) = 0.5*c_i*q_i^2 for i = 1,2
% P(Q) = Q^(-1/eta)

c = [0.6; 0.8];
eta = 1.6;
e = -1/eta;

tol = 1e-5;
maxit = 1000;
q = [1; 1];

for i = 1:maxit
    fval = sum(q)^e + e*sum(q)^(e-1)*q - diag(c)*q;
    fjac = e*sum(q)^(e-1)*ones(2,2) + e*sum(q)^(e-1)*eye(2) + ...
        (e-1)*e*sum(q)^(e-2)*q*[1 1] - diag(c);
    q = q - fjac\fval;
    if norm(fval) < tol
        break
    end
end

disp(['Converged to solution q = ' mat2str(q,4) ' in ' num2str(i) ' iterations.']);