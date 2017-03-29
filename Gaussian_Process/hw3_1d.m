load X_train.csv
load y_train.csv

b = 5;
sig2 = 2;

X_train = X_train(:,4);

Kn = K_n(b,X_train);
KD = K_D(b,X_train,X_train);
K = K_xx(b,X_train);
u = KD*((sig2*eye(size(Kn,1))+Kn)\y_train);
var = sig2*eye(size(K,1))+K-KD*((sig2*eye(size(Kn,1))+Kn)\KD.');

% sort u from high to low in order to plot
M = [X_train, u];
M = sortrows(M,1);

%show the plot of predicted y and y_train
plot(M(:,1),M(:,2));
hold on;
scatter(X_train,y_train,'*');
legend('u','actual_Y');


%Calculate Kn
function y = K_n(b,X)
    k = zeros(size(X,1),size(X,1));
    for i = 1:size(X,1)
        for j = 1:size(X,1)
            k(i,j) = exp(-(1/b)*sum((X(i,:)-X(j,:)).^2));
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

%Calculate KD
function y = K_D(b,X_test,X_train)
    k = zeros(size(X_test,1),size(X_train,1));
    for i = 1:size(X_test,1)
        for j = 1:size(X_train,1)
            k(i,j) = exp(-(1/b)*sum((X_test(i,:)-X_train(j,:)).^2));
        end
    end
    y = k;
end