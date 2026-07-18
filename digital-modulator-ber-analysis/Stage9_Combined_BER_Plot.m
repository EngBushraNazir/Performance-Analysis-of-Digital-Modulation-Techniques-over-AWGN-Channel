%% Stage 9: Combined BER vs SNR (BPSK vs QPSK vs 16-QAM) - Final Results
clear; clc; close all;
rng(1);

numBits = 100000;   % higher bit count for accurate final results
dataBits = randi([0 1], 1, numBits);

% ---------------- BPSK ----------------
bpskSymbols = 2*dataBits - 1;

% ---------------- QPSK ----------------
if mod(numBits, 2) ~= 0
    dataBits_qpsk = [dataBits 0];
else
    dataBits_qpsk = dataBits;
end
I_bits = dataBits_qpsk(1:2:end);
Q_bits = dataBits_qpsk(2:2:end);
qpskSymbols = ((2*I_bits-1) + 1i*(2*Q_bits-1)) / sqrt(2);

% ---------------- 16-QAM ----------------
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

SNR_range = 0:2:12;
BER_BPSK  = zeros(1, length(SNR_range));
BER_QPSK  = zeros(1, length(SNR_range));
BER_16QAM = zeros(1, length(SNR_range));

for k = 1:length(SNR_range)
    SNR_dB = SNR_range(k);

    % --- BPSK ---
    signalPower = mean(bpskSymbols.^2);
    noiseVar = (signalPower) / (10^(SNR_dB/10)) / 2;
    rx = bpskSymbols + sqrt(noiseVar)*randn(size(bpskSymbols));
    rxBits = rx > 0;
    BER_BPSK(k) = sum(rxBits ~= dataBits) / numBits;

    % --- QPSK ---
    signalPower = mean(abs(qpskSymbols).^2);
    Eb = signalPower/2;
    noiseVar = Eb / (10^(SNR_dB/10)) / 2;
    rx = qpskSymbols + sqrt(noiseVar)*(randn(size(qpskSymbols))+1i*randn(size(qpskSymbols)));
    rx_I = real(rx) > 0; rx_Q = imag(rx) > 0;
    rxBits = zeros(1, 2*length(rx));
    rxBits(1:2:end) = rx_I; rxBits(2:2:end) = rx_Q;
    rxBits = rxBits(1:numBits);
    BER_QPSK(k) = sum(rxBits ~= dataBits) / numBits;

    % --- 16-QAM ---
    signalPower = mean(abs(qamSymbols).^2);
    Eb = signalPower/4;
    noiseVar = Eb / (10^(SNR_dB/10)) / 2;
    rx = qamSymbols + sqrt(noiseVar)*(randn(size(qamSymbols))+1i*randn(size(qamSymbols)));
    rx_I = real(rx)*sqrt(10); rx_Q = imag(rx)*sqrt(10);

    Idec = zeros(size(rx_I));
    Idec(rx_I < -2) = -3; Idec(rx_I>=-2 & rx_I<0) = -1;
    Idec(rx_I>=0 & rx_I<2) = 1; Idec(rx_I>=2) = 3;

    Qdec = zeros(size(rx_Q));
    Qdec(rx_Q < -2) = -3; Qdec(rx_Q>=-2 & rx_Q<0) = -1;
    Qdec(rx_Q>=0 & rx_Q<2) = 1; Qdec(rx_Q>=2) = 3;

    [~, Ii] = ismember(Idec, levelMap); Ii = Ii-1;
    [~, Qi] = ismember(Qdec, levelMap); Qi = Qi-1;

    rxIbits = [floor(Ii/2) mod(Ii,2)];
    rxQbits = [floor(Qi/2) mod(Qi,2)];

    rxBits = zeros(length(qamSymbols), 4);
    rxBits(:,1:2) = rxIbits; rxBits(:,3:4) = rxQbits;
    rxBits = reshape(rxBits.', 1, []);
    rxBits = rxBits(1:numBits);
    BER_16QAM(k) = sum(rxBits ~= dataBits) / numBits;

    fprintf('SNR=%2d dB | BPSK=%.5f | QPSK=%.5f | 16QAM=%.5f\n', ...
        SNR_dB, BER_BPSK(k), BER_QPSK(k), BER_16QAM(k));
end

figure;
semilogy(SNR_range, BER_BPSK, '-o', 'LineWidth', 1.6); hold on;
semilogy(SNR_range, BER_QPSK, '-s', 'LineWidth', 1.6);
semilogy(SNR_range, BER_16QAM, '-^', 'LineWidth', 1.6);
grid on; xlabel('SNR (dB)'); ylabel('Bit Error Rate (BER)');
title('BER vs SNR: BPSK vs QPSK vs 16-QAM');
legend('BPSK','QPSK','16-QAM','Location','southwest');

saveas(gcf, 'BER_vs_SNR.png');
