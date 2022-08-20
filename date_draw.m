clear;clc;

xy=xlsread('C:\Users\HP\Desktop\专利地铁数据.xlsx','结果整合','A2:E32')';

x=1:31;

y1=xy(1,:);  %出行时间可达性
y2=xy(2,:); %出行效用可达性
y3=xy(3,:);  %客流损失量
y4=xy(4,:);  %时间增加量
y5=xy(5,:);  %恢复系数

%吸收能力
w1 = 0.5; 
bar(x,y1,w1,'FaceColor',[0.2 0.2 0.5])
w2 = 0.25;
hold on
bar(x,y2,w2,'FaceColor',[0 0.7 0.7])
hold off

%抗毁能力


plot(x,y3)
hold on 
plot(x,y4)


%恢复能力
stem(x,y5)