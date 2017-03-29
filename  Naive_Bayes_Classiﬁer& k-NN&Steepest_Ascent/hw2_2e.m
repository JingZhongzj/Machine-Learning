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

% Newton's method;
w(1:58,1) = 0;
L(1:100,1) =0; 

Accuracy(1:100,1) = 0;
for t = 1:100
    for j = 1:4508
        L(t,1) = L(t,1) + log(sig(x(X,j), y(Y,j), w));
    end
    n = 1/sqrt(t+1);
    sum1(1:58,1) = 0;
    sum2(1:58,1:58) = 0;
    for i = 1:4508
        sum1 = sum1 +...
               ((1-sig(x(X,i),y(Y,i),w))*y(Y,i)*x(X,i))';
        sum2 = sum2 +...
               (-sig_x(x(X,i),w)*(1-sig_x(x(X,i),w))*x(X,i).'*x(X,i));
    end
    w = w - n*(sum2\sum1); 
    
    % Predict y;
    y_pre(1:93,1) = 0;
    for i = 1:93
        if sign(x(X_test,i)*w) >= 0
            y_pre(i,1) = 1;
        else
            y_pre(i,1) = 0;
        end
    end
    
    % Calculate accuracy;
    cnt = 0;
    for i = 1:93
        if y_test(i,1) == y_pre(i,1)
            cnt = cnt + 1;
        end
    end
    Accuracy(t,1) = cnt/93; 
end

box on

plot(L);
plot(Accuracy);
sum(Accuracy)/100;


function yi = y(Y, i)
    yi = Y(i,1);
end

function xi = x(X, i)
    xi = X(i,:);
end

function sigmoid = sig(x, y, w)
    sigmoid = 1/(1+1/exp(y*x*w));
end

function sigmoid_x = sig_x(x, w)
    sigmoid_x = 1/(1+1/exp(x*w));
end
