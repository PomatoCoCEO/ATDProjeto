function [] = plot_freq_same_type(pks, freq, act)
    % no_coord = 1,2,3
    %beg_act=0 % 0-> dinamica , 3-> estatica, 6-> trans
    color_vec = {'#FF0000' '#663300' '#FF8000' '#66CC00' '#00FF00' '#00994C' '#00CCCC'  '#0066CC' '#0000FF' '#7F00FF' '#FF00FF' '#FF007F'};
    % plot(freq(1:min([length(pks), 5])), pks(1:min([length(pks), 5])),'LineStyle','none','Marker', 'o', 'Color', color_vec{no_act-beg_act}); 
    dynamic = 1:3;
    trans = 4:6;
    static =7:12;
    cell_types = {dynamic trans static};
    for k=1:3 %atividades
        figure()
        for i = cell_types{k}
            for j =1:3 %eixos
                subplot(3,1,j)
                %disp(freq{i}{j}{1})
                plot(freq{i}{j}{1},pks{i}{j}{1},'LineStyle','none','Marker', '*', 'Color', color_vec{i});
                xlabel('Frequência[Hz]')
                ylabel('Amplitude')
                hold on
            end;
        end;
        for i =1:3
            subplot(3,1,i);
            legend(act(cell_types{k}));
        end     
    end;

end