%% load data
clc; close; clear
file_path = '..\..\..\00 Data\Scheme2_Weighting.xlsx';
data = xlsread(file_path, '数据',"B2:EE6");
data = data';

%% Entropy Weight Method
R=data;
[m,n] = size(R);
R1 = zeros(m,n);

for i = 1:n
    R1(:,i) = (R(:,i)-min(R(:,i)))/(max(R(:,i))-min(R(:,i))); % Matrix normalization
end
ex=sum(R1);

R2=zeros(m,n);
for k=1:m
    for j=1:n
        R2(k,j)=R1(k,j)/ex(j); % Calculate pij
    end
end

% Calculate the weight of each index ex2 - the main matrix needed
R3=R2.*log(R2); % Calculate pij*lnpij
R4=R3;
R4(find(isnan(R4)==1)) = 0; % Replace NAN values with 1
ex=sum(R4); % Calculate sum (pij*lnpij)
ex1=-1/log(m)*ex; % Information entropy per column, m is the number of objects
ex2=(1-ex1)/(n-sum(ex1)); % Weight per column, n is the number of indicators

%% Save the weights to specific rows and columns in the EXCEL file
A=(ex2)';
sheet = 'Weight';
xlRange='D2';
xlswrite(file_path,A,sheet,'D2');
disp('Entropy weight coefficients have been saved to');disp(file_path);
