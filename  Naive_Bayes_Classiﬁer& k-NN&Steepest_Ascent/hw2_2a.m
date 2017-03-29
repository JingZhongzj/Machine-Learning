% Load the data
load X_train.csv
X = X_train;
X1 = X(:, 1:54);
X2 = X(:, 55:57);
X1_y1 = X(1:1776, 1:54);
X1_y0 = X(1777:4508, 1:54);
X2_y1 = X(1:1776, 55:57);
X2_y0 = X(1777:4508, 55:57);

load y_train.csv
Y = y_train;
Y0 = Y(1777:4508, 1);
Y1 = Y(1:1776, 1);

load X_test.csv
X1_test = X_test(:, 1:54);
X2_test = X_test(:, 55:57);

load y_test.csv

% Calculate pi;
pi = sum(Y)/4508;

% Calculate theta;
theta_x1_y1 = sum(X1_y1)/1776;
theta_x1_y0 = sum(X1_y0)/2732;
theta_x2_y1 = 1776./sum(log(X2_y1));
theta_x2_y0 = 2732./sum(log(X2_y0));


% Calculate the probability;
prob0_y0 = power(pi, 0) * power((1-pi), 1);
prob1_y0 = power(theta_x1_y0, X1_test) .* power((1.-theta_x1_y0), (1.-X1_test));
prob2_y0 = theta_x2_y0 .* power(X2_test, -(theta_x2_y0+1));

prob0_y1 = power(pi, 1) * power((1-pi), 0);
prob1_y1 = power(theta_x1_y1, X1_test) .* power((1.-theta_x1_y1), (1.-X1_test));
prob2_y1 = theta_x2_y1 .* power(X2_test, -(theta_x2_y1+1));

prob_y0 = [prob1_y0, prob2_y0];
prob_y1 = [prob1_y1, prob2_y1];

tmp0 = prob_y0(:, 1);
tmp1 = prob_y1(:, 1);
for i = 2:57
    tmp0 = tmp0 .* prob_y0(:, i);
    tmp1 = tmp1 .* prob_y1(:, i);
end

p0 = tmp0;
p1 = tmp1;

% Multiply the prior;
for i = 1:93
    p1(i,1) = p1(i,1)*pi;
    p0(i,1) = p0(i,1)*(1-pi);
end

% Classify;
y_predict = [];
for j = 1:93
    if p0(j, 1) > p1(j, 1)
        tmp = 0;
    else
        tmp = 1;
    end
    y_predict(j, 1) = tmp;
end

% Compare the predicted y and the actual y;
compare = [y_test, y_predict];

% Count the number of the 0s and 1s;
v00 = 0;
v01 = 0;
v10 = 0;
v11 = 0;

for i = 1:93
    if compare(i,1) == 0 && compare(i,2) == 0
        v00 = v00 + 1;
    end
    if compare(i,1) == 0 && compare(i,2) == 1
        v01 = v01 + 1;
    end
    if compare(i,1) == 1 && compare(i,2) == 0
        v10 = v10 + 1;
    end
    if compare(i,1) == 1 && compare(i,2) == 1
        v11 = v11 + 1;
    end
end

y_type = {'y_pre_0';'y_pre_1'};
col1 = [v00; v10];
col2 = [v01; v11];
value = {'y_0';'y_1'};
T = table(col1, col2,...
    'RowNames',value,...
    'VariableNames', y_type)

count = 0;
for i = 1:93
    if compare(i,1) == compare(i,2)
        count = count + 1;
    end
end

Accuracy = count/93



