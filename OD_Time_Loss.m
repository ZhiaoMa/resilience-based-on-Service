%% 抗毁能力
clear
clc

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
initial_OD=sum(sum(OD));

%计算初始最短路径矩阵
shortest_AD=AD;    
shortest_AD(shortest_AD==0)=inf;
shortest_AD([1:n+1:n^2])=0;

for k=1:n;
    for i = 1:n;
        for j=1:n;
            if shortest_AD(i,j)>shortest_AD(i,k)+shortest_AD(k,j);
                shortest_AD(i,j)=shortest_AD(i,k)+shortest_AD(k,j);
            end
        end
    end
end
initial_time=sum(sum(shortest_AD));

%遍历记录各站点的损失
sum_ODloss=zeros(n,2); sum_timeloss=zeros(n,2);

for t= 1:n
    residual_AD=AD;                    %初始化邻接矩阵
    residual_AD(t,:)=0;  residual_AD(:,t)=0;
    residual_AD(residual_AD==0)=inf;
    residual_AD([1:n+1:n^2])=0;

    for k=1:n
      for i = 1:n
          for j=1:n
              if residual_AD(i,j)>residual_AD(i,k)+residual_AD(k,j)
                    residual_AD(i,j)=residual_AD(i,k)+residual_AD(k,j);  
              end
          end
      end
    end                        %计算断联后的次短路矩阵


    %比较冗余能力,计算客流损失
    temp_ODloss=zeros(n);
    alpha=1.4; %阈值系数
    for i =1:n
        for j =1:n
            if residual_AD(i,j) >= alpha*shortest_AD(i,j)
                 temp_ODloss(i,j)=OD(i,j);   
            end
        end
    end    
    ODloss=sum(sum(temp_ODloss));  %单点客流总损失

    %计算出行时间增加
    beta=15;  %轨道换地面交通的时间增加
    temp_timeloss=zeros(n);
    for i = 1:n
        for j =1:n
            temp_timeloss(i,j)=residual_AD(i,j) - shortest_AD(i,j);
            if temp_timeloss(i,j) == inf
                temp_timeloss(i,j)=beta;
            end
        end
    end

    timeloss=sum(sum(temp_timeloss));  %单点时间总损失        

    sum_ODloss(t,1)=ODloss; sum_ODloss(t,2)=ODloss/initial_OD;
    sum_timeloss(t,1)=timeloss;sum_timeloss(t,2)=timeloss/initial_time;
end
