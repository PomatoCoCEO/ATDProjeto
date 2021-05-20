file=fopen('labels.txt','r');
labels= fscanf(file,'%d %d %d %d %d', [5,Inf]); 
close all;
labels=labels';
labels= [labels; 0 0 0 0 0];
%disp(labels(1,:));

imp = [1,1; 2,1; 3,2; 4,2; 5,3; 6,3; 7,4; 8,4];

% disp(imp);
act= ["W","W\_UP", "W\_D", "SIT", "ST", "LAY", "ST\_SIT", "SIT\_ST","SIT\_LIE", "LIE\_SIT", "ST\_LIE", "LIE\_ST"]; %readlines('activity_labels.txt');
actFiles= ["W","W_UP", "W_D", "SIT", "ST", "LAY", "ST_SIT", "SIT_ST","SIT_LIE", "LIE_SIT", "ST_LIE", "LIE_ST"]; %readlines('activity_labels.txt');

d = ls('acc*.txt');
%disp(size(d,1))
%disp(d(1,:))
a = size(d,1);
lines=[1 23 46 66 86 107 127 148];

%disp(imp(1,:))
%disp(labels(1,1:2))
%disp(any((imp(1,:)~=labels(10,1:2))))
%imp(2,:)==labels(1,1:2)
fileIds = [];
for i = 1:length(actFiles)
    fileIds = [fileIds fopen(strcat(actFiles(i), '.txt'), 'w')];
end

for g=8:8%7:7%6:6%5:5 %4:4%3:3 %2:2 % 1:1% numel(lines) %length(imp) %a
    representData(d(g,:), g, imp(g,:), act,labels,lines(g), fileIds);
end

for i = 1:length(act)
    fclose(fileIds(i));
end
    %disp(d(g,:))