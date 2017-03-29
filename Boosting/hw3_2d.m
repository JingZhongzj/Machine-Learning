load X_train.csv
load X_test.csv
load y_train.csv
load y_test.csv

X_train = horzcat(X_train,ones(1036,1)); % Add the dimension "1"
X_test = horzcat(X_test,ones(1000,1)); % Add the dimension "1"

% Initialization
error = zeros(1500,1);
y_test_pre = zeros(1000,1);
y_train_pre = zeros(1036,1);
w_boot=ones(1036,1)/1036; % Initialize w_boot
w = zeros(1500,6);
a = zeros(1500,1);
train_error = zeros(1500,1);
test_error = zeros(1500,1);
upperbound = zeros(1500,1);
Index = zeros(1,1036);


for t = 1:1500
    
    %Bootstrap    
    Index = randsample(1:1036,1036,true,w_boot);
    X_train_boot = X_train(Index,:);
    y_train_boot = y_train(Index,:);
    
    w(t,:) = ((X_train_boot')*X_train_boot)\((X_train_boot')*y_train_boot);
    
    % Predict y_train
    y_train_pre = X_train*(w(t,:)');
    for i = 1:1036
            if y_train_pre(i) > 0
                y_train_pre(i) = 1;
            else
                y_train_pre(i) = -1;
            end
    end
    
    % Calculate error
    for i = 1:1036
        if y_train_pre(i) ~= y_train(i)
            error(t) = error(t) + w_boot(i);
        end
    end
    
    if error(t) > 0.5
        error(t) = 0;
        w(t,:) = -w(t,:); % Flip w
        y_train_pre = X_train*(w(t,:)'); % Recalculate
        for i = 1:1036
            if y_train_pre(i) > 0
                y_train_pre(i) = 1;
            else
                y_train_pre(i) = -1;
            end
            % Calculate error
            if y_train_pre(i) ~= y_train(i)
                error(t) = error(t) + w_boot(i);
            end
        end
    end
    
    a(t) = 0.5*log((1-error(t))/error(t));

    % Update w
    w_update = zeros(1036,1);
    for k = 1:1036
        w_update(k) = w_boot(k) * exp(-a(t) * y_train(k) * sign(X_train(k,:)*(w(t,:)')));
    end
    w_boot = w_update/sum(w_update);
        
    % Calculate train error
    a_t = zeros(1500,1036);
    for i = 1:1036
        a_t(:,i) = a;
    end
    f_boost_train = sign(sum(sign(X_train * w').*a_t',2));
    train_error(t) = sum(abs(f_boost_train - y_train)/2)/1036;
    
    % Calculate test error
    a_t_test = zeros(1500,1000);
    for i = 1:1000
        a_t_test(:,i) = a;
    end
    f_boost_test = sign(sum(sign(X_test * w').*a_t_test',2));
    test_error(t) = sum(abs(f_boost_test - y_test)/2)/1000;
    
    
end

% Plot the training error and test error
axis_x = ones(1500,1);
for i = 1:1500
    axis_x(i) = i;
end

plot(axis_x,error);
hold on
plot(axis_x,a);
legend('E_t','a_t');

