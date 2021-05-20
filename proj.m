labels=readMatrix('labels.txt', 5); 
labels= [labels; 0 0 0 0 0];
close all;

%disp(labels(1,:));

exp_user = [1,1; 2,1; 3,2; 4,2; 5,3; 6,3; 7,4; 8,4];

% disp(exp_user);
act= ["W","W\_UP", "W\_D", "SIT", "ST", "LAY", "ST\_SIT", "SIT\_ST","SIT\_LIE", "LIE\_SIT", "ST\_LIE", "LIE\_ST"]; %readlines('activity_labels.txt');
actFiles= ["W","W_UP", "W_D", "SIT", "ST", "LAY", "ST_SIT", "SIT_ST","SIT_LIE", "LIE_SIT", "ST_LIE", "LIE_ST"]; %readlines('activity_labels.txt');

d = ls('acc*.txt');
%disp(size(d,1))
%disp(d(1,:))
a = size(d,1);
lines=[1 23 46 66 86 107 127 148 168];

%disp(exp_user(1,:))
%disp(labels(1,1:2))
%disp(any((exp_user(1,:)~=labels(10,1:2))))
%exp_user(2,:)==labels(1,1:2)

%{ 
    commented for now...
fileIds = [];
for i = 1:length(actFiles)
    fileIds = [fileIds fopen(strcat(actFiles(i), '.txt'), 'w')];
end

for g=1:8 %7:7%6:6%5:5 %4:4%3:3 %2:2 % 1:1% numel(lines) %length(exp_user) %a
    representData(d(g,:), exp_user(g,:), act,labels,lines(g), fileIds);
end
%}

N=192;


%{
for i = 1:4
    vec1= readMatrix(d(2*i -1,:), 3);
    vec2= readMatrix(d(2*i ,:), 3);
    avgDft = avgDfts(N, vec1(:,3), vec2(:,3), labels, lines(2*i-1));
    res1 = experiment_test(N, vec1(:,3), avgDft, labels(lines(2*i)-1,5), overlap);   %e1
    res2 = experiment_test(N, vec2(:,3), avgDft, labels(lines(2*i+1)-1,5), overlap);   %e2
    comp1 = values_sample(labels, 2*i-1, N, overlap);
    comp2 = values_sample(labels, 2*i, N, overlap);
    p1 = prob(comp1, res1);
    p2 = prob(comp2, res2);
    probs = [probs p1 p2];
end;
%}

for N=100:1000
    overlap = 5*N/10;
    probs = [];
    fileResults = fopen('results_tests.txt', 'a');
    fprintf(fileResults, 'Correção Hamming; por utilizador, diferença quadrática, N = %d, overlap = %d \n', N, overlap);

    for i = 1:8
        vec= readMatrix(d(i,:), 3);
        avgDft = avgDft_exp(N, vec(:,3), labels, lines(i));
        res = experiment_test(N, vec(:,3), avgDft, labels(lines(i+1)-1,5), overlap);   %e1
        comp = values_sample(labels, i, N, overlap);
        p = prob(comp, res);
        probs = [probs p];
        fprintf('Percentagem de sucesso: %f%%\n', p);
        fprintf(fileResults, 'Percentagem de sucesso: %f%%\n', p);
    end;


    fprintf('Média : %f%%\n', mean(probs));
    fprintf(fileResults, 'Média : %f%%\n', mean(probs));
end
%{
for i = 1:length(act)
    fclose(fileIds(i));
end
    %disp(d(g,:))
%}