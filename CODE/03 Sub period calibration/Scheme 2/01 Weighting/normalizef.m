function [xd] = normalizef(x)
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% [n1,m1]= size(a);%Ĭ����һ��m1��
% x������Ȩ�صľ���a��Ȩ��ϵ��������Ҫ�Ŵ��������㷨�����Ż���
% a�൱������һ��matlab�ļ��е�v
[n,m] = size(x);
x_min = zeros(1,m);
x_max = zeros(1,m);
z = zeros(1,n);
 for j = 1:m
    x_min(j) = min(x(:,j));
    x_max(j) = max(x(:,j));
end
for i = 1:n
    for j = 1:m
        xd(i,j) = (x(i,j)-x_min(j))/(x_max(j)-x_min(j));
    end
end
end

