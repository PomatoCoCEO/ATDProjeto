function []=representData(nameFile, nfigure, exp_user, act, labels, line, fileIDs)
    file = fopen(nameFile, 'r');
    vec = fscanf(file,'%f %f %f', [3 Inf]);
    vec = vec';
    
    aid = size(vec,1);
    % the signals were captured at a frequency of 50 Hz -> T = 0.02s
    t = (0:0.02:((aid-1)*0.02))/60;
    figure(nfigure)
    subplot(311)
    hold off;
    plot(t, vec(:,1), 'k')
    % y1 = ylim;
    ylim([-2.2,2.5]); 
    
    title('x axis')
    xlabel('t[min]')
    ylabel('acc')
    hold on
    subplot(312)
    hold off;
    plot(t, vec(:,2), 'k')
    % y1 = ylim;
    ylim([-2.2,2.5]); 
    title('y axis')
    xlabel('t[min]')
    ylabel('acc')
    hold on
    subplot(313)
    hold off;
    plot(t, vec(:,3),'k')
    y1 = ylim;
    ylim([-2.2,2.5]); 
    title('z axis')
    xlabel('t[min]')
    ylabel('acc')
    hold on
    %nfigure=figure()
    pks_cell={{{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}}};
    freq_cell={{{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}} {{[]} {[]} {[]}}};
    stft_samples(vec(:,3),256, 128, @hamming, 0.02);
    figure();
    spectrogram(vec(:,3), 256, 128,[],50);
    lineBefore = line;
    begs=[];
    fin=0;
    while (~any(exp_user ~= labels(line,1:2)))
        figure(nfigure)
        activ=labels(line,3);     
        beg=labels(line,4);
        fin=labels(line,5);
        begs=[begs beg];
        % fins=[fins fin];
        med=(beg+fin) /2;
        for i = 1:3 
            subplot(3,1,i);
            plot(t(beg:fin), vec(beg:fin,i));
            k = -1.25;
            if mod(line,2)==0
                k=2.25;
            end
            text((med+beg)/2*0.02/60, k, act(activ));
            hold on;
        end
        [freq_cell, pks_cell] =dft_activity(vec(beg:fin,:), act(activ), activ, fileIDs(activ), freq_cell, pks_cell);
        % med=(beg+fin) /2;
    
        %t=annotation('textbox',[beg*0.02/60  fin*0.02/60],'String', act(activ));
        %sz = t.FontSize;
        %t.FontSize = 8;
        line=line+1;
    end

    % plot_freq_same_type(pks_cell, freq_cell,act);
    % plot_all_freq(pks_cell, freq_cell,act);
    N=110;
    avgDftAid = avgDfts(N,vec(:,3),labels,lineBefore);
    begTot = begs(1)
    % finTot = fins(size(fins));
    fileIdFile = fopen('results.txt', 'w');

    for m = 1:N-floor(0.9*N):fin-N+1;
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

    %{for i =1:3
        %subplot(3,1,i);
        %xtickangle(45);
        %xticks(ticks.*0.02./60);
        %xticklabels(act(ticksl));
    %}
