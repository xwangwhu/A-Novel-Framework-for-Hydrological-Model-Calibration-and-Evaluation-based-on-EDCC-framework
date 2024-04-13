%% load data
clc; close; clear
file_path = '..\..\..\00 Data\Scheme2_Weighting.xlsx';
Weight_Total_data = xlsread(file_path, 'Weight',"G2:I6");
Evaluation_data = xlsread(file_path, 'Data',"B2:EE6");

Cloud_up = [];
Cloud_dw = [];
XSD_T = [];
Ex_D_T = [];
Result_list = [];

for h = 1:size(Evaluation_data,2)
    Evaluation = Evaluation_data(:,h);
    X = Weight_Total_data;
    N = 1500;

    Ex_T = [];
    En_T = [];
    He_T = [];
    Wei_90_up = [];
    Wei_90_dw = [];
    Wei_95_up = [];
    Wei_95_dw = [];
    X_Cloud = [];
    Y_Cloud = [];

    for i = 1:size(X,1)
        [x, y, Ex, En, He] = cloud_transform(X(i,:), N);
        
        index_90 = find(y > 0.9 & y < 1);
        xx_90 = x(index_90);
        xx_90_upli = max(xx_90);
        xx_90_down = min(xx_90);
        Wei_90_up = [Wei_90_up, xx_90_upli];
        Wei_90_dw = [Wei_90_dw, xx_90_down];

        index_95 = find(y > 0.950 & y < 1);
        xx_95 = x(index_95);
        xx_95_upli = max(xx_95);
        xx_95_down = min(xx_95);
        Wei_95_up = [Wei_95_up, xx_95_upli];
        Wei_95_dw = [Wei_95_dw, xx_95_down];

        Ex_T = [Ex_T, Ex];
        En_T = [En_T, En];
        He_T = [He_T, He];
        X_Cloud = [X_Cloud x'];
        Y_Cloud = [Y_Cloud y'];
    end

    Ex_D = Ex_T * abs(Evaluation);
    En_D = En_T * abs(Evaluation);
    He_D = He_T * abs(Evaluation);

    xxx = [];
    for k = 1:N
        Enn_D = randn(1) * He_D + En_D;
        xx_D(k) = randn(1) * Enn_D + Ex_D;
        yy_D(k) = exp(-(xx_D(k) - Ex_D).^2 ./ (2 .* Enn_D.^2));
    end

    A_index_95 = find(yy_D > 0.950 & yy_D < 1);
    xx_D_95 = xx_D(A_index_95);
    xx_D_95_upli = max(xx_D_95);
    xx_D_95_down = min(xx_D_95);
    Cloud_up = [Cloud_up, xx_D_95_upli];
    Cloud_dw = [Cloud_dw, xx_D_95_down];
end

sheet1 = 'Total Results';
sheet2 = 'Weight';
xlswrite(file_path, Ex_T', sheet2, 'K2'); % Weight mean value
xlswrite(file_path, Wei_90_up', sheet2, 'L2');
xlswrite(file_path, Wei_90_dw', sheet2, 'M2');
xlswrite(file_path, Wei_95_up', sheet2, 'N2');
xlswrite(file_path, Wei_95_dw', sheet2, 'O2');
