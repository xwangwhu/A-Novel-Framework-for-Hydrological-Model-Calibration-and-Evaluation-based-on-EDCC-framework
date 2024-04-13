close;clc;clear;

nums = {'N13302500','N08085500','N05280000','N06192500'};

addpath(genpath(pwd))
filepath = pwd;
cd (filepath)
cd ../../'03 Sub period calibration'/'01 recommend scheme'/
run Main04_Evaluate.m

cd (filepath)
cd ../../'03 Sub period calibration'/'02 水平衡'/'02 Calibration'/
run Main04_Evaluate.m

cd (filepath)
cd ../../'03 Sub period calibration'/'03 参数补偿效应'/'02 补偿效应'/
run Main04_Evaluate.m

cd (filepath)
cd ../../'03 Sub period calibration'/'04 高维空间'/
run Main04_Evaluate.m

cd (filepath)
cd ../../'03 Sub period calibration'/'05 参数突变'/
run Main04_Evaluate.m