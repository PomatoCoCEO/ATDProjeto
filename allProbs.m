function allProbs = shift_array_result(comp1, comp2)
    rel1 =[]; rel2 = [];
    allProbs = [];
    for k = -100:100
        if k<0
            rel1 = comp1(-k+1:length(comp1));
            rel2 = comp2(1:length(comp1)+k);
        else
            rel2 = comp2(k+1:length(comp2));
            rel1 = comp1(1:length(comp1)-k);
        end
        % countEquals = numel(find())
        p = prob(rel1, rel2);
        allProbs = [allProbs p];
    end