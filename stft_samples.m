% exercicio 4.1
function mat = stft_samples(sample, windowSize, windowFunc, tSample)
    % assuming overlap of 50 %
    nSuperpos = windowSize/2;
    no_windows = floor((length(sample)-windowSize)/nSuperpos+1);
    mat = zeros(no_windows, ceil(windowSize/2.0));
    aidWindow = windowFunc(windowSize, 1);
    % n_passes = floor((len-nSamplesWindow)/nSamplesSuperposition+1);
    for i = 1:no_windows
        strt = 1+(i-1)*(nSuperpos);
        window = sample(strt:strt+windowSize-1).*aidWindow;
        dft = 20*log10(abs(fftshift(fft(window)))/windowSize); % /windowSize);
        dft = dft(ceil((windowSize+1)/2.0):end);
        %{
            if mod(windowSize, 2) == 0
            % dft = 2*dft(windowSize/2,:);
            dft = 2*dft;
        else 
        %}
        dft(2:end) = 2*dft(2:end);
        
        mat(no_windows-i+1, :)= dft;
    end
    figure()
    image(mat, 'CDataMapping', 'scaled');
    % ylim([0, ])
    % xlim([0, length(sample)*tSample]);
    colorbar
end