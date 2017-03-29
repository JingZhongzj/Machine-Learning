load X_train.csv
load X_test.csv
load y_train.csv
load y_test.csv

b = [5,7,9,11,13,15];
sig2 = [.1,.2,.3,.4,.5,.6,.7,.8,.9,1];
RMSE = zeros(length(b),length(sig2));

for i = 1:length(b)
    for j = 1:length(sig2)
        Kn = K_n(b(i),X_train);
        K = K_xx(b(i),X_test);
        KD = K_D(b(i),X_test,X_train);
        u = KD*((sig2(j)*eye(size(Kn,1))+Kn)\y_train);
        var = sig2(j)*eye(size(K,1))+K-KD*((sig2(j)*eye(size(Kn,1))+Kn)\KD.');
        RMSE(i,j) = sqrt((y_test - u)' * (y_test - u) / 42);
    end
end

%Show the table:
row_names = {'b=5','b=7','b=9','b=11','b=13','b=15'};
col_names = {'sig=.1','sig=.2','sig=.3','sig=.4','sig=.5','sig=.6','sig=.7','sig=.8','sig=.9','sig=1'};

res = [{'---'},col_names;row_names.',mat2cell(RMSE,[1,1,1,1,1,1],[1,1,1,1,1,1,1,1,1,1])];
disp(res);


%Calculate Kn (350-by-350)
function y = K_n(bi,X)
    k = zeros(size(X,1),size(X,1));
    for i = 1:size(X,1)
        for j = 1:size(X,1)
            k(i,j) = exp(-(1/bi)*sum((X(i,:)-X(j,:)).^2));
        end
    end
    y = k;
end

%Calculate Kxx (42-by-42)
function y = K_xx(bi,X)
    k = zeros(size(X,1),size(X,1));
    for i = 1:size(X,1)
        for j = 1:size(X,1)
            k(i,j) = exp(-(1/bi)*sum((X(i,:)-X(j,:)).^2));
        end
    end
    y = k;
end

%Calculate KD (42-by-350)
function y = K_D(bi,X_test,X_train)
    k = zeros(size(X_test,1),size(X_train,1));
    for i = 1:size(X_test,1)
        for j = 1:size(X_train,1)
            k(i,j) = exp(-(1/bi)*sum((X_test(i,:)-X_train(j,:)).^2));
        end
    end
    y = k;
end