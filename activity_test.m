function [] = activity_test(N, vec_1, vec_2,labels, line)
    % N=220;
    % avgDftAid = avgDfts(N,vec(:,3),labels,lineBefore);
    avgDftAid = avgDfts(N,vec(:,3), vec(),labels,line);
    begTot = begs(1)
    % finTot = fins(size(fins));
    fileIdFile = fopen('results.txt', 'w');

    for m = 1:N-floor(0.5*N):fin-N+1;
        spl = vec(m:m+N-1, 3); % ordenada z
        fftSample = hamming(N) .* abs(fftshift(fft(spl)))/N;
        % disp(size(spl));
        % disp(size(avgDftAid));
        % normalizar para melhor precisão
        % fout = fout/norm(fout);

        correlations = zeros(12,1);
        for n=1:12
            correlations(n)= vpa(sum((avgDftAid(n,:)- fftSample').^2));
        end
        %disp(correlations);
        activity = find(correlations == min(correlations));
        % disp(act);
        % disp(activity);
        % fprintf('t=%f s -> %s\n', m*0.02, act(activity));
        
        fprintf(fileIdFile, '%d\n', activity);
        % disp(act(activity));
    end

    fprintf(fileIdFile, '---\n', activity);

end;