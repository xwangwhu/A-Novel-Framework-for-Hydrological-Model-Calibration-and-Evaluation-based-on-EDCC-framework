% min_best�Ӻ�����
function [change_x]=min_best(x)
  r=size(x,1);
  change_x = repmat(max(x),r,1)-x;
end