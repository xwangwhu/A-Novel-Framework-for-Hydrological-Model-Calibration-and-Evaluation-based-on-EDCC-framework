%% Load data
clc; close; clear
file_path = '..\..\00 Data\04 Cloud model.xlsx';
Simp_Weight_Data = xlsread(file_path, 'Weights', "B2:E23");

%% Calculate game theory combined weights
w_AHP = Simp_Weight_Data(:,1);
w_PP = Simp_Weight_Data(:,2);
w_Shangquan = Simp_Weight_Data(:,3);
w_CRITIC = Simp_Weight_Data(:,4);

wb_AHP_PP = Boyilun(w_AHP, w_PP);
wb_AHP_Shangquan = Boyilun(w_AHP, w_Shangquan);
wb_AHP_CRITIC = Boyilun(w_AHP, w_CRITIC);

%% Save weights to specific rows and columns in an EXCEL file
sheet = 'Weights';
xlswrite(file_path, wb_AHP_PP, sheet, 'G2');
xlswrite(file_path, wb_AHP_Shangquan, sheet, 'H2');
xlswrite(file_path, wb_AHP_CRITIC, sheet, 'I2');

disp('These combined weight coefficients are saved to'); disp(file_path);
