function [w,CI,CR]=PanDuanJuZhen(W)
    [m,n]=size(W);
    [V,D]=eig(W);%�����������������ֵ
                %����������ֵ��������Ӧ����������
    tempNum1=D(1,1);
    pos=1;
    for h=1:n
        if D(h,h)>tempNum1
            tempNum1=D(h,h);
            pos=h;
        end
    end    
    w=abs(V(:,pos));
    w=w/sum(w);
    t=D(pos,pos);
%     disp('Ȩ��w=');disp(w);disp('���������t=');disp(t);
             %������һ���Լ���
    CI=(t-n)/(n-1);RI=[0 0 0.58 0.89 1.12 1.26 1.36 1.41 1.46 1.49 1.52 1.54 1.56 1.58 1.59 1.60 1.61 1.615 1.62 1.63];
    CR=CI/RI(n);
    if CR<0.10
        disp('��');disp(W);disp('�����һ���Կ��Խ���!')
    elseif isnan(CR)==1 && n==2
        disp('��');disp(W);disp('�����һ���Կ��Խ���!')
    else
        disp('�˾����һ������֤ʧ�ܣ������½�������!');
    end
end