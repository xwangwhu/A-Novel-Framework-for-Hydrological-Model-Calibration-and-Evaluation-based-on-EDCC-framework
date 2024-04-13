%% define the main function to output whole period segments
function [seg_cali,seg_veri,seg_whole,segs_whole] = Segments_whole(Num,Cluster,Cluster_Veri)
    [seg_cali,segs_cali] = Segments(Num,Cluster);
    [seg_veri,segs_veri] = Segments(Num,Cluster_Veri);
    seg_veri(:,1:2) = seg_veri(:,1:2) + 5099;
    segs_veri(:,1) = segs_veri(:,1) + 5099;
    

    % merge cali and veri as whole
    if seg_cali(end) == seg_veri(1,3)
        seg_m = seg_cali(end,:);
        seg_m(2) = seg_veri(1,2);
        seg_whole = [seg_cali(1:end-1,:);seg_m;seg_veri(2:end,:)];
    else
        seg_whole = [seg_cali;seg_veri];
    end
    segs_whole = [segs_cali;segs_veri];
end
