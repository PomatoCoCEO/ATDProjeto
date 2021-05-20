function [mat, lines] = readMatrix(nameFile, nCol)
    file = fopen(nameFile, 'r');
    frmt = '%f';
    for k = 1:nCol-1
        frmt = strcat(frmt, ' %f');
    end
    mat = fscanf(file,frmt, [nCol Inf]);
    mat = mat';
end