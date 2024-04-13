clc; close; clear

file_path = '..\..\00 Data\04 Cloud model.xlsx';
data = xlsread(file_path, '判断矩阵');

%% A-B using the judgment matrix
W_AB = data(1:4, 1:4);
[w_AB, CI_AB, CR_AB] = PanDuanJuZhen(W_AB);
if CI_AB < 0.1
    xlswrite(file_path, w_AB, '判断矩阵', 'H4');
    xlswrite(file_path, CI_AB, '判断矩阵', 'G5');
    xlswrite(file_path, CR_AB, '判断矩阵', 'G7');
else
    disp('Consistency verification failed for matrix A-B. Please reassess the scores!');
end

%% B1-C
W_B1_C = data(12:17, 1:6);
[w_B1_C, CI_B1_C, CR_B1_C] = PanDuanJuZhen(W_B1_C);
if CR_B1_C < 0.1
    xlswrite(file_path, w_B1_C, '判断矩阵', 'J15');
    xlswrite(file_path, CI_B1_C, '判断矩阵', 'I16');
    xlswrite(file_path, CR_B1_C, '判断矩阵', 'I18');
else
    disp('Consistency verification failed for matrix B1-C. Please reassess the scores!');
end

%% B2-C
W_B2_C = data(29:33, 1:5);
[w_B2_C, CI_B2_C, CR_B2_C] = PanDuanJuZhen(W_B2_C);
if CR_B2_C < 0.1
    xlswrite(file_path, w_B2_C, '判断矩阵', 'I32');
    xlswrite(file_path, CI_B2_C, '判断矩阵', 'H33');
    xlswrite(file_path, CR_B2_C, '判断矩阵', 'H35');
else
    disp('Consistency verification failed for matrix B2-C. Please reassess the scores!');
end

%% B3-C
W_B3_C = data(42:47, 1:6);
[w_B3_C, CI_B3_C, CR_B3_C] = PanDuanJuZhen(W_B3_C);
if CI_B3_C < 0.1
    xlswrite(file_path, w_B3_C, '判断矩阵', 'J45');
    xlswrite(file_path, CI_B3_C, '判断矩阵', 'I46');
    xlswrite(file_path, CR_B3_C, '判断矩阵', 'I48');
else
    disp('Consistency verification failed for matrix B3-C. Please reassess the scores!');
end

%% B4-C
W_B4_C = data(59:63, 1:5);
[w_B4_C, CI_B4_C, CR_B4_C] = PanDuanJuZhen(W_B4_C);
if CR_B4_C < 0.1
    xlswrite(file_path, w_B4_C, '判断矩阵', 'I62');
    xlswrite(file_path, CI_B4_C, '判断矩阵', 'H63');
    xlswrite(file_path, CR_B4_C, '判断矩阵', 'H65');
else
    disp('Consistency verification failed for matrix B4-C. Please reassess the scores!');
end
