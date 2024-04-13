% Log Nash-Sutcliffe efficiency
function  [ns]=LNSE(OBS,SIM)
OBS=OBS(2:end);SIM=SIM(2:end);
obs=log(OBS+eps);sim=log(SIM+eps);
ns=1-sum((obs-sim).^2)./sum((obs-mean(obs)).^2);