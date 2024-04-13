% Root mean square error
function rmse1 = RMSE1(Qobs, Qsim)
    n = length(Qobs);  % 获取观测流量和模拟流量数据序列的长度
    rmse1 = sqrt(sum((Qobs - Qsim).^2) / n);  % 计算RMSE
end