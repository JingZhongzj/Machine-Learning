% Load the data
load X_train.csv
X = X_train;
X1_y1 = X(1:1776, 1:54);
X1_y0 = X(1777:4508, 1:54);
X2_y1 = X(1:1776, 55:57);
X2_y0 = X(1777:4508, 55:57);

% Calculate theta1;
theta_x1_y1 = sum(X1_y1)/1776;
theta_x1_y0 = sum(X1_y0)/2732;

box on
hold on
stem(theta_x1_y1);
stem(theta_x1_y0);

