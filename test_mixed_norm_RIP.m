n1 = 500; n2=500; 
r = 10;
d = 20;
m = round(sqrt(n1*n2)*r);  % number of sensing matrix
max_i = 500;
delta = zeros(max_i,1);
for i =1:max_i
    i
    L = randn(n1,d);
    R = randn(n2,d);
    X = L*R';
    
    As = cell(m, 1);
    y = zeros(m,1);
    for k = 1:m
	    As{k} = randn(n1, n2);
    end
    for k = 1:m
        y(k) = As{k}(:)'*X(:); %1/m*
    end
    
    delta(i) = norm(y,1)/norm(X,'fro');
end

%% 
figure('Position', [0,0,800,360], 'DefaultAxesFontSize', 20);
lgd = {};
scatter(1:length(delta),delta,5,'k','filled')
hold on
plot(1:length(delta),1.005*max(delta)*ones(1,length(delta)),'r-.')
plot(1:length(delta),0.995*min(delta)*ones(1,length(delta)),'b-.')
ylim([3000,5000])
ylabel('$\|\mathcal{A}(X)\|_1/\|X\|_F$','Interpreter', 'latex')
xlabel('Trials')
title('$d=20$','Interpreter', 'latex')
ax = gca;
ax.YAxis.Exponent = 3;


