%subfunction of RAGA_PPC
function y=Feasibility(a)
b=sum(a.^2);
if abs(b-1)<=0.00001
    y=1;
else
    y=0;
end