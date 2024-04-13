clc; clear

file_path = '..\..\00 Data\04 Cloud model.xlsx';
Weight_Total_data = xlsread(file_path, 'Weights', 'B2:E23');
Weight_CM_MW_Ex = xlsread(file_path, 'Weights', 'K2:K23');
Evaluation_data = xlsread(file_path, 'Data', 'B2:K23');

n = size(Evaluation_data, 2);
w_RVA = ones(1, size(Evaluation_data, 1)) / size(Evaluation_data, 1);
w_AHP = Weight_Total_data(:, 1);
w_PP = Weight_Total_data(:, 2);
w_Shangquan = Weight_Total_data(:, 3);
w_CRITIC = Weight_Total_data(:, 4);
w_CM_MW_Ex = Weight_CM_MW_Ex;

for h = 1:n
    evaluate_RVA = AlterDegree(w_RVA, Evaluation_data(:, h));
    evaluate_AHP = AlterDegree(w_AHP, Evaluation_data(:, h));
    evaluate_PP = AlterDegree(w_PP, Evaluation_data(:, h));
    evaluate_Shangquan = AlterDegree(w_Shangquan, Evaluation_data(:, h));
    evaluate_CRITIC = AlterDegree(w_CRITIC, Evaluation_data(:, h));
    evaluate_CM_MW_Ex = AlterDegree(w_CM_MW_Ex, Evaluation_data(:, h));

    xlRange_RVA = ['C', num2str(h+2)];
    xlRange_AHP = ['E', num2str(h+2)];
    xlRange_PP = ['G', num2str(h+2)];
    xlRange_Shangquan = ['I', num2str(h+2)];
    xlRange_CRITIC = ['K', num2str(h+2)];
    xlRange_CM_MW_Ex = ['M', num2str(h+2)];
    sheet = 'Comparison';
    
    % Write evaluation results to Excel
    xlswrite(file_path, evaluate_RVA, sheet, xlRange_RVA)
    xlswrite(file_path, evaluate_AHP, sheet, xlRange_AHP)
    xlswrite(file_path, evaluate_PP, sheet, xlRange_PP)
    xlswrite(file_path, evaluate_Shangquan, sheet, xlRange_Shangquan)
    xlswrite(file_path, evaluate_CRITIC, sheet, xlRange_CRITIC)
    xlswrite(file_path, evaluate_CM_MW_Ex, sheet, xlRange_CM_MW_Ex)
end
