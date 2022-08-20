%% ��������-Ч�ÿɴ���
clear; clc;

n=31;

%�ڽӱ�
A=xlsread('C:\Users\HP\Desktop\ר����������.xlsx','��������ʱ��','A2:C79');
%�����ڽӱ�
B=xlsread('C:\Users\HP\Desktop\ר����������.xlsx','8-8.30 OD����','A2:C962');

%ʱ���ڽӾ���AD
AD=zeros(n);
for m = 1:length(A)
     AD(A(m,1),A(m,2))=A(m,3);
end
%�������ڽ���OD
OD=zeros(n);
for m = 1:length(B)
     OD(B(m,1),B(m,2))=B(m,3);
end

AD(AD==0)=inf;
AD([1:n+1:n^2])=0;

%% ��·����׼��

Three_St=[];                                     %����վ��ǰ�к�����վ
huan_cheng=[3 5 6 8 10 12 13 14 16 17 23 24];    %����վ��Ϣ
HC_temp=0;                                       %��OD���˴���
Judge=[];                                        %�ж��߼�
xian_zhan={[29 12 24 30 17 6 31];
           [1 2 3 4 5 6 7 8 9 10 11 12 13 14];
           [20 21 14 22 23 24 10 25];
           [15 3 16 17 8 18 19];
           [26 13 23 16 5 27 28]}';               %��·վ�������ϵ  ?����Ӱ�쿼������

%% ���������K��·��Path������ʱ��

%k=1
[Running_T_k1,R] = all_shortest_paths(sparse(AD));  

Path_k1=cell(n,n);  %all_shortest_paths����
p=[]; 
for i=1:n
  for j=1:n
    t=j; 
    while t~=0
      p(end+1)=t; 
       t=R(i,t); 
    end
      p=fliplr(p);
      Path_k1{i,j}=p;
      p=[];
  end
end

%k=2
Path_k2=cell(n,n);
Running_T_k2=zeros(n);

for i=1:n
   for j= 1:n
       [DIST,PATH]=graphkshortestpaths(sparse(AD),i,j,2);
       Path_k2{i,j}=PATH{end};
       Running_T_k2(i,j)=DIST(end);
   end
end

%k=3
Path_k3=cell(n,n);
Running_T_k3=zeros(n);

for i=1:n
   for j= 1:n
       [DIST,PATH]=graphkshortestpaths(sparse(AD),i,j,3);
       Path_k3{i,j}=PATH{end};
       Running_T_k3(i,j)=DIST(end);
   end
end





%% Ѱ�һ��˴���

%k=1
HC_k1=zeros(n);                                        %�ܻ��˴�������
for i = 1:n
    for j = 1:n
       B=Path_k1{i,j};                                %��ʱ�洢·��
%       if length(B)>2
        for k =2:length(Path_k1{i,j})-1               %��������β��վ
             if ismember(B(k),huan_cheng)==1       %�Ƿ��ǻ���վ
                 Three_St=[B(k-1),B(k),B(k+1)];    %��¼����վ��ǰ���վ��
                 for t =1:length(xian_zhan)
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));
                     if sum(Judge)==2 && Judge(2)~=0  %�Ƿ���������Ϊ
                            HC_temp=HC_temp+0.5;   %����վÿ����վ����һ���ߣ�һ�λ���������·����
                     end
                 end
             end
        end
        HC_k1(i,j)=HC_temp; HC_temp=0;  %��¼���˴�������ʼ����ʱ����
%       end
    end
end

%k=2
HC_k2=zeros(n);
for i = 1:n
    for j = 1:n
       B=Path_k2{i,j};                                %��ʱ�洢·��
%       if length(B)>2
        for k =2:length(Path_k2{i,j})-1               %��������β��վ
             if ismember(B(k),huan_cheng)==1       %�Ƿ��ǻ���վ
                 Three_St=[B(k-1),B(k),B(k+1)];    %��¼����վ��ǰ���վ��
                 for t =1:length(xian_zhan)
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));
                     if sum(Judge)==2 && Judge(2)~=0  %�Ƿ���������Ϊ
                            HC_temp=HC_temp+0.5;   %����վÿ����վ����һ���ߣ�һ�λ���������·����
                     end
                 end
             end
        end
        HC_k2(i,j)=HC_temp; HC_temp=0;  %��¼���˴�������ʼ����ʱ����
%       end
    end
end

%k=3
HC_k3=zeros(n);
for i = 1:n
    for j = 1:n
       B=Path_k3{i,j};                                %��ʱ�洢·��
