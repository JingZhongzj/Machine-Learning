% Create a mixture of three Gaussians
mu1 = [0,0];
mu2 = [3,0];
mu3 = [0,3];
mu = [mu1;mu2;mu3];

sigma = cat(3,eye(2),eye(2),eye(2));
p = [0.2,0.5,0.3];
gm = gmdistribution(mu,sigma,p);

X = random(gm,500);
%scatter(X(:,1),X(:,2),10,'*')
%title('GMM - PDF Contours and Simulated Data');
%ezsurf(@(x,y)pdf(gm,[x y]),[-10 10],[-10 10])


%K-means

%Randomly initialize u = (u1,...,uK);
u_values = randperm(30,10)/10;
initial_u = initialize_u(u_values);
%K_set = [2,3,4,5];

for K = 2:5
    %K = K_set(index);
    u = initial_u;  % Initialize centroids u(Randomly);
    c = zeros(500,1);   % Initialize c;
    L = zeros(20,1);    % Initialize objective L;

    for iteration = 1:20

        %calculate c;
        for i = 1:500
            sqr = sum((X(i,:)-u(1,:)).^2);
            c(i) = 1;
            for k = 1:K
                if sum((X(i,:)-u(k,:)).^2) < sqr
                    sqr = sum((X(i,:)-u(k,:)).^2);
                    c(i) = k;
                end
            end
        end

        %Update u;
        sum_u = zeros(K,2);
        n_k = zeros(K,1);
        for k = 1:K       
            %sum_u = [0,0];
            for i = 1:500
                if c(i) == k
                    n_k(k,1) = n_k(k,1)+1;
                    sum_u(k,:) = sum_u(k,:) + X(i,:);
                end
            end
            u(k,:) = (1/n_k(k,1))*(sum_u(k,:));
        end

        %Calculate the objective;
        l = 0;
        for i = 1:500
            for k = 1:K
                if c(i) == k
                    l = l + sum((X(i,:)-u(k,:)).^2);
                end
            end
        end
        L(iteration) = l;
    end

    axis_x = (1:20);
    hold on
    plot(axis_x, L);
end
legend('K=2','K=3','K=4','K=5')


function y = initialize_u(u_values)
    u = zeros(5,2);
    for i = 1:5
        u(i,:) = [u_values(2*i-1),u_values(2*i)];
    end
    y = u;
end