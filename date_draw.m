clear;clc;

xy=xlsread('C:\Users\HP\Desktop\ר����������.xlsx','�������','A2:E32')';

x=1:31;

y1=xy(1,:);  %����ʱ��ɴ���
y2=xy(2,:); %����Ч�ÿɴ���
y3=xy(3,:);  %������ʧ��
y4=xy(4,:);  %ʱ��������
y5=xy(5,:);  %�ָ�ϵ��

%��������
w1 = 0.5; 
bar(x,y1,w1,'FaceColor',[0.2 0.2 0.5])
w2 = 0.25;
hold on
bar(x,y2,w2,'FaceColor',[0 0.7 0.7])
hold off

%��������


plot(x,y3)
hold on 
plot(x,y4)


%�ָ�����
stem(x,y5)