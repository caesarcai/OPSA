% Test OPSA with different kappa (condition number) values
clear; close all; clc; 
rng(1);
kappa_list = [20, 40, 60, 80, 100];  % Use "kappa_list = [100];" if only want to run OPSA for one kappa value
n1 = 100;
n2 = n1;
r = 10;
d = 2*r;
m = 8*sqrt(n1*n2)*r;
ps = 0.1; % Outlier rate
kappa = 100;

max_iter = 2500;  
thresh_up = 1e3; thresh_low = 5e-15;
errors_ScaledSM = zeros(length(kappa_list), max_iter);
errors_OPSA = zeros(length(kappa_list), max_iter);

U_seed = sign(rand(n1, r) - 0.5);
[U_star, ~, ~] = svds(U_seed, r);
V_seed = sign(rand(n2, r) - 0.5);
[V_star, ~, ~] = svds(U_seed, r);
As = cell(m, 1);
for k = 1:m
	As{k} = 1/m * randn(n1, n2);
end
outlier_seed = 2*rand(m, 1) - 1;
outlier_support_seed = rand(m, 1);
for i_kappa = 1:length(kappa_list)
    kappa = kappa_list(i_kappa);

    %% Generate problem
    sigma_star = linspace(kappa, 1, r);
    L_star = U_star*diag(sqrt(sigma_star));
    R_star = V_star*diag(sqrt(sigma_star));
    X_star = L_star*R_star';
    y_star = zeros(m, 1);
    for k = 1:m
        y_star(k) = As{k}(:)'*X_star(:);
    end
    outlier = 10*norm(y_star, Inf)*outlier_seed.*(outlier_support_seed < ps);
    y = y_star + outlier;
    loss_star = norm(y_star - y, 1);
    alpha = sum(outlier_support_seed < ps)/length(outlier_support_seed);
    
    %% OPSA
    lambda = 2;
    [L_OPSA,R_OPSA,errors_OPSA1] = OPSA(y,As,d,alpha,lambda,max_iter,thresh_up,thresh_low,X_star,loss_star);
    errors_OPSA(i_kappa,1:length(errors_OPSA1))= errors_OPSA1;
end

%% Make plots
clrs = {[.5,0,.5], [1,.5,0], [1,0,0], [0,.5,0], [0,0,1]};
mks = {'o', 'x', 'p', 's', 'd'};
figure('Position', [0,0,800,600], 'DefaultAxesFontSize', 20);
lgd = {};
for i_kappa = 1:length(kappa_list)
    kappa = kappa_list(i_kappa);
    errors = errors_OPSA(i_kappa, :);
    errors = errors(errors > thresh_low);
    t_subs = 10:20:length(errors);
    semilogy(t_subs-1, errors(t_subs), 'Color', clrs{i_kappa}, 'Marker', mks{i_kappa}, 'MarkerSize', 9);
    hold on; grid on;
    lgd{end+1} = sprintf('$\\mathrm{OPSA}~\\kappa=%d$', kappa);
end
ylim([1e-15 1]);
xlim([0 max_iter])
xlabel('Iteration count');
ylabel('Relative error');
legend(lgd, 'Location', 'northeast', 'Interpreter', 'latex', 'FontSize', 24);
title(sprintf('$r=%d, d=%d$',r,d),'Interpreter','latex','FontSize',24);
