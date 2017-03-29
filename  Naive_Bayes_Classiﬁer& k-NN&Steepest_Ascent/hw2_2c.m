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

% predict y using KNN classification model;
sub(1,1:4508) = 0;
distance = [];

for test_row = 1:93
    for train_row = 1:4508
        sub(1, train_row) = sum(abs(X_test(test_row, :) - X_train(train_row, :)));
    end
    distance = [distance; sub];
end

distance = distance';
distance = [distance, y_train];

y_pre = knn(1,distance);
for k = 2:20
    tmp_res = knn(k, distance);
    y_pre = [y_pre; tmp_res];
end

y_pre = y_pre'

% Calculate the accuracy;
Accuracy = [];
for j = 1:20
    count = 0;
    for i = 1:93
        if y_pre(i,j) == y_test(i,1)
            count = count + 1;
        end
        tmp_acc = count/93;
    end
    Accuracy = [Accuracy, tmp_acc];
end

plot(Accuracy);

% Define the knn function;
function y = knn(k, distance)
y_pre = [];
for i = 1:93
    % Sort the col and take the first k;
    matrix = sortrows(distance, i);
    % Take the first k rows;
    matrix_k = matrix(1:k, :);
    % Count the number of 1s;
    if (sum(matrix_k(:, 94)) > k/2)
        tmp = 1;
    else
        tmp = 0;
    end
    y_pre = [y_pre, tmp];
end
y = y_pre;
end


