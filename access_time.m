%% ��������-ʱ��ɴ���
clear
clc

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

% k=2
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


%% �������������Ӹ���

Possible_k1=zeros(n);
Possible_k2=zeros(n);
Possible_k3=zeros(n);
theta=2;             %���ò���

for i = 1:n
    for j =1:n
        Possible_k1(i,j)=(1/exp(theta*Running_T_k1(i,j)))/((1/exp(theta*Running_T_k1(i,j)))+(1/exp(theta*Running_T_k2(i,j)))+(1/exp(theta*Running_T_k3(i,j)))); 
        Possible_k2(i,j)=(1/exp(theta*Running_T_k2(i,j)))/((1/exp(theta*Running_T_k1(i,j)))+(1/exp(theta*Running_T_k2(i,j)))+(1/exp(theta*Running_T_k3(i,j)))); 
        Possible_k3(i,j)=(1/exp(theta*Running_T_k3(i,j)))/((1/exp(theta*Running_T_k1(i,j)))+(1/exp(theta*Running_T_k2(i,j)))+(1/exp(theta*Running_T_k3(i,j))));          
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
        Running_T_k1(i,j)=99999; 
        Running_T_k2(i,j)=99999;
        Running_T_k3(i,j)=99999;
    end
end


sum_time_access=zeros(n,1);
for i = 1:n
    for j =1:n      
        sum_time_access(i,1)= sum_time_access(i,1)+1/(Possible_k1(i,j)*Running_T_k1(i,j)+Possible_k2(i,j)*Running_T_k2(i,j)+Possible_k3(i,j)*Running_T_k3(i,j));
    end
end


