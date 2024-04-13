function [New_mat Index_ij]= sort_mat(A)
clc
[M,N]=size(A);
B=reshape(A,1,[]);%将其放在一行
[new_xulie index]=sort(B,'descend');%将b按从大到小的顺序排列

for i=1:M*N
    for j=1:N
        if index(i)>(j-1)*M  &  index(i)<=j*M   %判断当前索引的位置
            l=j;                                %当前索引的列
            h=index(i)-(j-1)*M;                 %当前索引的行          
            Index_ij{i}=[h l];
        end
    end
end
New_mat=reshape(new_xulie,M,N);  %新矩阵
Index_ij=reshape(Index_ij,M,N);  %新矩阵对应原矩阵的位置
end
