load ratings_test.csv
load ratings.csv

user_id_train = ratings(:,1);
user_id_test = ratings_test(:,1);
movie_id_train = ratings(:,2);
movie_id_test = ratings_test(:,2);
rating_train = ratings(:,3);
rating_test = ratings_test(:,3);


%Initialize u and v;
mu = zeros(1,10);
sigma = eye(10);

u_i = mvnrnd(mu,sigma);
v_j = mvnrnd(mu,sigma)';
u = zeros(943,10);
v = zeros(10,1682);
M = zeros(943,1682);

for i = 1:943
    u(i,:) = mvnrnd(mu,sigma);
end


for j = 1:1682
    v(:,j) = mvnrnd(mu,sigma)';
end



for i = 1:943
    for j = 1:1682
        M(i,j) = normrnd(u(i,:)*v(:,j),0.25);
    end
end