% exercício 3 - experiência
    close all
    ts = 0.02;
    threshold = 0.2;
    nameFile = 'acc_exp01_user01.txt';
    file = fopen(nameFile, 'r');
    vec = fscanf(file,'%f %f %f', [3 Inf]);
    vec = vec';
    coords = [9657 10567];
    samples_activity = vec(coords(1):coords(2),:);
    dim_names = ["x axis", "y axis", "z axis"];
    ham = hamming(coords(2)-coords(1)+1);
    figure(1);

    N = length(samples_activity(:, 1));
    nAxis = -1/2:1/N:1/2-1/N;
    if mod(N, 2) == 1
        nAxis = nAxis + 1/(2*N);
    end
    nAxis = nAxis/ts;

    for i=1:3
        figure(1)
        subplot(3,1,i)
        one_dir=samples_activity(:, i);
 
        dft_sample_one_dir = fftshift(fft(one_dir));
        dft_sample_one_dir(abs(dft_sample_one_dir)<0.001)=0;
        dft_sample_one_dir_ham = fftshift(fft(one_dir.*ham));
        dft_sample_one_dir_ham(abs(dft_sample_one_dir_ham)<0.001)=0;

        
        plot(nAxis, abs(dft_sample_one_dir)/N);
        hold on
        plot(nAxis, abs(dft_sample_one_dir_ham)/N);
        xlabel('Frequência (Hz)');
        ylabel(dim_names(i));

        mod_dft_sample_one_dir_ham= abs(dft_sample_one_dir_ham);
        min_mag=max(mod_dft_sample_one_dir_ham)*threshold;

        [pks, locs] = findpeaks(mod_dft_sample_one_dir_ham, 'Minpeakheight',min_mag );

        f_relevant= nAxis(locs);
        f_relevant(abs(f_relevant)<0.001)=0;
        pks=pks(f_relevant>=0);
        f_relevant= f_relevant(f_relevant>=0);
        disp(dim_names(i));
        disp(f_relevant);
        figure(4)
        subplot(3,1,i)
        plot(f_relevant, pks, 'o');
        xlabel('Frequência (Hz)');
        ylabel('Módulo da DFT');
        title(dim_names(i));
    end

    
    for i=1:3
        figure(2)
        subplot(3,1,i)
        one_dir=samples_activity(:, i);
        plot(0.02*(1:numel(one_dir)),one_dir);
        hold on
        plot(0.02*(1:numel(one_dir)),ham.*one_dir);
        title('Domínio do tempo')
        xlabel('t')
        ylabel(dim_names(i));
        % verificacão da estacionaridade da série: no caso da amostra de
        % walking considerada, o teste retornou 1
        %adftest(one_dir)
        %adftest(one_dir.*ham)
        %fprintf('Hamming :')
        %adftest(ham);
        
        
        %figure(3);
        %subplot(3,1,i)
        %autocorr(one_dir.*ham,120);
        
        %spectrogram(one_dir, 109);
        % autocorr(one_dir,120);
        
    end
    
        
    