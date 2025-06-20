function [L,R,errors] = OPSA(y,As,d,alpha,lambda,max_iter,thresh_up,thresh_low,X_star,loss_star)
% This version uses Polyak stepsizes
errors = zeros(1,max_iter);
[n1,n2] = size(As{1});
m = size(As,1);

%% Spectral Initialization
Y = zeros(n1, n2);
[~, loc_y] = mink(abs(y), ceil(m*(1-alpha))); 
for k = loc_y'
    Y = Y + y(k)*As{k};
end
Y = Y*m; 
[U0, Sigma0, V0] = svds(Y, d);
L = 2  *U0*sqrt(Sigma0);
R = 1/2*V0*sqrt(Sigma0);

%% Main Loop
for t = 1:max_iter % This version uses "thresh_low=5e-15" as early stopping condition which usually cannot be achieved. Change thresh_low to a larger value if desired.
    X = L*R';
    error = norm(X - X_star, 'fro')/norm(X_star, 'fro'); % X_star is only used for reporting the error
    errors(t) = error;

    fprintf('OPSA: Iteration %d,: error: %e, d: %d\n', t, error, d);
    if ~isfinite(error) || error > thresh_up || error < thresh_low
        break;
    end

    loss = 0;
    Z = zeros(n1, n2);
    for k = 1:m
        z = As{k}(:)'*X(:) - y(k);
        loss = loss + abs(z);
        Z = Z + sign(z)*As{k};
    end

    ZL  = Z'*L;
    ZLinv = (ZL)/(L'*L+lambda*eye(d));
    ZR  = Z*R; 
    ZRinv = (ZR)/(R'*R+lambda*eye(d));
    eta = (loss - loss_star)/(ZL(:)'*ZLinv(:) + ZR(:)'*ZRinv(:));
    L   = L - eta*ZRinv;
    R   = R - eta*ZLinv;
end

end

