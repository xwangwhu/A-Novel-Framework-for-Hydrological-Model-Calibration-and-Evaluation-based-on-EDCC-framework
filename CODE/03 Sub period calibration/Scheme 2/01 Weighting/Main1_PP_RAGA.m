clc; close; clear
file_path = '..\..\..\00 Data\Scheme2_Weighting.xlsx';
data = xlsread(file_path, '数据', 'B2:EE6');
data = data';
[m, n] = size(data);
d = []; e = [];
for k = 1:50
    data = normalizef(data);
    N = 400; Pc = 0.8; Pm = 0.2; M = 10; Ci = 7; DaiNo = 2; ads = 1;
    [a1, b1, ee, ff] = RAGA(data, N, n, Pc, Pm, M, DaiNo, Ci, ads);
    d = [d, a1]; e = [b1; e];
end
[a2, b2] = max(d);
e1 = e(b2, :);
ff = e1 * data';

A = (e1.^2)';
sheet = '权重';
xlRange = 'C2';
xlswrite(file_path, A, sheet, xlRange);
disp('Projection trace coefficient saved to'); disp(file_path);
