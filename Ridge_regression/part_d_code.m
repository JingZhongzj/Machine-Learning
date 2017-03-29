%p = 1
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


%Calculate the RMSE1;
lambda1 = 0;
WRR1 = inv(X'*X+lambda1*eye(7))*X'*y; %W0
y_pre1 = X_test*WRR1;
sum1 = 0;
for i=1:42
    tmp1 = (y_test(i)-y_pre1(i))^2;
    sum1 = sum1+tmp1;
end
RMSE1 = (sum1/42)^0.5;

for lambda1 = 1:500
       WRR1 = inv(X'*X+lambda1*eye(7))*X'*y;
       y_pre1_tmp = X_test*WRR1;
       
       sum1 = 0;
       for i=1:42
           tmp1 = (y_test(i)-y_pre1_tmp(i))^2;
           sum1 = sum1+tmp1;
       end
       RMSE1_tmp = (sum1/42)^0.5;
       RMSE1 = [RMSE1, RMSE1_tmp];
       y_pre1 = [y_pre1, y_pre1_tmp];
end


%p=2
%Change the model to 2nd-order polynomial regression model;
nrows = 350;
ncols = 13;
X_2d = ones(nrows,ncols);
for i=2:7
     X_2d(:,i) = X(:,i);
     X_2d(:,i+6) = X(:,i).^2;
end

nrows = 42;
ncols = 13;
X_test_2d = ones(nrows,ncols);
for i=2:7
     X_test_2d(:,i) = X_test(:,i);
     X_test_2d(:,i+6) = X_test(:,i).^2;
end

%Calculate the RMSE2;
lambda2 = 0;
WRR2 = inv(X_2d'*X_2d+lambda2*eye(13))*X_2d'*y; %W0
y_pre2 = X_test_2d*WRR2;
sum2 = 0;
for i=1:42
    tmp2 = (y_test(i)-y_pre2(i))^2;
    sum2 = sum2+tmp2;
end
RMSE2 = (sum2/42)^0.5;

for lambda2 = 1:500
       WRR2 = inv(X_2d'*X_2d+lambda2*eye(13))*X_2d'*y;
       y_pre2_tmp = X_test_2d*WRR2;
       
       sum2 = 0;
       for i=1:42
           tmp2 = (y_test(i)-y_pre2_tmp(i))^2;
           sum2 = sum2+tmp2;
       end
       RMSE2_tmp = (sum2/42)^0.5;
       RMSE2 = [RMSE2, RMSE2_tmp];
       y_pre2 = [y_pre2, y_pre2_tmp];
end


%p=3
%Change the model to 3rd-order polynomial regression model;
nrows = 350;
ncols = 19;
X_3d = ones(nrows,ncols);
for i=2:7
     X_3d(:,i) = X(:,i);
     X_3d(:,i+6) = X(:,i).^2;
     X_3d(:,i+12) = X(:,i).^3;
end

nrows = 42;
ncols = 19;
X_test_3d = ones(nrows,ncols);
for i=2:7
     X_test_3d(:,i) = X_test(:,i);
     X_test_3d(:,i+6) = X_test(:,i).^2;
     X_test_3d(:,i+12) = X_test(:,i).^3;
end

%Calculate the RMSE3;
lambda3 = 0;
WRR3 = inv(X_3d'*X_3d+lambda3*eye(19))*X_3d'*y; %W0
y_pre3 = X_test_3d*WRR3;
sum3 = 0;
for i=1:42
    tmp3 = (y_test(i)-y_pre3(i))^2;
    sum3 = sum3+tmp3;
end
RMSE3 = (sum3/42)^0.5;

for lambda3 = 1:500
       WRR3 = inv(X_3d'*X_3d+lambda3*eye(19))*X_3d'*y;
       y_pre3_tmp = X_test_3d*WRR3;
       
       sum3 = 0;
       for i=1:42
           tmp3 = (y_test(i)-y_pre3_tmp(i))^2;
           sum3 = sum3+tmp3;
       end
       RMSE3_tmp = (sum3/42)^0.5;
       RMSE3 = [RMSE3, RMSE3_tmp];
       y_pre3 = [y_pre3, y_pre3_tmp];
end

%Draw the plot;
lambda1 = 0:500;
lambda2 = 0:500;
lambda3 = 0:500;
plot(lambda1, RMSE1, lambda2, RMSE2, lambda3, RMSE3);

indexmin1 = find(min(RMSE1) == RMSE1);
xmin1 = lambda1(indexmin1);
ymin1 = RMSE1(indexmin1);
strmin1 = ['Min1 = ',num2str(ymin1)];
text(xmin1,ymin1,strmin1,'HorizontalAlignment','left');
indexmin2 = find(min(RMSE2) == RMSE2);
xmin2 = lambda2(indexmin2);
ymin2 = RMSE2(indexmin2);
strmin2 = ['Min2 = ',num2str(ymin2)];
text(xmin2,ymin2,strmin2,'HorizontalAlignment','left');
indexmin3 = find(min(RMSE3) == RMSE3);
xmin3 = lambda3(indexmin3);
ymin3 = RMSE3(indexmin3);
strmin3 = ['Min3 = ',num2str(ymin3)];
text(xmin3,ymin3,strmin3,'HorizontalAlignment','left');
