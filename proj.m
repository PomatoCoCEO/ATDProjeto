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
fileResults = fopen('results_tests.txt', 'a');
types=[1 1 1 2 2 2 3 3 3 3 3 3];
for N=100:5:500
    overlap = 5*N/10;
    probs = [];
    probs_types=[];
    maxyProbs = [];
    maxyProbs_types=[];
    
    fprintf(fileResults, 'Correção avgDft, Correção Hamming; por utilizador, diferença quadrática, N = %d, overlap = %d \n', N, overlap);

    for i = 1:8
        vec= readMatrix(d(i,:), 3);
        avgDft = avgDft_exp(N, vec(:,3), labels, lines(i));
        res = experiment_test(N, vec(:,3), avgDft, labels(lines(i+1)-1,5), overlap);   %e1
        comp = values_sample(labels, i, N, overlap);
        p = prob(comp, res);
        probs = [probs p];

        fprintf('Percentagem de sucesso: %f%%\n', p);
        fprintf(fileResults, 'p_sucesso=%f%%\n', p);
        allPr = allProbs(comp, res);
        probMax = max(allPr);
        posMax = find(allPr == probMax) -100;
        maxyProbs = [maxyProbs probMax];
        fprintf('p_sucesso=%f%%desvio=%d\n', max(allPr), posMax);
        fprintf(fileResults, 'p_sucesso=%f%%desvio=%d\n', max(allPr), posMax);



        %avgDft = avgDft_type(N, vec(:,3), labels, lines(i));
        % res = experiment_test_types(N, vec(:,3), avgDft, labels(lines(i+1)-1,5), overlap);   %e1

        comp(comp~=-1) = types(comp(comp~=-1));% values_sample_type(labels, i, N, overlap);
        res(res~=-1) = types(res(res~=-1));
        p = prob(comp, res);
        probs_types = [probs_types p];
        fprintf('p_sucesso_tipo=%f%%\n', p);
        fprintf(fileResults, 'p_sucesso_tipo=%f%%\n', p);
        allPr = allProbs(comp, res);
        probMax = max(allPr);
        posMax = find(allPr == probMax)-100;
        maxyProbs_types = [maxyProbs_types probMax];
        fprintf('p_sucesso_tipo=%f%%desvio=%d\n', max(allPr), posMax);
        fprintf(fileResults, 'p_sucesso_tipo=%f%%desvio=%d\n', max(allPr), posMax);

    end;


    fprintf('media=%f%%\n', mean(probs));
    fprintf(fileResults, 'media=%f%%\n', mean(probs));
    fprintf('media_desvio=%f%%\n', mean(maxyProbs));
    fprintf(fileResults, 'media_desvio=%f%%\n', mean(maxyProbs));
    
    fprintf('media_tipo=%f%%\n', mean(probs_types));
    fprintf(fileResults, 'media_tipo=%f%%\n', mean(probs_types));
    fprintf('media_tipo_desvio=%f%%\n', mean(maxyProbs_types));
    fprintf(fileResults, 'media_tipo_desvio=%f%%\n', mean(maxyProbs_types));

end
%{
for i = 1:length(act)
    fclose(fileIds(i));
end
    %disp(d(g,:))
%}