%       if length(B)>2
        for k =2:length(Path_k3{i,j})-1               %��������β��վ
             if ismember(B(k),huan_cheng)==1       %�Ƿ��ǻ���վ
                 Three_St=[B(k-1),B(k),B(k+1)];    %��¼����վ��ǰ���վ��
                 for t =1:length(xian_zhan)
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));
                     if sum(Judge)==2 && Judge(2)~=0  %�Ƿ���������Ϊ
                            HC_temp=HC_temp+0.5;   %����վÿ����վ����һ���ߣ�һ�λ���������·����
                     end
                 end
             end
        end
        HC_k3(i,j)=HC_temp; HC_temp=0;  %��¼���˴�������ʼ����ʱ����
%       end
    end
end

%% ����k��·�ĳ���Ч��
Utility_k1=zeros(n);  Utility_k2=zeros(n);  Utility_k3=zeros(n);

%d�������
alpha=1.1;  beta=0.5;   %����ϵ��
tw=[0	0	2	0	2	2	0	2	0	2	0	2	2	2	0	2	2	0	0	0	0	0	2	2	0	0	0	0	0	0	0]; %��������ʱ��
th=[0	0	1.5	0	1.5	1.5	0	1.5	0	1.5	0	1.5	1.5	1.5	0	1.5	1.5	0	0	0	0	0	1.5	1.5	0	0	0	0	0	0	0]; %���˵ȴ�ʱ��
ts=0.5; %ͣվʱ��

%k=1
for i = 1:n
    for j =1:n
        for k = cell2mat(Path_k1(i,j)) %��·�����е�
           Utility_k1(i,j) = Utility_k1(i,j)+alpha*(tw(k)+th(k))*HC_k1(i,j)^beta+ts;  %�ڵ�ɱ���������һ��ͣվʱ��
        end
    end
end

for i = 1:n
    for j =1:n
       Utility_k1(i,j) = Utility_k1(i,j)+Running_T_k1(i,j)-ts;  %��������ɱ�����ȥһ��ͣվʱ��
    end
end

%k=2
for i = 1:n
    for j =1:n
        for k = cell2mat(Path_k2(i,j)) %��·�����е�
           Utility_k2(i,j) = Utility_k2(i,j)+alpha*(tw(k)+th(k))*HC_k2(i,j)^beta+ts;  %�ڵ�ɱ���������һ��ͣվʱ��
        end
    end
end

for i = 1:n
    for j =1:n
       Utility_k2(i,j) = Utility_k2(i,j)+Running_T_k2(i,j)-ts;  %��������ɱ�����ȥһ��ͣվʱ��
    end
end

%k=3
for i = 1:n
    for j =1:n
        for k = cell2mat(Path_k3(i,j)) %��·�����е�
           Utility_k3(i,j) = Utility_k3(i,j)+alpha*(tw(k)+th(k))*HC_k3(i,j)^beta+ts;  %�ڵ�ɱ���������һ��ͣվʱ��
        end
    end
end

for i = 1:n
    for j =1:n
       Utility_k3(i,j) = Utility_k3(i,j)+Running_T_k3(i,j)-ts;  %��������ɱ�����ȥһ��ͣվʱ��
    end
end


%% �������������Ӹ���

Possible_k1=zeros(n);
Possible_k2=zeros(n);
Possible_k3=zeros(n);
theta=2;             %���ò���

for i = 1:n
    for j =1:n
        Possible_k1(i,j)=(1/exp(theta*Utility_k1(i,j)))/((1/exp(theta*Utility_k1(i,j)))+(1/exp(theta*Utility_k2(i,j)))+(1/exp(theta*Utility_k3(i,j)))); 
        Possible_k2(i,j)=(1/exp(theta*Utility_k2(i,j)))/((1/exp(theta*Utility_k1(i,j)))+(1/exp(theta*Utility_k2(i,j)))+(1/exp(theta*Utility_k3(i,j)))); 
        Possible_k3(i,j)=(1/exp(theta*Utility_k3(i,j)))/((1/exp(theta*Utility_k1(i,j)))+(1/exp(theta*Utility_k2(i,j)))+(1/exp(theta*Utility_k3(i,j)))); 
    end
end

for i =1:n
    for j = i
        Possible_k1(i,j)=99999; 
        Possible_k2(i,j)=99999;
        Possible_k3(i,j)=99999;
    end
end


%% �������ʱ��ɴ���
for i =1:n
    for j = i
        Utility_k1(i,j)=99999; 
        Utility_k2(i,j)=99999;
        Utility_k3(i,j)=99999;
    end
end


sum_utility_access=zeros(n,1);
for i = 1:n
    for j =1:n      
        sum_utility_access(i,1)= sum_utility_access(i,1)+1/(Possible_k1(i,j)*Utility_k1(i,j)+Possible_k2(i,j)*Utility_k2(i,j)+Possible_k3(i,j)*Utility_k3(i,j));
    end
end


