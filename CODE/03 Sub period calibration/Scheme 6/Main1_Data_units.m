clc; close;
clearvars -except Cluster Data Select nbasin fieldn FCM clustn num fieldname imain0 CallTimes DATA WindowSize length_day fieldnames Cluster_Veri

% Generate the date
Date.dates = datevec(datenum(['15-Jan-',num2str(1982)]):datenum(['31-Dec-',num2str(2000)]));
Date.year = Date.dates(:,1);
Date.Uyear = unique(Date.year);
Date.month = Date.dates(:,1)*100 + Date.dates(:,2);  
Date.Umonth = unique(Date.month);
Date.halfmonth = zeros(length(Date.dates),1);
for i = 1:length(Date.Umonth)
    ind = find(Date.month == Date.Umonth(i));
    Date.halfmonth(ind(1:round(length(ind)./2))) = Date.dates(ind(1:round(length(ind)./2)),1).*1000 + Date.dates(ind(1:round(length(ind)./2)),2).*10 + 1;  
    Date.halfmonth(ind(round(length(ind)./2)+1:end)) = Date.dates(ind(round(length(ind)./2)+1:end),1).*1000 + Date.dates(ind(round(length(ind)./2)+1:end),2).*10 + 2;
    clear i ind
end
Date.Uhalfmonth = unique(Date.halfmonth);
Date.day = Date.dates(:,1).*10000 + Date.dates(:,2).*100 + Date.dates(:,3);
Date.Uday = unique(Date.day);    

% Index of halfmonth, month, and year
Timescales = {'day','halfmonth','month','year'};
Elements = {'P','PE','Q'};
for i = 1:length(Timescales)    
    name0 = ['Index.',Timescales{i}];
    name1 = ['Date.',Timescales{i}];
    name = ['Date.U',Timescales{i}];
    
    eval(['Index.',Timescales{i},'=cell(length(',name,'),1);']);    
    for j = eval(['1:length(',name,')'])
        eval([name0,'{j}=find(',name1,'==',name,'(j));']);
        clear j
    end
    clear i name
end
clear name0 name1 Timescales Elements j

% Generating input
DATA = [Data.(num).day.P Data.(num).day.PE Data.(num).day.Q Data.(num).day.avgT];
DATA = cell2mat(DATA);
DATA = DATA((WindowSize):(length_day),:);
input.data.precip = DATA(:,1); % Mean areal precipitation (mm)
input.data.evap = DATA(:,2); % Climatic potential evaporation (mm)
input.data.flow = DATA(:,3); % Streamflow discharge (mm)
input.data.avgTemp = DATA(:,4); % Daily average temperature (℃)
input.date.nDays = length(input.data.flow);
input.date.year = Date.year(1:input.date.nDays);
input.date.day = Date.day(1:input.date.nDays);   

% Data for calibration
global hymod
hymod.data.precip = DATA(:,1); % Mean areal precipitation (mm)
hymod.data.evap = DATA(:,2); % Climatic potential evaporation (mm)
hymod.data.flow = DATA(:,3); % Streamflow discharge (mm)
hymod.data.avgTemp = DATA(:,4); % Daily average temperature (℃)
hymod.date.nDays = length(hymod.data.flow);
hymod.date.year = Date.year(1:hymod.date.nDays);
hymod.date.day = Date.day(1:hymod.date.nDays);
clear input DATA

% Sub-period
FCM.n_clusters = size(Cluster.(num).centers,1);
ID = cell(FCM.n_clusters+1,1);
ID{1,1} = (1:length(Cluster.(num).data))';
for i = 1:FCM.n_clusters
    fieldName = ['index' num2str(i)];
    ID{(i+1)} = Cluster.(num).(fieldName)';
end

% ID set for calibration
ID_cali = cell(size(ID));
for i = 1:numel(ID)
    ID_cali{i} = ID{i}(ID{i} > (365-WindowSize+1) & ID{i} <= length_day-WindowSize+1);
end
hymod.date.ID_cali = ID_cali;
clear i ID_cali

if ~exist('..\..\00 Data\Date.mat', 'file')
    save('..\..\00 Data\Date.mat', 'Date');
end
