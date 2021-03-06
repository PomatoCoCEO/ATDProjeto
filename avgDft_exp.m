function avgDft = avgDft_exp(N,vec_z, labels, posInit)
    avgDft = zeros(12, N);
    noSamples = [0,0,0,0,0,0,0,0,0,0,0,0];
    k=posInit;
    ant = labels(k,1:2);
    begin_range=0;
    while (k~=numel(labels) && labels(k,2) == ant(2)) 
        if labels(k,1) > ant(1)
            break;
        end;
        noAct = labels(k,3);
        superpos = floor(0.9*N);
        begin_range = labels(k,4);
        end_range = labels(k,5);
        % rang = begin_range:end_range;
        no_elem = end_range-begin_range+1;
        if no_elem < N
            spl = zeros(N,1);
            spl(1:no_elem, 1) = vec_z(begin_range:end_range);
            fout = abs(fftshift(fft(spl)))/N;
            %.*hamming(N)
            avgDft(noAct,:) = avgDft(noAct, :) + fout';
            noSamples(noAct) = noSamples(noAct) + 1;
        else 
            for m = begin_range:N-superpos:end_range-N+1
                spl = vec_z(m:m+N-1);
                fout = abs(fftshift(fft(spl.*hamming(N))))/N;
                % normalizar para melhor precisão
                % fout = fout/norm(fout);
                avgDft(noAct,:) = avgDft(noAct, :) + fout';
                noSamples(noAct) = noSamples(noAct) + 1;
            end
        end
        %disp(k);
        k=k+1;
    end
    
    for m=1:12
        avgDft(m, :)=avgDft(m,:)./noSamples(m);
    end
    
    
end