%% Stage 4: Receiver (BPSK Demodulation)
clear; clc; close all;
rng(1);

numBits = 1000;
dataBits = randi([0 1], 1, numBits);
bpskSymbols = 2*dataBits - 1;

SNR_dB = 5;
signalPower = mean(bpskSymbols.^2);
EbN0_linear = 10^(SNR_dB/10);
Eb = signalPower;
N0 = Eb / EbN0_linear;
noiseVar = N0/2;

noise = sqrt(noiseVar) * randn(1, numBits);
receivedSymbols = bpskSymbols + noise;

receivedBits = receivedSymbols > 0;   % Decision rule: >0 -> 1, else -> 0

disp('First 20 original bits:');
disp(dataBits(1:20));

disp('First 20 received bits:');
disp(receivedBits(1:20));
