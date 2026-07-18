%% Stage 11: Spectrum Comparison (FFT)
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

Fs = 1000;   % symbolic sample rate for display purposes

figure;

subplot(3,1,1);
sig = bpskSymbols(1:1000);
N = length(sig); f = (-N/2:N/2-1)*(Fs/N);
S = fftshift(fft(sig));
plot(f, abs(S)/N);
title('BPSK Spectrum'); xlabel('Frequency (Hz)'); ylabel('|X(f)|'); grid on;

subplot(3,1,2);
sig = qpskSymbols(1:1000);
N = length(sig); f = (-N/2:N/2-1)*(Fs/N);
S = fftshift(fft(sig));
plot(f, abs(S)/N);
title('QPSK Spectrum'); xlabel('Frequency (Hz)'); ylabel('|X(f)|'); grid on;

subplot(3,1,3);
sig = qamSymbols(1:1000);
N = length(sig); f = (-N/2:N/2-1)*(Fs/N);
S = fftshift(fft(sig));
plot(f, abs(S)/N);
title('16-QAM Spectrum'); xlabel('Frequency (Hz)'); ylabel('|X(f)|'); grid on;

saveas(gcf, 'Spectrum_Comparison.png');
