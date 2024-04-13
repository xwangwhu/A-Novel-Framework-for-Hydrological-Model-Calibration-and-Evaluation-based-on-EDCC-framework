function KGE = KGE(Qo, Qs)
% 输入变量
% Qs    模拟径流
% Qo   实测径流
% 输出变量
% KGE       克林-古普塔效率系数（Kling-Gupta efficiency coefficient, KGE）

if length(Qs)==length(Qo)
    QsAve = mean(Qs);
    QoAve = mean(Qo);
    COV = cov(Qs, Qo);
    CC = COV(1,2)/std(Qs)/std(Qo);
    BR = QsAve/QoAve;
    RV = ( std(Qs)/QsAve )/ ( std(Qo)/QoAve );
    KGE = 1- ( (CC)^2+(BR+1)^2+(RV-1)^2 )^0.5;
    KGE = 1-KGE;
else
    error("实测径流和模拟径流长度不等");
end

end
