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
w10 = w0*M^10;
w100 = w0*M^100;
w1000 = w0*M^1000;
w10000 = w0*M^10000;

w = [w10;w100;w1000;w10000];


Teams{4,2} = 0;
for i = 1:4
    [sortedValues,sortIndex] = sort(w(i,:),'descend');
    maxIndex = sortIndex(1:25);
    Teams{i,1} = TeamNames(maxIndex);
    Teams{i,2} = sortedValues(1:25)';
end

