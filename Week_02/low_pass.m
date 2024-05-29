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
h = fir1(N, Wp_norm, 'low', kaiser(N+1, alpha));

% Display coefficient values
disp("Filter Coefficients:");
disp(h);
disp("rounded of coefficent vales two two decimals")

precision = 10;  % Precision factor, 100 for two decimal places
rounded_coefficients = round(h * precision) / precision;

disp(rounded_coefficients);

% Assuming you have your filter coefficients stored in a variable called 'filter_coeffs'
non_zero_count = nnz(rounded_coefficients);

fprintf('Number of non-zero coefficient values: %d\n', non_zero_count);
%disp( non_zero_count);
% Assuming you have your filter coefficients stored in a variable called 'filter_coeffs'
non_zero_indices = rounded_coefficients ~= 0;
non_zero_values = rounded_coefficients(non_zero_indices);

% Display the non-zero values
disp('Non-zero coefficient values:');
disp(non_zero_values);


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

