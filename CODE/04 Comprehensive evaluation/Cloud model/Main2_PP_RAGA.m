clc; close; clear

%% Load data
file_path = '..\..\00 Data\04 Cloud model.xlsx';
data = xlsread(file_path, '数据', 'B2:K23');
data = data';

%% PP_RAGA
[m, n] = size(data);
d = [];
e = [];
for k = 1:50
    data = normalizef(data); % Normalize data
    N = 400; 
    Pc = 0.8; 
    Pm = 0.2; 
    M = 10; 
    Ci = 7; 
    DaiNo = 2; 
    ads = 1;
    [a1, b1, ee, ff] = RAGA(data, N, n, Pc, Pm, M, DaiNo, Ci, ads);
    d = [d, a1];
    e = [b1; e]; % Store the best individual in each loop: the ranking of the optimal weight coefficient
end

% Find the best result among 50 loops
[a2, b2] = max(d);
e1 = e(b2, :); % The best ranking of weight coefficients among 50 loops
ff = e1 * data';

%% Save weights to specific rows and columns in an EXCEL file
A = (e1.^2)';
sheet = '权重';
xlRange = 'C2';
xlswrite(file_path, A, sheet, xlRange);
disp(['The projection tracking coefficient has been saved to ', file_path]);
