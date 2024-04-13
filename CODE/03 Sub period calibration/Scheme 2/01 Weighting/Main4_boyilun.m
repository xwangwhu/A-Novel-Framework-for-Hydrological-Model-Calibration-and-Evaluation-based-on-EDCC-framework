%% load data
clc; close; clear
file_path = '..\..\..\00 Data\Scheme2_Weighting.xlsx';
Simp_Weight_Data = xlsread(file_path, '权重',"B2:EE6");

%% Calculate game theory combination weights
w_AHP = Simp_Weight_Data(:,1);
w_PP = Simp_Weight_Data(:,2);
w_Shangquan = Simp_Weight_Data(:,3);
w_CRITIC = Simp_Weight_Data(:,4);

wb_AHP_PP = Boyilun(w_AHP, w_PP);
wb_AHP_Shangquan = Boyilun(w_AHP, w_Shangquan);
wb_AHP_CRITIC = Boyilun(w_AHP, w_CRITIC);

%% Save the weights to specific rows and columns in the EXCEL file
sheet = 'Weight';
xlswrite(file_path, wb_AHP_PP, sheet, 'G2');
xlswrite(file_path, wb_AHP_Shangquan, sheet, 'H2');
xlswrite(file_path, wb_AHP_CRITIC, sheet, 'I2');

disp('These combination weight coefficients have been saved to'); disp(file_path);
