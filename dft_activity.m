function [] = dft_activity(samples_activity, act_label, fileID)
    % exercício 3 - experiência
    ts = 0.02;
    threshold = 0.2;
    % file = fopen(nameFile, 'r');
    dim_names = ["x axis", "y axis", "z axis"];
    ham = hamming(numel(samples_activity(:,1)));

    N = length(samples_activity(:, 1));
    nAxis = -1/2:1/N:1/2-1/N;
    if mod(N, 2) == 1
        nAxis = nAxis + 1/(2*N);
    end
    nAxis = nAxis/ts;

    %fileID = fopen(strcat(act_label, ".txt"), 'a');
    fprintf(fileID, 'New act\n');
    
    %k = figure();
    %k2 = figure();
    for i=1:3
        %figure(k)
        %title(act_label);
        %subplot(3,1,i)
        one_dir=samples_activity(:, i);
        dft_sample_one_dir = fftshift(fft(one_dir));
        dft_sample_one_dir(abs(dft_sample_one_dir)<0.001)=0;
        dft_sample_one_dir_ham = fftshift(fft(one_dir.*ham));
        dft_sample_one_dir_ham(abs(dft_sample_one_dir_ham)<0.001)=0;
        
        autoc = autocorr(one_dir, length(samples_activity)-1);
        autoc = autoc(5:end);
        period = find(autoc == max(autoc));
        if(size(period) >= 2) period = period(1); end

        %{   
        %plot(nAxis, abs(dft_sample_one_dir)/N);
        hold on
        %plot(nAxis, abs(dft_sample_one_dir_ham)/N);
        xlabel('Frequência (Hz)');
        ylabel(dim_names(i));
        %}
        mod_dft_sample_one_dir_ham= abs(dft_sample_one_dir_ham);
        min_mag=max(mod_dft_sample_one_dir_ham)*threshold;

        [pks, locs] = findpeaks(mod_dft_sample_one_dir_ham, 'Minpeakheight',min_mag );

        f_relevant= nAxis(locs);
        f_relevant(abs(f_relevant)<0.001)=0;
        pks=pks(f_relevant>=0);
        f_relevant= f_relevant(f_relevant>=0);
        disp(dim_names(i));
        disp(f_relevant);
        fprintf(fileID, '%s\n',dim_names(i));
        for j = 1:numel(f_relevant)
            fprintf(fileID,'%g %g\n' ,f_relevant(j),pks(j));
        end
        fprintf(fileID,'Passos por minuto: %g\n' ,period*2);
        %{
        figure(k2)

        subplot(3,1,i)
        plot(f_relevant, pks, 'o');
        xlabel('Frequência (Hz)');
        ylabel('Módulo da DFT');
        title(strcat(dim_names(i), strcat(" ", act_label)));
        %}
    end
end