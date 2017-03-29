load X_train.csv
% Move the column with "1"s to the 1st column;
A = X_train(:,7);
B = X_train(:,1:6);
X = horzcat(A,B);

load y_train.csv
y = y_train;

load X_test.csv
% Move the column with "1"s to the 1st column;
A_test = X_test(:,7);
B_test = X_test(:,1:6);
X_test = horzcat(A_test, B_test);

load y_test.csv


%Calculate the RMSE;
lambda = 0;
WRR = inv(X'*X+lambda*eye(7))*X'*y; %W0
y_pre = X_test*WRR;
sum = 0;
for i=1:42
    tmp = (y_test(i)-y_pre(i))^2;
    sum = sum+tmp;
end
RMSE = (sum/42)^0.5;

for lambda = 1:50
       WRR = inv(X'*X+lambda*eye(7))*X'*y;
       y_pre_tmp = X_test*WRR;
       
       sum = 0;
       for i=1:42
           tmp = (y_test(i)-y_pre_tmp(i))^2;
           sum = sum+tmp;
       end
       RMSE_tmp = (sum/42)^0.5;
       RMSE = [RMSE, RMSE_tmp];
       y_pre = [y_pre, y_pre_tmp];
end

%Draw the plot;
lambda = 0:50;
plot(lambda, RMSE);
