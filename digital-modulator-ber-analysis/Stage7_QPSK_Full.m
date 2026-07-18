%% Stage 7: QPSK Modulation + AWGN + Demodulation + BER
clear; clc; close all;
rng(1);

numBits = 1000;
dataBits = randi([0 1], 1, numBits);

% --- QPSK Modulation ---
if mod(numBits, 2) ~= 0
    dataBits_qpsk = [dataBits 0];
else
    dataBits_qpsk = dataBits;
end

I_bits = dataBits_qpsk(1:2:end);
Q_bits = dataBits_qpsk(2:2:end);

I = 2*I_bits - 1;
Q = 2*Q_bits - 1;
qpskSymbols = (I + 1i*Q) / sqrt(2);   % Normalized energy

disp('First 10 QPSK symbols:');
disp(qpskSymbols(1:10));

SNR_range = 0:2:12;
BER_QPSK = zeros(1, length(SNR_range));

for k = 1:length(SNR_range)
    SNR_dB = SNR_range(k);

    signalPower = mean(abs(qpskSymbols).^2);
    EbN0_linear = 10^(SNR_dB/10);
    Eb = signalPower / 2;     % QPSK: 2 bits per symbol
    N0 = Eb / EbN0_linear;
    noiseVar = N0/2;

    noise = sqrt(noiseVar) * (randn(size(qpskSymbols)) + 1i*randn(size(qpskSymbols)));
    receivedQPSK = qpskSymbols + noise;

    rx_I = real(receivedQPSK) > 0;
    rx_Q = imag(receivedQPSK) > 0;

    receivedBits_qpsk = zeros(1, 2*length(receivedQPSK));
    receivedBits_qpsk(1:2:end) = rx_I;
    receivedBits_qpsk(2:2:end) = rx_Q;
    receivedBits_qpsk = receivedBits_qpsk(1:numBits);

    numErrors = sum(receivedBits_qpsk ~= dataBits);
    BER_QPSK(k) = numErrors / numBits;

    fprintf('SNR = %2d dB -> BER (QPSK) = %.5f\n', SNR_dB, BER_QPSK(k));
end
