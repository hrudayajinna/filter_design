clc;
close all;
clear all;

% Parameters
DataRate = 20e6;     % Data Rate (Hz)
SampleRate = 700e6;  % Sample Rate (Hz)
Platform = 'VC707';  % Platform

% Calculate normalized frequencies
Wp_norm = 2 * DataRate / SampleRate;

% Filter order calculation
Ap = 0.05;       % Passband Ripple (dB)
Aa = 40;         % Stopband Attenuation (dB)

delta_p = (10^(Ap/20) - 1) / (10^(Ap/20) + 1);
delta_a = 10^(-Aa/20);
A = -20*log10(min(delta_p, delta_a));

if A <= 21
    alpha = 0;
elseif A > 21 && A <= 50
    alpha = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    alpha = 0.1102*(A-8.7);
end

N = ceil((A-8) / (2.285 * Wp_norm));
if mod(N, 2) == 0
    N = N + 1;    % Ensure odd filter order
end

% Filter design
h = [0.090061285574484381544202449276781408116, 0.096503726364102579426962336128781316802,0.101563080660091537010814022323756944388,0.105047698113615153858724227120546856895,0.106824209287706375914872580779046984389,0.106824209287706375914872580779046984389,0.105047698113615153858724227120546856895,0.101563080660091537010814022323756944388,0.096503726364102579426962336128781316802,0.090061285574484381544202449276781408116];


% Display coefficient values
disp("Filter Coefficients:");
disp(h);
disp("Rounded off coefficient values to two decimal places");

precision = 10; 
rounded_coefficients = round(h * precision) / precision;

disp(rounded_coefficients);

% Quantize non-zero coefficients
non_zero_indices = rounded_coefficients ~= 0;
non_zero_values = rounded_coefficients(non_zero_indices);

% Display the non-zero values
disp('Non-zero coefficient values:');
disp(non_zero_values);

% Quantize non-zero coefficients to two decimal places
quantized_values = round(non_zero_values * 100) / 100;

% Display quantized coefficient values
disp('Quantized coefficient values:');
disp(quantized_values);

% Count the number of non-zero coefficients
non_zero_count = nnz(rounded_coefficients);
fprintf('Number of non-zero coefficient values: %d\n', non_zero_count);

% Frequency response
[H, freq] = freqz(quantized_values, 1, 1024, SampleRate);

% Plot magnitude response
figure;
plot(freq / 1e6, abs(H));
xlabel('Frequency (MHz)');
ylabel('Magnitude');
title('Magnitude Response of Low-Pass Filter');

% Plot phase response
figure;
plot(freq / 1e6, angle(H));
xlabel('Frequency (MHz)');
ylabel('Phase');
title('Phase Response of Low-Pass Filter');

range = max(h) - min(h);
interval_size = range / 128;
partition = [min(h) + interval_size : interval_size : max(h)];
codebook = [0:128];

quants = quantiz(h, partition, codebook);

% Get quantized values of non-zero coefficients
non_zero_quantized_values = quants(non_zero_indices);

% Display quantized values of non-zero coefficients
disp('Quantized values of non-zero coefficients:');
disp(non_zero_quantized_values);

save("coefficient_values.mat", "quants");

% Time domain response
num_samples = 1000;  % Number of samples for time domain response
input_signal = randn(1, num_samples);  % Input signal (random noise)

output_signal = filter(non_zero_quantized_values, 1, input_signal);  % Apply filter to input signal

% Frequency response
[H, freq] = freqz(non_zero_quantized_values, 1, 1024, SampleRate);

% Plot magnitude response
figure;
plot(freq / 1e6, abs(H));
xlabel('Frequency (MHz)');
ylabel('Magnitude');
title('Magnitude Response of Low-Pass Filter');

% Time domain response
num_samples = 1000;  % Number of samples for time domain response
input_signal = randn(1, num_samples);  % Input signal (random noise)

output_signal = filter(non_zero_quantized_values, 1, input_signal);  % Apply filter to input signal

% Plot input signal
figure;
t = (0:num_samples-1) / SampleRate;
subplot(2,1,1);
plot(t, input_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Input Signal');

% Plot output signal
subplot(2,1,2);
plot(t, output_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Output Signal');

