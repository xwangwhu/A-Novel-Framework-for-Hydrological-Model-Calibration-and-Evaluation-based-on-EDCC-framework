function  [x,y,Ex,En,He]=cloud_transform(y_spor,n)
%x表示云滴；y这里表示钟形隶属度，意义是度量倾向的稳定程度；Ex表示云模型的数字特征，表示期望
%En表示云模型的数字特征，表示熵
%He表示云模型的数字特征，表示超熵
Ex=mean(y_spor);
En=mean(abs(y_spor-Ex).*sqrt(pi./2));%允许矩阵的某行减去1个数
He=sqrt(var(y_spor)-En.^2);%var返回每行的的方差

%通过云模型的数字特征来还原更多的云端
for q=1:n
    Enn=randn(1).*He+En;       %randn指生成正态分布数组x = .6 + sqrt(0.1) * randn(5)，均值为0.6，方差为0.1的一个5*5的随机数
    x(q)=randn(1).*Enn+Ex;      %.*表示两个矩阵对应元素相乘，要求两个矩阵行数列数都相等
    y(q)=exp(-(x(q)-Ex).^2./(2.*Enn.^2));% .^2两个矩阵对应元素平方
end
x;
y;
end

