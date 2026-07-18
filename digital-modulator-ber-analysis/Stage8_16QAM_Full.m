%% Stage 8: 16-QAM Modulation + AWGN + Demodulation + BER
clear; clc; close all;
rng(1);

numBits = 1000;
dataBits = randi([0 1], 1, numBits);

% --- Prepare bits (must be multiple of 4) ---
if mod(numBits, 4) ~= 0
    padLen = 4 - mod(numBits, 4);
    dataBits_qam = [dataBits zeros(1, padLen)];
else
    dataBits_qam = dataBits;
end

bitGroups = reshape(dataBits_qam, 4, []).';

Ibits = bitGroups(:, 1:2);
Qbits = bitGroups(:, 3:4);

levelMap = [-3 -1 3 1];     % Gray-coded level mapping
grayIndex = Ibits(:,1)*2 + Ibits(:,2) + 1;
Ilevels = levelMap(grayIndex).';

grayIndex = Qbits(:,1)*2 + Qbits(:,2) + 1;
Qlevels = levelMap(grayIndex).';

qamSymbols = (Ilevels + 1i*Qlevels) / sqrt(10);   % Normalized energy

disp('First 10 16-QAM symbols:');
disp(qamSymbols(1:10));

SNR_range = 0:2:12;
BER_16QAM = zeros(1, length(SNR_range));

for k = 1:length(SNR_range)
    SNR_dB = SNR_range(k);

    signalPower = mean(abs(qamSymbols).^2);
    EbN0_linear = 10^(SNR_dB/10);
    Eb = signalPower / 4;     % 16-QAM: 4 bits per symbol
    N0 = Eb / EbN0_linear;
    noiseVar = N0/2;

    noise = sqrt(noiseVar) * (randn(size(qamSymbols)) + 1i*randn(size(qamSymbols)));
    receivedQAM = qamSymbols + noise;

    rx_I = real(receivedQAM) * sqrt(10);
    rx_Q = imag(receivedQAM) * sqrt(10);

    Idecided = zeros(size(rx_I));
    Idecided(rx_I < -2)             = -3;
    Idecided(rx_I >= -2 & rx_I < 0) = -1;
    Idecided(rx_I >= 0 & rx_I < 2)  = 1;
    Idecided(rx_I >= 2)              = 3;

    Qdecided = zeros(size(rx_Q));
    Qdecided(rx_Q < -2)             = -3;
    Qdecided(rx_Q >= -2 & rx_Q < 0) = -1;
    Qdecided(rx_Q >= 0 & rx_Q < 2)  = 1;
    Qdecided(rx_Q >= 2)              = 3;

    [~, Iidx] = ismember(Idecided, levelMap); Iidx = Iidx - 1;
    [~, Qidx] = ismember(Qdecided, levelMap); Qidx = Qidx - 1;

    rxIbits = [floor(Iidx/2) mod(Iidx,2)];
    rxQbits = [floor(Qidx/2) mod(Qidx,2)];

    receivedBits_qam = zeros(length(qamSymbols), 4);
    receivedBits_qam(:,1:2) = rxIbits;
    receivedBits_qam(:,3:4) = rxQbits;
    receivedBits_qam = reshape(receivedBits_qam.', 1, []);
    receivedBits_qam = receivedBits_qam(1:numBits);

    numErrors = sum(receivedBits_qam ~= dataBits);
    BER_16QAM(k) = numErrors / numBits;

    fprintf('SNR = %2d dB -> BER (16-QAM) = %.5f\n', SNR_dB, BER_16QAM(k));
end
