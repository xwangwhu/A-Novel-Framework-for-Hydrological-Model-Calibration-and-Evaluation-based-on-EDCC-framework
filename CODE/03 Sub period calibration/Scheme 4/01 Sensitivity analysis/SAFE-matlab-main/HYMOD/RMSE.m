function Rmse=RMSE(QOBS,Qt)
qobs=sort(QOBS,'descend');qt=sort(Qt,'descend');
data=[log(qobs+eps),log(qt+eps)];
N=1:length(QOBS);
flag=[0  fix(prctile(N,5)) fix(prctile(N,20)) fix(prctile(N,70)) fix(prctile(N,95)) N(end)];
Rmse=ones(1,length(flag)-1);
for i=2:length(flag)
    DATA=data(flag(i-1)+1:flag(i),:); %更改数据类型
    n=length(DATA);
    rmse = sqrt(sum((DATA(:,1)-DATA(:,2)).^2)./n);
    Rmse(i-1)=rmse;
    clearvars n DATA rmse
end
