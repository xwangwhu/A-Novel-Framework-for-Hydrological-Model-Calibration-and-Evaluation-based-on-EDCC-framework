%% load data
clc; close; clear
file_path = '..\..\..\00 Data\Scheme2_Weighting.xlsx';
data = xlsread(file_path, '数据',"B2:EE6");
data = data';

%% CRITIC Method
[n,m]=size(data);
Z=normalizef(data); % Normalize using the existing function in the document
R = corrcoef(Z);  % Calculate the correlation coefficient matrix, but need to make all correlation coefficient matrices positive
for i =1:m % Because R is a 32*32 dimensional matrix
    for j=1:m
        if R(i,j)<0
            R(i,j)=-R(i,j);
        end
    end
end
delta = zeros(1,m);
c = zeros(1,m);
for j=1:m
    delta(j) = std(Z(:,j));
    c(j)= size(R,1)-sum(R(:,j));
end
C = delta.*c;
w_CRTIC = C./(sum(C)); % Comprehensive weight

%% Save the weights to specific rows and columns in the EXCEL file
A=(w_CRTIC)';
sheet = 'Weight';
xlRange='E2';
xlswrite(file_path,A,sheet,'E2');
disp('CRITIC method weight coefficients have been saved to');disp(file_path);
