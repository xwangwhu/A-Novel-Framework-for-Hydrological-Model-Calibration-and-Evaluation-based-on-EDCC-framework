function [New_mat Index_ij]= sort_mat(A)
clc
[M,N]=size(A);
B=reshape(A,1,[]);%�������һ��
[new_xulie index]=sort(B,'descend');%��b���Ӵ�С��˳������

for i=1:M*N
    for j=1:N
        if index(i)>(j-1)*M  &  index(i)<=j*M   %�жϵ�ǰ������λ��
            l=j;                                %��ǰ��������
            h=index(i)-(j-1)*M;                 %��ǰ��������          
            Index_ij{i}=[h l];
        end
    end
end
New_mat=reshape(new_xulie,M,N);  %�¾���
Index_ij=reshape(Index_ij,M,N);  %�¾����Ӧԭ�����λ��
end
