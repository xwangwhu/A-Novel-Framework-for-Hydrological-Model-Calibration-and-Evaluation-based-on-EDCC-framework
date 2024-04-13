% Nash-Sutcliffe efficiency
function  [ns]=NSE(obs,sim)
obs=obs(2:end);sim=sim(2:end);
ns=1-sum((obs-sim).^2)./sum((obs-mean(obs)).^2);