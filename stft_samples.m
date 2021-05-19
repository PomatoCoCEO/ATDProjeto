% exercicio 4.1
function mat = stft_samples(sample, windowSize, superposSize, windowFunc, tSample)
    % assuming overlap of 50 %
    % nSuperpos = windowSize/2;
    delta = windowSize-superposSize;
    % no_windows = floor((length(sample)-windowSize)/nSuperpos+1);
    aidWindow = windowFunc(windowSize, 1);
    % n_passes = floor((len-nSamplesWindow)/nSamplesSuperposition+1);
    vals = 1:delta:length(sample)-windowSize+1;
    no_windows = length(vals);
    mat = zeros(no_windows, ceil(windowSize/2.0));
    k=1;
    for i = vals % no_windows
        % strt = 1+(i-1)*(nSuperpos);
        % window = sample(strt:strt+windowSize-1).*aidWindow;
        window = sample(i:i+windowSize-1).*aidWindow;
        dft = 20*log10(abs(fftshift(fft(window)))/windowSize); % /windowSize);
        dft = dft(ceil((windowSize+1)/2.0):end);
        %{
            if mod(windowSize, 2) == 0
            % dft = 2*dft(windowSize/2,:);
            dft = 2*dft;
            else 
        %}
        dft(2:end) = 2*dft(2:end);
        
        mat(no_windows-k+1, :)= dft;
        k = k+1;
    end
    figure()
    xAx = [0 windowSize-1]/(tSample*windowSize);
    yAx = [1, length(sample)-windowSize+1].*tSample;
    image(xAx, yAx, mat, 'CDataMapping', 'scaled');
    xlabel('Frequência [Hz]');
    ylabel('Tempo[s]')
    % ylim([0, ])
    % xlim([0, length(sample)*tSample]);
    c = colorbar;
    c.Label.String = 'Amplitude do sinal(dB)'
end