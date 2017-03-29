% Load the data
load X_train.csv
load y_train.csv
load X_test.csv
load y_test.csv

% Add dimension data equals to 1 to X_train;
D(1:4508,1) = 1;
X = horzcat(D,X_train);

% Change all the y=0 to y=-1;
Y = y_train;
for i = 1:4508
    if Y(i, 1) == 0
        Y(i, 1) = -1;
    end
end

% Add dimension data equals to 1 to X_test;
D2(1:93,1) = 1;
X_test = horzcat(D2,X_test);

% Steepest Ascent;
w(1:58,1) = 0;
L(1:10000,1) =0; 

for t = 1:10000
    for j = 1:4508
        L(t,1) = L(t,1) + log(1 + sig(x(X,j), y(Y,j), w));
    end
    n = 1/(10^5*(t+1)^0.5);
    sum(1:58,1) = 0;
    for i = 1:4508
        sum = sum + ((1-sig(x(X,i), y(Y,i), w))*y(Y,i)*x(X,i))';
    end
    w = w + n*sum; 
end

plot(L);



function yi = y(Y, i)
    yi = Y(i,1);
end

function xi = x(X, i)
    xi = X(i, :);
end

function sigmoid = sig(x, y, w)
    sigmoid = 1/(1+1/exp(y*x*w));
end

