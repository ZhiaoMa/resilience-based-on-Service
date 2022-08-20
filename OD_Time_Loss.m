%% ��������
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
initial_OD=sum(sum(OD));

%�����ʼ���·������
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

%������¼��վ�����ʧ
sum_ODloss=zeros(n,2); sum_timeloss=zeros(n,2);

for t= 1:n
    residual_AD=AD;                    %��ʼ���ڽӾ���
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
    end                        %���������Ĵζ�·����


    %�Ƚ���������,���������ʧ
    temp_ODloss=zeros(n);
    alpha=1.4; %��ֵϵ��
    for i =1:n
        for j =1:n
            if residual_AD(i,j) >= alpha*shortest_AD(i,j)
                 temp_ODloss(i,j)=OD(i,j);   
            end
        end
    end    
    ODloss=sum(sum(temp_ODloss));  %�����������ʧ

    %�������ʱ������
    beta=15;  %��������潻ͨ��ʱ������
    temp_timeloss=zeros(n);
    for i = 1:n
        for j =1:n
            temp_timeloss(i,j)=residual_AD(i,j) - shortest_AD(i,j);
            if temp_timeloss(i,j) == inf
                temp_timeloss(i,j)=beta;
            end
        end
    end

    timeloss=sum(sum(temp_timeloss));  %����ʱ������ʧ        

    sum_ODloss(t,1)=ODloss; sum_ODloss(t,2)=ODloss/initial_OD;
    sum_timeloss(t,1)=timeloss;sum_timeloss(t,2)=timeloss/initial_time;
end
