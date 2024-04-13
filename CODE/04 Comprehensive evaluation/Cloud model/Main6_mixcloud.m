%% Load data
clc; close; clear
file_path = '..\..\00 Data\04 Cloud model.xlsx';
Weight_Total_data = xlsread(file_path, 'Weights', "G2:I23");
Evaluation_data = xlsread(file_path, 'Data', "B2:K23");

% Image names
image_names = ["1_N13302500", "1_N04073500", "1_N05280000", "1_N06192500", "1_N08085500", "2_N13302500", "2_N04073500", "2_N05280000", "2_N06192500", "2_N08085500"];
image_names1 = ["N13302500", "N04073500", "N05280000", "N06192500", "N08085500","N13302500", "N04073500", "N05280000", "N06192500", "N08085500"];

% Data processing
Cloud_up = [];
Cloud_dw = [];
XSD_T = [];
Ex_D_T = [];
En_D_T = [];
He_D_T = [];
Result_list = [];

%% 1. Generation of weight clouds for each index
for h = 1:size(Evaluation_data,2)
    Evaluation = Evaluation_data(:,h);
    X = Weight_Total_data;
    N = 1500; % Number of clouds generated for each image
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
        [x,y,Ex,En,He] = cloud_transform(X(i,:),N); % Cloud calculation for each index
        % Calculating interval values when y>0.9 and y>0.950
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

        Ex_T = [Ex_T, Ex]; % Save cloud characteristics for each index
        En_T = [En_T, En];
        He_T = [He_T, He];
        X_Cloud = [X_Cloud x'];
        Y_Cloud = [Y_Cloud y'];
    end

    %% 2. Comprehensive cloud calculation of hydrological alteration degree
    Ex_D = Ex_T * abs(Evaluation);
    En_D = En_T * abs(Evaluation);
    He_D = He_T * abs(Evaluation);

    % 3. Similarity calculation of clouds
    BZ = [0, 0.2, 0.4, 0.6, 1];
    for i = 1:4
        Ex_BZ(i) = (BZ(i) + BZ(i+1))/2;
        En_BZ(i) = (BZ(i+1) - BZ(i))/6;
        He_BZ(i) = 0.1 * En_BZ(i);

        for q = 1:N
            Enn(i) = randn(1) * He_BZ(i) + En_BZ(i);
            xx(q, i) = randn(1) * Enn(i) + Ex_BZ(i);
            yy(q, i) = exp(-(xx(q, i) - Ex_BZ(i))^2 / (2 * Enn(i)^2));
        end
    end

    % 4. Cloud similarity calculation
    for i = 1:size(Ex_BZ,2)
        XSD(i) = CFSM(Ex_D, Ex_BZ(i), En_D, En_BZ(i), He_D, He_BZ(i));
    end

    XSD_T = [XSD_T; XSD];
    [XSD_max, XSD_index] = max(XSD);
    if XSD_index == 1
        Result = 1;
        disp('The accuracy of this basin forecast reaches Class A standard');
    elseif XSD_index == 2
        Result = 2;
        disp('The accuracy of this basin forecast reaches Class B standard');
    elseif XSD_index == 3
        Result = 3;
        disp('The accuracy of this basin forecast reaches Class C standard');
    elseif XSD_index == 4
        Result = 3;
        disp('The accuracy of this basin forecast reaches Class D standard');
    end
    Result_list = [Result_list, Result];
    Ex_D_T = [Ex_D_T, Ex_D];
    En_D_T = [En_D_T, En_D];
    He_D_T = [He_D_T, He_D];
end

%% Save data
sheet1 = 'Total Results';
xlswrite(file_path, Result_list', sheet1, 'K11'); % Similarity level
xlswrite(file_path, XSD_T, sheet1, 'N11'); % Total similarity results

sheet2 = 'Weights';
xlswrite(file_path, Ex_T', sheet2, 'K2'); % Weight average
xlswrite(file_path, Wei_90_up', sheet2, 'L2');
xlswrite(file_path, Wei_90_dw', sheet2, 'M2');
xlswrite(file_path, Wei_95_up', sheet2, 'N2');
xlswrite(file_path, Wei_95_dw', sheet2, 'O2');

xlswrite(file_path, Ex_D_T, 'Character', 'B2'); % Evaluation cloud characteristics Ex
xlswrite(file_path, En_D_T, 'Character', 'B3'); % Evaluation cloud characteristics En
xlswrite(file_path, He_D_T, 'Character', 'B4'); % Evaluation cloud characteristics Ex

xlswrite(file_path, Cloud_up', sheet1, 'L11'); % Cloud variability upper limit
xlswrite(file_path, Cloud_dw', sheet1, 'M11'); % Cloud variability lower limit
