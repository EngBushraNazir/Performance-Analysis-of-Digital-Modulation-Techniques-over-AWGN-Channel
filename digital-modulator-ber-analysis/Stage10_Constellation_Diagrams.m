%% Stage 10: Constellation Diagrams
clear; clc; close all;
rng(1);

numBits = 100000;
dataBits = randi([0 1], 1, numBits);

bpskSymbols = 2*dataBits - 1;

if mod(numBits, 2) ~= 0
    dataBits_qpsk = [dataBits 0];
else
    dataBits_qpsk = dataBits;
end
I_bits = dataBits_qpsk(1:2:end);
Q_bits = dataBits_qpsk(2:2:end);
qpskSymbols = ((2*I_bits-1) + 1i*(2*Q_bits-1)) / sqrt(2);

if mod(numBits, 4) ~= 0
    padLen = 4 - mod(numBits, 4);
    dataBits_qam = [dataBits zeros(1, padLen)];
else
    dataBits_qam = dataBits;
end
bitGroups = reshape(dataBits_qam, 4, []).';
levelMap = [-3 -1 3 1];
idxI = bitGroups(:,1)*2 + bitGroups(:,2) + 1;
idxQ = bitGroups(:,3)*2 + bitGroups(:,4) + 1;
qamSymbols = (levelMap(idxI).' + 1i*levelMap(idxQ).') / sqrt(10);

SNR_vis = 10;   % SNR value used to visualize noise effect

figure;

% --- BPSK ---
noiseVar = mean(bpskSymbols.^2) / (10^(SNR_vis/10)) / 2;
noisy_bpsk = bpskSymbols(1:2000) + sqrt(noiseVar)*randn(1,2000);
subplot(1,3,1);
plot(real(noisy_bpsk), zeros(size(noisy_bpsk)), '.');
title('BPSK Constellation'); xlabel('I'); ylabel('Q');
grid on; axis equal; xlim([-2 2]); ylim([-2 2]);

% --- QPSK ---
Eb_qpsk = mean(abs(qpskSymbols).^2)/2;
noiseVar = Eb_qpsk / (10^(SNR_vis/10)) / 2;
subset = qpskSymbols(1:1000);
noisy_qpsk = subset + sqrt(noiseVar)*(randn(size(subset))+1i*randn(size(subset)));
subplot(1,3,2);
plot(real(noisy_qpsk), imag(noisy_qpsk), '.');
title('QPSK Constellation'); xlabel('I'); ylabel('Q');
grid on; axis equal; xlim([-2 2]); ylim([-2 2]);

% --- 16-QAM ---
Eb_qam = mean(abs(qamSymbols).^2)/4;
noiseVar = Eb_qam / (10^(SNR_vis/10)) / 2;
subset = qamSymbols(1:500);
noisy_qam = subset + sqrt(noiseVar)*(randn(size(subset))+1i*randn(size(subset)));
subplot(1,3,3);
plot(real(noisy_qam), imag(noisy_qam), '.');
title('16-QAM Constellation'); xlabel('I'); ylabel('Q');
grid on; axis equal; xlim([-2 2]); ylim([-2 2]);

saveas(gcf, 'Constellation_Comparison.png');
