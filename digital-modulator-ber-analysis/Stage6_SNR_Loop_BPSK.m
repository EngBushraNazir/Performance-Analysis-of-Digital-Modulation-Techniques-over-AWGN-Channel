%% Stage 6: Repeat for Multiple SNR Values (BPSK) + Plot
clear; clc; close all;
rng(1);

numBits = 1000;
dataBits = randi([0 1], 1, numBits);
bpskSymbols = 2*dataBits - 1;

SNR_range = 0:2:12;     % 0, 2, 4, 6, 8, 10, 12 dB
BER_BPSK = zeros(1, length(SNR_range));

for k = 1:length(SNR_range)
    SNR_dB = SNR_range(k);

    signalPower = mean(bpskSymbols.^2);
    EbN0_linear = 10^(SNR_dB/10);
    Eb = signalPower;
    N0 = Eb / EbN0_linear;
    noiseVar = N0/2;

    noise = sqrt(noiseVar) * randn(1, numBits);
    receivedSymbols = bpskSymbols + noise;

    receivedBits = receivedSymbols > 0;

    numErrors = sum(receivedBits ~= dataBits);
    BER_BPSK(k) = numErrors / numBits;

    fprintf('SNR = %2d dB -> BER = %.5f\n', SNR_dB, BER_BPSK(k));
end

figure;
semilogy(SNR_range, BER_BPSK, '-o', 'LineWidth', 1.6);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR for BPSK');

saveas(gcf, 'Stage6_BER_vs_SNR_BPSK.png');
