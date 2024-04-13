function date = ID(num,WindowSize,length_day,Cluster,Cluster_Veri)

    %---Sub-period
    FCM.n_clusters = size(Cluster.(num).centers,1);
    %---ID set for whole period
    ID=cell(FCM.n_clusters+1,1);
    % Whole period
    ID{1,1}= (1:length(Cluster.(num).data))';
    % Sub_period
    % Calibration period
    for i=1:FCM.n_clusters
        fieldName = ['index' num2str(i)];
        ID{(i+1)} = Cluster.(num).(fieldName)';
    end
    % Verification period
    ID_V=cell(FCM.n_clusters+1,1);
    ID_V{1,1}= (1:length(Cluster_Veri.(num).data))';
    for i=1:FCM.n_clusters
        fieldName = ['index' num2str(i)];
        ID_V{(i+1)} = Cluster_Veri.(num).(fieldName)';
    end
    % Add ID of verification period to the end of ID
    for i = 1:length(ID_V)
        ID_V{i} = ID_V{i} + length_day-WindowSize+1;
    end

    % 将 ID_V 添加至 ID 中对应位置的后面
    for i = 1:length(ID)
        ID{i} = [ID{i}; ID_V{i}];
    end
    date.ID=ID;
    clear i halfmonth0 halfmonth1 halfmonth1 halfmonth2 num_cali num_veri fieldName ID_V

    %---ID set for calibration
    ID_cali = cell(size(ID));
    for i = 1:numel(ID)
        ID_cali{i} = ID{i}(ID{i} > (365-WindowSize+1) & ID{i} <= length_day-WindowSize+1);
    end
    date.ID_cali=ID_cali;
    clear i ID_cali
    

    %---ID set for verification
    ID_veri = cell(size(ID));
    for i = 1:numel(ID)
        ID_veri{i} = ID{i}( ID{i} > length_day-WindowSize+1);
    end
    date.ID_veri=ID_veri;

    clear i ID_veri
    clear i ID