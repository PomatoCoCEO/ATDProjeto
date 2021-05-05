file=fopen('labels.txt','r');
labels= fscanf(file,'%d %d %d %d %d', [5,Inf]); 

labels=labels';
labels= [labels; 0 0 0 0 0];
%disp(labels(1,:));

imp = [1,1; 2,1; 3,2; 4,2; 5,3; 6,3; 7,4; 8,4];

disp(imp);
act= ["W","W\_UP", "W\_D", "SIT", "ST", "LAY", "ST\_SIT", "SIT\_ST","SIT\_LIE", "LIE\_SIT", "ST\_LIE", "LIE\_ST",""] %readlines('activity_labels.txt');

d = ls('acc*.txt')
%disp(size(d,1))
%disp(d(1,:))
a = size(d,1);
line=1;

%disp(imp(1,:))
%disp(labels(1,1:2))
%disp(any((imp(1,:)~=labels(10,1:2))))
%imp(2,:)==labels(1,1:2)


for g=1:a
    line=representData(d(g,:), g, imp(g,:), act,labels,line);
    %disp(d(g,:))
end



