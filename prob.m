file=fopen('results.txt','r');
res= fscanf(file,'%d', [1,Inf]); 

file2=fopen('res.txt','r');
res2= fscanf(file2,'%d', [1,Inf]); 

%disp(size(res2))
%disp(size(res))

ind = find(res2==-1);
elim = numel(ind);
res(ind)=-1;

proby= (res==res2);

file3=fopen('resProbs.txt','a');

p=  (sum(proby)-elim)/(length(proby) - elim );
fprintf(file3,'Percentagem de sucesso: %f%%\n', p*100);
