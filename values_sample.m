function val = values_sample(labels, no_exp, window, overlapWindow)
    sz = size(labels);
    val = [];
    wind = window;
    for k = 1:sz(1)
        if labels(k,1) < no_exp
            continue
        end
        if labels( k,1) > no_exp
            break
        end
        beg = labels(k,4);
        endy = labels(k,5);
        while wind <= endy
            if wind < beg
                val = [val -1];
            else
                val = [val labels(k, 3)];
            end
            wind = wind + window - floor(overlapWindow);
        end
    end
end