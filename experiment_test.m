function results = experiment_test(N, vec, avgDft, final_pos, overlap)
    % N=220;
    % avgDftAid = avgDfts(N,vec(:,3),labels,line); % dfts médias
    % begTot = begs(1)
    % finTot = fins(size(fins));
    
    results = [];
    for m = 1:N-floor(overlap):final_pos-N+1
        spl = vec(m:m+N-1); % ordenada z
        fftSample =  abs(fftshift(fft(spl.*hamming(N))))/N;
        % disp(size(spl));
        % disp(size(avgDftAid));
        % normalizar para melhor precisão
        % fout = fout/norm(fout);

        correlations = zeros(12,1);
        for n=1:12
            correlations(n)= vpa(sum((avgDft(n,:)- fftSample').^2));
        end
        %disp(correlations);
        activity = find(correlations == min(correlations));
        % disp(act);
        % disp(activity);
        % fprintf('t=%f s -> %s\n', m*0.02, act(activity));
        
        % fprintf(fileIdFile, '%d\n', activity);
        results = [results activity];
        % disp(act(activity));
    end
