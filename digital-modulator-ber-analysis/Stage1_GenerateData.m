%% Stage 1: Generate Random Data
clear; clc; close all;
rng(1);   % ثابت للـ Random Seed عشان تطلع نفس النتائج كل مرة (Reproducibility)

numBits = 1000;
dataBits = randi([0 1], 1, numBits);

disp('First 20 bits:');
disp(dataBits(1:20));
