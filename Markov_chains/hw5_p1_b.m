load CFB2016_scores.csv
TeamData = CFB2016_scores;
TeamNames = importdata('TeamNames.txt');

M = zeros(760,760);

for idx_game = 1:4197
    i = TeamData(idx_game,1);
    j = TeamData(idx_game,3);
    pointA = TeamData(idx_game,2);
    pointB = TeamData(idx_game,4);
    %if pointA < pointB
    M(j,j) = M(j,j) + 1*(pointA < pointB) + pointB/(pointA + pointB);
    M(i,j) = M(i,j) + 1*(pointA < pointB) + pointB/(pointA + pointB);
    
    %if pointA > pointB
    M(i,i) = M(i,i) + 1*(pointA > pointB) + pointA/(pointA + pointB);
    M(j,i) = M(j,i) + 1*(pointA > pointB) + pointA/(pointA + pointB);
end

% Normalize M
for row = 1:760
    M(row,:) = M(row,:)/norm(M(row,:),1);
end

w0 = ones(1,760)*(1/760);

% w_i is row vector
w = zeros(10000,760);

M_tmp = M;
for i = 1:10000
    w(i,:) = w0*M_tmp;
    M_tmp = M_tmp*M;
end

% Calculate the eigenvalue and eigenvector of MT
[V,D] = eig(M');
e = diag(D);
[A,B] = sort(e);

w_inf = -1*V(:,B(760));

err = zeros(10000,1);
for i = 1:10000
    err(i) = sum(abs(w(i,:)-(w_inf/norm(w_inf,1))'));
end

plot(1:10000,err);