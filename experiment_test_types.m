function results = experiment_test_types(N, vec, avgDft, final_pos, overlap)

    types=[1 1 1 2 2 2 3 3 3 3 3 3]; % 1 - dinamica 2 - estática 3 - transição

    results = [];
    for m = 1:N-floor(overlap):final_pos-N+1
        spl = vec(m:m+N-1); % ordenada z
        fftSample =  abs(fftshift(fft(spl.*hamming(N))))/N;

        correlations = zeros(3,1);
        for n=1:3
            correlations(n)= vpa(sum((avgDft(n,:)- fftSample').^2));
        end
        activity = find(correlations == min(correlations));
        type_act= types(activity);
        results = [results type_act];
    end
