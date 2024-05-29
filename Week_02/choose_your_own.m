clc;
close all;
clear all;

% Parameters
DataRate = 20e6;     % Data Rate (Hz)
SampleRate = 700e6;  % Sample Rate (Hz)
Platform = 'VC707';  % Platform

% Filter order
N = 64;  % Replace with your desired filter order

% Calculate normalized cutoff frequency
Wp_norm = 2 * DataRate / SampleRate;

% Filter design
h = fir1(N, Wp_norm, 'low');

% Display coefficient values
disp("Filter Coefficients:");
disp(h);

disp("rounded of coefficent vales two two decimals")

precision = 100;  % Precision factor, 100 for two decimal places
rounded_coefficients = round(h * precision) / precision;

disp(rounded_coefficients);



% Frequency response
[H, freq] = freqz(h, 1, 1024, SampleRate);

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

