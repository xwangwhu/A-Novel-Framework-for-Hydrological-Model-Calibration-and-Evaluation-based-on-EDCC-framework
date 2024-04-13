%% Load data
clc; close; clear
file_path = '..\..\00 Data\04 Cloud model.xlsx';
data = xlsread(file_path, 'Data', "B2:K23");
data = data';

%% Critic
[n,m] = size(data);
Z = normalizef(data); % Normalize the data using an existing function from the documentation
R = corrcoef(Z);  % Compute the correlation coefficient matrix, but ensure all correlations are positive
for i = 1:m % Because R is a 32*32 matrix
    for j = 1:m
        if R(i,j) < 0
            R(i,j) = -R(i,j);
        end
    end
end
delta = zeros(1,m);
c = zeros(1,m);
for j = 1:m
    delta(j) = std(Z(:,j));
    c(j) = size(R,1) - sum(R(:,j));
end
C = delta .* c;
w_CRITIC = C ./ (sum(C)); % Comprehensive weight

%% Save weights to specific rows and columns in an EXCEL file
A = (w_CRITIC)';
sheet = 'Weights';
xlRange = 'E2';
xlswrite(file_path, A, sheet, xlRange);
disp('CRITIC method weight coefficients saved to'); disp(file_path);
