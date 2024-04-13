%subfunction of RAGA_PPC
function y=Target(x,a)
[m,n]=size(x);
for i=1:m
    s1=0;
    for j=1:n
       s1=s1+a(j)*x(i,j);
    end
    z(i)=s1;
end
%��z�ı�׼��Sz
Sz=std(z);
%����z�ľֲ��ܶ�Dz
R=0.1*Sz;
s3=0;
for i=1:m
    for j=1:m
        r=abs(z(i)-z(j));
        t=R-r;
        if t>=0
            u=1;
        else
            u=0;
        end
        s3=s3+t*u;
    end
end
Dz=s3;
%����Ŀ�꺯��ֵQ
y=Sz*Dz;