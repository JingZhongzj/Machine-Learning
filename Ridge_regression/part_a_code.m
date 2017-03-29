load X_train.csv
% Move the column with "1"s to the 1st column;
A = X_train(:,7);
B = X_train(:,1:6);
X = horzcat(A,B);

load y_train.csv
y = y_train;

%Calculate WRR;
lambda = 0;
WRR = inv(X'*X+lambda*eye(7))*X'*y; %W0
for lambda = 1:5000
       tmp = inv(X'*X+lambda*eye(7))*X'*y;
       WRR = [WRR, tmp];
   end

%Calculate matrix S;
[U,S,V] = svd(X,'econ');

%Calculate df(lambda);
lambda = 0;
df = 0;
for i = 1:7
       tmp = (S(i,i)^2)/(lambda+(S(i,i)^2));
       df = df+tmp;
   end
for lambda = 1:5000
       df_tmp = 0;
       for i = 1:7
           tmp = (S(i,i)^2)/(lambda+(S(i,i)^2));
           df_tmp = df_tmp+tmp;
       end
       df = [df, df_tmp];
   end

%Draw the figure;
plot(df, WRR)