%% define the first function to cope with segments
function [index_seg,segs] = Segments(Num, Cluster)
    % Num = 'N01064500';
    % input should be string
    
    % generate sequence index
    Index_day = 1:length(Cluster.(Num).data);
    Index_day = Index_day';

% get number of index
    index_n = length(Cluster.(Num).centers);

% Generate the corresponding cluster number
for i = 1:index_n
    index_i = num2str(i);
    index_i = ['Cluster.',Num,'.','index',index_i];
    index_cluster = eval(index_i);
    Index_day(index_cluster,2) = i;
end

% Merge data within a cluster
index_seg = [1 0];
index_type = [];
for i = 1:length(Index_day)-1
    cluster_n = Index_day(i,2);
    cluster_n1 = Index_day(i+1,2);
    if ~(cluster_n == cluster_n1)
        index_seg(end) = i;
        index_seg1 = [i+1,0];
        index_seg = [index_seg;index_seg1];
        index_type = [index_type;cluster_n];
    end
end
index_seg(end) = length(Index_day);
index_type = [index_type;cluster_n];
index_seg = [index_seg,index_type];

% segments in period
for j = 1:index_n
    for k = 1:length(Index_day)
        if Index_day(k,2) == j
            Index_day(k,j+2) = j;
        else
            Index_day(k,j+2) = -1;
        end
    end
end
segs = Index_day;
end

