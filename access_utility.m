%% 吸收能力-效用可达性
clear; clc;

n=31;

%邻接表
A=xlsread('C:\Users\HP\Desktop\专利地铁数据.xlsx','区间运行时间','A2:C79');
%客流邻接表
B=xlsread('C:\Users\HP\Desktop\专利地铁数据.xlsx','8-8.30 OD客流','A2:C962');

%时间邻接矩阵AD
AD=zeros(n);
for m = 1:length(A)
     AD(A(m,1),A(m,2))=A(m,3);
end
%客流矩邻接阵OD
OD=zeros(n);
for m = 1:length(B)
     OD(B(m,1),B(m,2))=B(m,3);
end

AD(AD==0)=inf;
AD([1:n+1:n^2])=0;

%% 线路数据准备

Three_St=[];                                     %换乘站的前中后三个站
huan_cheng=[3 5 6 8 10 12 13 14 16 17 23 24];    %换乘站信息
HC_temp=0;                                       %单OD换乘次数
Judge=[];                                        %判断逻辑
xian_zhan={[29 12 24 30 17 6 31];
           [1 2 3 4 5 6 7 8 9 10 11 12 13 14];
           [20 21 14 22 23 24 10 25];
           [15 3 16 17 8 18 19];
           [26 13 23 16 5 27 28]}';               %线路站点包含关系  ?环线影响考虑了吗？

%% 任意两点间K短路径Path及运行时间

%k=1
[Running_T_k1,R] = all_shortest_paths(sparse(AD));  

Path_k1=cell(n,n);  %all_shortest_paths回溯
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





%% 寻找换乘次数

%k=1
HC_k1=zeros(n);                                        %总换乘次数矩阵
for i = 1:n
    for j = 1:n
       B=Path_k1{i,j};                                %临时存储路径
%       if length(B)>2
        for k =2:length(Path_k1{i,j})-1               %不考虑首尾车站
             if ismember(B(k),huan_cheng)==1       %是否是换乘站
                 Three_St=[B(k-1),B(k),B(k+1)];    %记录换乘站及前后的站点
                 for t =1:length(xian_zhan)
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));
                     if sum(Judge)==2 && Judge(2)~=0  %是否发生换乘行为
                            HC_temp=HC_temp+0.5;   %三个站每两个站属于一条线，一次换乘两条线路满足
                     end
                 end
             end
        end
        HC_k1(i,j)=HC_temp; HC_temp=0;  %记录换乘次数，初始化临时换乘
%       end
    end
end

%k=2
HC_k2=zeros(n);
for i = 1:n
    for j = 1:n
       B=Path_k2{i,j};                                %临时存储路径
%       if length(B)>2
        for k =2:length(Path_k2{i,j})-1               %不考虑首尾车站
             if ismember(B(k),huan_cheng)==1       %是否是换乘站
                 Three_St=[B(k-1),B(k),B(k+1)];    %记录换乘站及前后的站点
                 for t =1:length(xian_zhan)
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));
                     if sum(Judge)==2 && Judge(2)~=0  %是否发生换乘行为
                            HC_temp=HC_temp+0.5;   %三个站每两个站属于一条线，一次换乘两条线路满足
                     end
                 end
             end
        end
        HC_k2(i,j)=HC_temp; HC_temp=0;  %记录换乘次数，初始化临时换乘
%       end
    end
end

%k=3
HC_k3=zeros(n);
for i = 1:n
    for j = 1:n
       B=Path_k3{i,j};                                %临时存储路径
%       if length(B)>2
        for k =2:length(Path_k3{i,j})-1               %不考虑首尾车站
             if ismember(B(k),huan_cheng)==1       %是否是换乘站
                 Three_St=[B(k-1),B(k),B(k+1)];    %记录换乘站及前后的站点
                 for t =1:length(xian_zhan)
                     Judge=ismember(Three_St,cell2mat(xian_zhan(1,t)));
                     if sum(Judge)==2 && Judge(2)~=0  %是否发生换乘行为
                            HC_temp=HC_temp+0.5;   %三个站每两个站属于一条线，一次换乘两条线路满足
                     end
                 end
             end
        end
        HC_k3(i,j)=HC_temp; HC_temp=0;  %记录换乘次数，初始化临时换乘
%       end
    end
end

%% 计算k短路的出行效用
Utility_k1=zeros(n);  Utility_k2=zeros(n);  Utility_k3=zeros(n);

%d定义参数
alpha=1.1;  beta=0.5;   %换乘系数
tw=[0	0	2	0	2	2	0	2	0	2	0	2	2	2	0	2	2	0	0	0	0	0	2	2	0	0	0	0	0	0	0]; %换乘走行时间
th=[0	0	1.5	0	1.5	1.5	0	1.5	0	1.5	0	1.5	1.5	1.5	0	1.5	1.5	0	0	0	0	0	1.5	1.5	0	0	0	0	0	0	0]; %换乘等待时间
ts=0.5; %停站时间

%k=1
for i = 1:n
    for j =1:n
        for k = cell2mat(Path_k1(i,j)) %该路径所有点
           Utility_k1(i,j) = Utility_k1(i,j)+alpha*(tw(k)+th(k))*HC_k1(i,j)^beta+ts;  %节点成本，多算了一个停站时间
        end
    end
end

for i = 1:n
    for j =1:n
       Utility_k1(i,j) = Utility_k1(i,j)+Running_T_k1(i,j)-ts;  %加上区间成本，减去一个停站时间
    end
end

%k=2
for i = 1:n
    for j =1:n
        for k = cell2mat(Path_k2(i,j)) %该路径所有点
           Utility_k2(i,j) = Utility_k2(i,j)+alpha*(tw(k)+th(k))*HC_k2(i,j)^beta+ts;  %节点成本，多算了一个停站时间
        end
    end
end

for i = 1:n
    for j =1:n
       Utility_k2(i,j) = Utility_k2(i,j)+Running_T_k2(i,j)-ts;  %加上区间成本，减去一个停站时间
    end
end

%k=3
for i = 1:n
    for j =1:n
        for k = cell2mat(Path_k3(i,j)) %该路径所有点
           Utility_k3(i,j) = Utility_k3(i,j)+alpha*(tw(k)+th(k))*HC_k3(i,j)^beta+ts;  %节点成本，多算了一个停站时间
        end
    end
end

for i = 1:n
    for j =1:n
       Utility_k3(i,j) = Utility_k3(i,j)+Running_T_k3(i,j)-ts;  %加上区间成本，减去一个停站时间
    end
end


%% 任意两点间的链接概率

Possible_k1=zeros(n);
Possible_k2=zeros(n);
Possible_k3=zeros(n);
theta=2;             %设置参数

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


%% 计算出行时间可达性
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


