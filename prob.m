function p = prob(sampleAns, sampleTest)
    ind = find(sampleAns==-1);
    elim = numel(ind);
    
    sampleTest(ind)=-1;
    %disp(size(sampleAns));
    %disp(size(sampleTest));
    proby= (sampleAns==sampleTest);

    p =  (sum(proby)-elim)/(length(proby) - elim )*100;
    % file3=fopen('resProbs.txt','a');