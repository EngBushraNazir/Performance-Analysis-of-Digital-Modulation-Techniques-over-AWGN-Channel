%% Stage 3: AWGN Channel
clear; clc; close all;
rng(1);

numBits = 1000;
dataBits = randi([0 1], 1, numBits);
bpskSymbols = 2*dataBits - 1;

SNR_dB = 5;   % نجرب قيمة SNR واحدة الحين

signalPower = mean(bpskSymbols.^2);
EbN0_linear = 10^(SNR_dB/10);
Eb = signalPower;        % BPSK: bit واحد لكل symbol
N0 = Eb / EbN0_linear;
noiseVar = N0/2;

noise = sqrt(noiseVar) * randn(1, numBits);
receivedSymbols = bpskSymbols + noise;

disp('First 20 received symbols (with noise):');
disp(receivedSymbols(1:20));

figure;
stem(bpskSymbols(1:20), 'filled'); hold on;
stem(receivedSymbols(1:20), 'r');
legend('Original (Tx)', 'Received (Rx with noise)');
title('Effect of AWGN Noise on BPSK Symbols');
xlabel('Symbol Index');
ylabel('Amplitude');
grid on;

saveas(gcf, 'Stage3_AWGN_Effect.png');
