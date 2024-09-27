function [] = Test2()

mu = [0,0];
%sigma = [1,0; 0,1];
sigma = [1,0.5; 0.5,1];
x = mvnrnd(mu, sigma, 3000);
y = mvnpdf(x, mu, sigma);
plot3(x(:,1), x(:,2), y, '*');

mean(x(:,1));
mean(x(:,2));
var(x(:,1));
var(x(:,2));
mean(x(:,1).*x(:,2));

end

