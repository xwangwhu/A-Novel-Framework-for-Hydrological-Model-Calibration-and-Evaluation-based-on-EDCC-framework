% Ratio of root mean square error and dtandard deviation
function rsr = RSR(Qobs, Qsim)
    n = length(Qobs);  % 获取观测流量和模拟流量数据序列的长度
    rmse = sqrt(sum((Qobs - Qsim).^2) / n);  % 计算RMSE
    std_dev = std(Qobs);  % 计算观测流量的标准差
    rsr = rmse / std_dev;  % 计算RSR
end