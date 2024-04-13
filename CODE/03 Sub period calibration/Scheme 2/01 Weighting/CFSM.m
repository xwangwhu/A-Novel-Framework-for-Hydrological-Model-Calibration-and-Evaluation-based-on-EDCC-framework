%计算变异度
function D=CFSM(Ex2,Ex1,En2,En1,He2,He1)
    m=(abs(Ex2-Ex1))/(sqrt(En1.^2+He1.^2)+sqrt(En2.^2+He2.^2))
    syms x
    z=int((exp((-x^2)/2))/sqrt(2*pi),-inf,m)%求积分
    z_d=double(z)%
    D=1/2+1/(2*z_d)-z_d;
end

