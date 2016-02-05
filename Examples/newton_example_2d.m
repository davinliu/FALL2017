% Solve 2-firm cournot model with:
% C(q_i) = 0.5*c_i*q_i^2 for i = 1,2
% P(Q) = Q^(-1/eta)

c = [0.6; 0.8];
eta = 1.6;
e = -1/eta;

tol = 1e-5;
maxit = 1000;
q = [10; 35];

for i = 1:maxit
    q_store(:,i) = q;
    % FOC system
    fval = sum(q)^e + e*sum(q)^(e-1)*q - diag(c)*q;
    % Jacobian
    fjac = e*sum(q)^(e-1)*ones(2,2) + e*sum(q)^(e-1)*eye(2) + ...
        (e-1)*e*sum(q)^(e-2)*q*[1 1] - diag(c);
    % Newton step
    q = q - fjac\fval;
    % Break if within tolerance
    if norm(fval) < tol
        break
    end
end
q_store(:,i+1) = q;
disp(['Converged to solution q = ' mat2str(q,4) ' in ' num2str(i) ' iterations.']);
scatter(q_store(1,:),q_store(2,:),'filled');