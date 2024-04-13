function w_b=Boyilun(w1,w2)
    a=w1;
    at=a';
    b=w2;
    bt=b';
    temp1=[at*a,at*b;
          bt*a,bt*b];
    temp2=[at*a;
           bt*b];
    temp_1=inv(temp1);%ÇóÄæ
    t=temp_1*temp2;

    t1=t(1)/sum(t);
    t2=t(2)/sum(t);
    w_b=a*t1+b*t2;
    w_bs=sum(w_b);
    disp(w_b);
    disp(w_bs);
end

