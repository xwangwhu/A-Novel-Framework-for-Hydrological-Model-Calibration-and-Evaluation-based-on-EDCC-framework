%% Load data
clc; close; clear
file_path = '..\..\00 Data\04 Cloud model.xlsx';
data = xlsread(file_path, 'Data',"B2:K23");
data = data';

%% Entropy Method
R = data;
[m,n] = size(R);
R1 = zeros(m,n);

for i = 1:n
    R1(:,i) = (R(:,i)-min(R(:,i)))/(max(R(:,i))-min(R(:,i))); % Matrix normalization
end
ex = sum(R1);

R2 = zeros(m,n);
for k = 1:m
    for j = 1:n
        R2(k,j) = R1(k,j)/ex(j); % Calculate pij
    end
end

R3 = R2.*log(R2); % Calculate pij*log(pij)
R4 = R3;
R4(find(isnan(R4) == 1)) = 0; % Replace NaN values with 0
ex = sum(R4);
ex1 = -1/log(m)*ex; % Column information entropy. m is the number of objects.
ex2 = (1-ex1)/(n-sum(ex1)); % Column weights. n is the number of indicators.

%% Save weights to specific rows and columns in an EXCEL file
A = (ex2)';
sheet = 'Weights';
xlRange = 'D2';
xlswrite(file_path, A, sheet, xlRange);
disp('Entropy method weight coefficients saved to'); disp(file_path);
