function [a,b,mmin,mmax]=RAGA(xx,N,n,Pc,Pm,M,DaiNo,Ci,ads)
tic;
% NΪ��Ⱥ��ģ,PcΪ�������,PmΪ�������,DaiNoΪ���ڽ�����������֮�����һ�ζ��趨��������
% n�Ż�������Ŀ��M���췽������Ҫ���������CiΪ���ٴ�����xminΪ�Ż���������������,xmaxΪ�Ż���������������
% ��������Ŀn�������xmin��xmax��ά��;adsΪ0������Сֵ��Ϊ���������ֵ��
% mmin��mmaxΪ�������仯�����������ֵ
if ads==0
    ad='ascend'; %Matlab������
else
    ad='descend';
end
% ======================step1 ���ɳ�ʼ����==================================
mm1=zeros(1,n);mm2=ones(1,n);
for z=1:Ci    %��ʾ���ٴ���Ϊ20��
    z;
   for i=1:N
    while 1==1
    for p=1:n                           %pΪ�Ż���������Ŀ,
        bb(p)=unifrnd(mm1(p),mm2(p));   %����(����)���ȷֲ��������,mm1(p)
        %Ϊ����,mm2(p)Ϊ����
    end
    temp=sum(bb.^2);
    a=sqrt(bb.^2/temp);
    y=Feasibility(a);
    if y==1
        v(i,:)=a;
        break;
    end
    end
end
% step1 end
for s=1:DaiNo
% step2 ������Ӧ��
for i=1:N
   fv(i)=Target(xx,v(i,:));
end
%����Ӧ������
[fv,i]=sort(fv,ad);
v=v(i,:);
%step2 end
%step3 �������������ۺ���
arfa=0.05;
q(1)=0;
for i=2:N+1
    q(i)=q(i-1)+arfa*(1-arfa)^(i-2);
end
%step3 end
%step4 ѡ�����
for i=1:N
    r=unifrnd(0,q(N+1));
    for j=2:N+1
        if r>q(j-1) & r<=q(j)
            vtemp1(i,:)=v(j-1,:);
        end
    end
end
%step4 end
%step5 �������
while 1==1
CrossNo=0;
v1=vtemp1;
for i=1:N
    r1=unifrnd(0,1);
    if r1 < Pc
        CrossNo=CrossNo+1;
        vtemp2(CrossNo,:)=v1(i,:);
        v1(i,:)=zeros(1,n);
    end
end
if CrossNo~=0 & mod(CrossNo,2)==0
  break;
elseif CrossNo==0|mod(CrossNo,2)==1
    vtemp2=[];
end
end
shengyuNo=0;
for i=1:N
    if v1(i,:)~=zeros(1,n)
        shengyuNo=shengyuNo+1;
        vtemp3(shengyuNo,:)=v1(i,:);%vtemp3��ʾѡ���ʣ��ĸ���
    end
end
%���ѡ����Խ��н������
for i=1:CrossNo
    r2=ceil(unifrnd(0,1)*(CrossNo-i+1));
    vtemp4(i,:)=vtemp2(r2,:);
    vtemp2(r2,:)=[];
end
%=====================�����Խ�������˳��2��Ϊһ��==========================
for i=1:2:(CrossNo-1)
    while 1==1
        r3=unifrnd(0,1);
        v20(i,:)=r3*vtemp4(i,:)+(1-r3)*vtemp4(i+1,:);
        v20(i+1,:)=(1-r3)*vtemp4(i,:)+r3*vtemp4(i+1,:);
        temp1=sum(v20(i,:).^2);
        temp2=sum(v20(i+1,:).^2);
        v2(i,:)=sqrt(v20(i,:).^2/temp1);
        v2(i+1,:)=sqrt(v20(i+1,:).^2/temp2);      
        if Feasibility(v2(i,:))==1 & Feasibility(v2(i+1,:))==1
            break; 
        end
    end
end
%step5 end
v3=[vtemp3;v2];                     %�ϲ����沿�ֺ�ʣ�ಿ��
%step6 �������
while 1==1
    MutationNo=0;
    v4=v3;
    for i=1:N
        r4=unifrnd(0,1);
        if r4<Pm
            MutationNo=MutationNo+1;
            vtemp5(MutationNo,:)=v4(i,:);
            v4(i,:)=zeros(1,n);
        end
    end
    if MutationNo~=0
        break;
    end
end
%ѡ����б�������ĸ�������
shengyuNo1=0;
for i=1:N
    if v4(i,:)~=zeros(1,n)
        shengyuNo1=shengyuNo1+1;
        vtemp6(shengyuNo1,:)=v4(i,:);%vtemp6��ʾѡ���ʣ��ĸ���
    end
end
%���쿪ʼ
DirectionV=unifrnd(-1,1,1,n);
for i=1:MutationNo
    tempNo=0;
    while 1==1
        tempNo=tempNo+1;
        v5(i,:)=sqrt(((vtemp5(i,:)+M*DirectionV).^2)./sum((vtemp5(i,:)+M*DirectionV).^2));
        y=Feasibility(v5(i,:));
        if tempNo==200
            v5(i,:)=vtemp5(i,:);
            break;
        elseif y==1
            break;
        end
        M=unifrnd(0,M);
    end
end
%step6 end
vk=[v5;vtemp6];
v=vk;
end
%���������������ٽ�����Ӧ������
for i=1:N;
   fv(i)=Target(xx,v(i,:));%һ��400�е�Ȩ��ϵ����ѡ�񣬼���ÿһ�е���Ӧ�Ⱥ���ֵ��
end
%������Ӧ������
[fv,i]=sort(fv,ad);%����Ӧ�Ȱ��մ������µ�˳���������
v=v(i,:);    %��Ȩ��ϵ��Ҳ������Ӧ�ȵ������б��������
vk=v;
vv=vk(1:20,:); %ѡȡǰ20��Ϊ�������
t=1:n;
mm1(t)=min(vv(:,t));%����������У�20�У����ҳ�ÿһ������Сֵ����µ�һ��
mm2(t)=max(vv(:,t));%����������У�20�У����ҳ�ÿһ�������ֵ����µ�һ��
mmin(z,:)=mm1;%��z�μ����γɵ�  ���������Сֵ  ���
mmax(z,:)=mm2;%��z�μ����γɵ�  ����������ֵ  ���
if abs(mm1-mm2)<=0.00001
    break;
end
end
a=fv(1);   %�����ֵ
b=vv(1,:);  %�����ֵ��Ӧ�ı���ֵ��������壩
toc%���� a,b,mmin,mmax.