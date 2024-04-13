function [xd] = normalizef(x)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
% [n1,m1]= size(a);%默认是一行m1列
% x是所需权重的矩阵，a是权重系数矩阵（需要遗传函数等算法进行优化）
% a相当于在另一个matlab文件中的v
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

