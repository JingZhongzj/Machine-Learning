load ratings_test.csv
load ratings.csv

user_id_train = ratings(:,1);
user_id_test = ratings_test(:,1);
movie_id_train = ratings(:,2);
movie_id_test = ratings_test(:,2);
rating_train = ratings(:,3);
rating_test = ratings_test(:,3);
A = importdata('movies.txt');

%Initialize u and v;
mu = zeros(1,10);
sigma = eye(10);


M = zeros(943,1682);
L = zeros(100,10);
pred_M = zeros(5000,1);
RMSE = zeros(10,1);
max_L = -20000000;

for idx = 1:95000
    M(ratings(idx,1),ratings(idx,2)) = ratings(idx,3);
end

for run = 1:10
    u = mvnrnd(mu,sigma,943);
    v = mvnrnd(mu,sigma,1682)';
    for iteration = 2:100

        sum_l1 = 0;
        sum_l2 = 0;
        sum_l3 = 0;

        %update ui
        for i = 1:943
            sum_vj = 0;
            sum_Mvj = 0;
            obj_for_user = find(ratings(:,1) == i);
            for j = 1:length(obj_for_user)
                index_j = ratings(obj_for_user(j),2);
                sum_vj = sum_vj + v(:,index_j)*v(:,index_j)';
                sum_Mvj = sum_Mvj + M(i,index_j)*v(:,index_j);
            end
            u(i,:) = (0.25*eye(10)+sum_vj)\sum_Mvj;
            sum_l2 = sum_l2 - 0.5*(u(i,:)*u(i,:)');
        end

        %update vj
        for j = 1:1682
            sum_ui = 0;
            sum_Mui = zeros(10,1);
            user_for_obj = find(ratings(:,2) == j);
            for i = 1:length(user_for_obj)
                index_i = ratings(user_for_obj(i),1);
                sum_ui = sum_ui + u(index_i,:)'*u(index_i,:);
                sum_Mui = sum_Mui + M(index_i,j)*u(index_i,:)';
            end
            v(:,j) = (0.25*eye(10)+sum_ui)\sum_Mui;
            sum_l3 = sum_l3 - 0.5*(v(:,j)'*v(:,j));
        end


        for idx = 1:95000
            user_idx = user_id_train(idx);
            obj_idx = movie_id_train(idx);
            sum_l1 = sum_l1 - 2*(M(user_idx,obj_idx)-u(user_idx,:)*v(:,obj_idx))^2;
        end

        L(iteration,run) = sum_l1 + sum_l2 + sum_l3;
    end
    for i = 1:5000          
        pred_M(i) = u(ratings_test(i,1),:)*v(:,ratings_test(i,2));
    end
 
    % Table
    RMSE(run) = ((1/5000)*(sum((pred_M - ratings_test(:,3)).^2)))^0.5;
    
    if L(100,run) > max_L
        max_L = L(100,run);
        tmp_u = u;
        tmp_v = v;
    end
    
    L_plot = L(2:100,run);
    hold on
    plot(2:100,L_plot)
end

% Table
final_L = L(100,:)';
table = horzcat(RMSE,final_L);

v_starwar = v(:,50);
v_myfairlady = v(:,485);
v_goodfellas = v(:,182);

starwar_distances = zeros(1682,2);
myfairlady_distances = zeros(1682,2);
goodfellas_distances = zeros(1682,2);

for j = 1:1682
    starwar_distances(j,1) = sqrt(sum((v(:,j) - v_starwar) .^ 2));
    myfairlady_distances(j,1) = sqrt(sum((v(:,j) - v_myfairlady) .^ 2));
    goodfellas_distances(j,1) = sqrt(sum((v(:,j) - v_goodfellas) .^ 2));
    starwar_distances(j,2) = j;
    myfairlady_distances(j,2) = j;
    goodfellas_distances(j,2) = j;
end

starwar_distances_sorted = sortrows(starwar_distances,1);
myfairlady_distances_sorted = sortrows(myfairlady_distances,1);
goodfellas_distances_sorted = sortrows(goodfellas_distances,1);

starwar_nearest = starwar_distances_sorted(1:11,:);
myfairlady_nearest = myfairlady_distances_sorted(1:11,:);
goodfellas_nearest = goodfellas_distances_sorted(1:11,:);


movies_starwar = A(starwar_nearest(:,2));
movies_myfairlady = A(myfairlady_nearest(:,2));
movies_goodfellas = A(goodfellas_nearest(:,2));
