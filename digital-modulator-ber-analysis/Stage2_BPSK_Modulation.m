%% Stage 2: BPSK Modulation
clear; clc; close all;
rng(1);

numBits = 1000;
dataBits = randi([0 1], 1, numBits);

bpskSymbols = 2*dataBits - 1;   % 0 -> -1 , 1 -> +1

disp('First 20 BPSK symbols:');
disp(bpskSymbols(1:20));

figure;
stem(bpskSymbols(1:20), 'filled');
title('BPSK Symbols (first 20)');
xlabel('Symbol Index');
ylabel('Amplitude');
grid on;

saveas(gcf, 'Stage2_BPSK_Symbols.png');
