function [freq_cell, pks_cell] = dft_activity(samples_activity, act_label, act, fileID, freq_cell, pks_cell)
    % exercício 3 - experiência
    ts = 0.02;
    threshold = 0.20;
    % file = fopen(nameFile, 'r');
    dim_names = ["x axis", "y axis", "z axis"];
    ham = hamming(numel(samples_activity(:, 1)));

    N = length(samples_activity(:, 1));
    nAxis = -1/2:1 / N:1/2 - 1 / N;

    if mod(N, 2) == 1
        nAxis = nAxis + 1 / (2 * N);
    end
    nAxis = nAxis / ts;
    %fileID = fopen(strcat(act_label, ".txt"), 'a');
    fprintf(fileID, 'New act\n');

    
    %k = figure();
    %k2 = figure();

    for i = 1:3
        %figure(k)
        %title(act_label);
        %subplot(3, 1, i)
        one_dir = samples_activity(:, i);
        dft_sample_one_dir = fftshift(fft(one_dir)) / numel(one_dir);
        dft_sample_one_dir(abs(dft_sample_one_dir) < 0.000001) = 0;
        dft_sample_one_dir_ham = fftshift(fft(one_dir .* ham)) / numel(one_dir); %!!!! perguntar ao prof: magnitude vs amplitude 
        dft_sample_one_dir_ham(abs(dft_sample_one_dir_ham) < 0.000001) = 0;
        %figure(k2)

        %plot((1:numel(one_dir)) * ts, one_dir);
        autoc = autocorr(one_dir, length(samples_activity) - 1);
        autoc = autoc(5:end);
        period = find(autoc >= 0.95 * max(autoc));

        if (size(period) >= 2)
            period = period(1);
        end

        tStep = period * ts;
        freqMin = 60 / tStep;
        %figure(k)

        %plot(nAxis, abs(dft_sample_one_dir));
        %hold on
        %plot(nAxis, abs(dft_sample_one_dir_ham));
        %xlabel('Frequência (Hz)');
        %ylabel(dim_names(i));

        mod_dft_sample_one_dir_ham = abs(dft_sample_one_dir_ham);
        mod_dft_sample_one_dir = abs(dft_sample_one_dir);
        min_mag = max(mod_dft_sample_one_dir_ham) * threshold;

        [pks, locs] = findpeaks(mod_dft_sample_one_dir, 'Minpeakheight', min_mag);
        %disp("Sizes:");
        %disp(size(locs));
        %disp(size(pks));
        f_relevant = nAxis(locs)';
        % disp(size(f_relevant));
        f_relevant(abs(f_relevant) < 0.001) = 0;
        %fprintf("Frequencies for %s", act_label)
        %disp([pks, f_relevant]);
        pks = pks(f_relevant >= 0);
        %disp("Peaks:")
        %disp(pks);
        f_relevant = f_relevant(f_relevant >= 0);

        if f_relevant(1) == 0 && length(pks) ~= 1
            pks = [pks(1); 2 * pks(2:end)];
        else
            pks= 2.*pks;
        end

        %{
        aidPks = pks(f_relevant > 0);
        aidPks = aidPks * 2;
        pks(f_relevant > 0) = aidPks;
        %}
        arrAid = sortrows([pks, f_relevant], 'descend');
        coordVal = i.*ones(size(pks));
        pks_cell{act}{i}{1} = [pks_cell{act}{i}{1}; pks(1:min([5, length(pks)]))];
        freq_cell{act}{i}{1} = [freq_cell{act}{i}{1}; f_relevant(1:min([5, length(f_relevant)]))];
        % actNo = ones(size(pks)).*act;
        % [f_relevant, pks, actNo]; -> argumento da função
        %sort(arrAid);
        
        % pks_cell{act}(i,:)= [ pks_cell{act}(i,:)  [arrAid(1:min[5, length(pks)],1 )]' ];
        % pks_freq{act}(i,:)= [ pks_freq{act}(i,:)  [arrAid(1:min[5, length(f_relevant)],2 )]' ];



        %disp(dim_names(i));
        %disp(f_relevant);
        %fprintf(fileID, '%s\n', dim_names(i));
        count = 0;

        for j = 1:numel(f_relevant)

            if count > 4
                break;
            end;
            fprintf(fileID, '%g %g\n', arrAid(j, 2), arrAid(j, 1));
            count = count + 1;
            end

            fprintf(fileID, 'Passos por minuto: %f\n', freqMin * 2);
            %{
            figure(k2)
            subplot(3, 1, i)
            plot(f_relevant, pks, 'o');
            xlabel('Frequência (Hz)');
            ylabel('Módulo da DFT');
            title(strcat(dim_names(i), strcat(" ", act_label)));
            %}
        end
        

    end
