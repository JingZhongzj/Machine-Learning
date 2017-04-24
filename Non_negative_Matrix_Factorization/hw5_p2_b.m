Data = importdata('nyt_data.txt');
vocab = importdata('nyt_vocab.dat');

% Initialize W, H;
a = 2;
b = 1;
W = (b-a).*rand(3012,25) + a;
H = (b-a).*rand(25,8447) + a;

fileid = fopen('nyt_data.txt');
word_idx = zeros(3012,8447);
word_freq = zeros(3012,8447);

k = 1;
while ~feof(fileid)
    tline = fgetl(fileid); % read each line
    S = regexp(tline, ',', 'split');
    for i = 1:length(S)
        tmp = regexp(S(i), ':', 'split');
        idx = str2double(tmp{1}{1});
        word_idx(i,k) = idx;
        freq = str2double(tmp{1}{2});
        word_freq(idx,k) = freq;
    end
    k = k + 1;
end
fclose(fileid);

X = word_freq;
L = zeros(100,1);
add_matrix = ones(3012,8447)*10^-16;

for iteration = 1:100
    
    % Update H;
    WH = W*H;
    WH = WH + add_matrix;% Avoid small values;
    H_update = zeros(25,8447);
    X_div_WH = X./WH;
    sum_W = sum(W);
    for k = 1:25
        H_update(k,:) = H(k,:).*(W(:,k)'*X_div_WH)/sum_W(k);
    end
    H = H_update;

    % Update W;
    WH = W*H;
    WH = WH + add_matrix;% Avoid small values;
    W_update = zeros(3012,25);
    X_div_WH = X./WH;
    sum_H = sum(H,2);
    for k = 1:25
        W_update(:,k) = W(:,k).*(H(k,:)*X_div_WH')'/sum_H(k);
    end
    W = W_update;

    WH = W*H;
    WH = WH + add_matrix;% Avoid small values;

end


I = zeros(3012,25);
for i = 1:25
    tmp = W(:,i)/norm(W(:,i),1);
    [W(:,i),I(:,i)] = sort(tmp,'descend');
end

W_top = W(1:10,:);
I_top = I(1:10,:);

words = cell(1,25);
for i = 1:25
    words{i} = vocab(I_top(:,i));
end






