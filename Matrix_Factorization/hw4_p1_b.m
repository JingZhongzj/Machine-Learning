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


%K = 3
K = 3;
c = zeros(500,1);   % Initialize c;
L = zeros(20,1);    % Initialize objective L;
u = initial_u;  % Initialize centroids u(Randomly);

for iteration = 1:20
    %calculate c;
    for i = 1:500
        sqr = sum((X(i,:)-u(1,:)).^2);
        tmp_c = 1;
        for k = 1:K
            if sum((X(i,:)-u(k,:)).^2) < sqr
                sqr = sum((X(i,:)-u(k,:)).^2);
                tmp_c = k;
            end
            c(i) = tmp_c;
        end
    end

    %Update u;
    for k = 1:K
        n_k = 0;
        sum_u = [0,0];
        for j = 1:500
            if c(j) == k
                n_k = n_k+1;
                sum_u = sum_u + X(j,:);
            end
        end
        u(k,:) = (1/n_k)*(sum_u);
    end
end

cluster1 = [];
cluster2 = [];
cluster3 = [];

for i = 1:500
    if c(i) == 1
        cluster1 = [cluster1;X(i,:)];
    elseif c(i) == 2
        cluster2 = [cluster2;X(i,:)];
    else
        cluster3 = [cluster3;X(i,:)];
    end
end

hold on
h1 = scatter(cluster1(:,1),cluster1(:,2),'o');
h2 = scatter(cluster2(:,1),cluster2(:,2),'x');
h3 = scatter(cluster3(:,1),cluster3(:,2),'*');
box on 





function y = initialize_u(u_values)
    u = zeros(5,2);
    for i = 1:5
        u(i,:) = [u_values(2*i-1),u_values(2*i)];
    end
    y = u;
end