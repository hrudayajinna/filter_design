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
%h = fir1(N, Wp_norm, 'low', kaiser(N+1, alpha));
%h = [116, 121, 124, 126, 127, 127, 126, 124, 121, 116];
%h=[7 	,5 ,	1  ,   0 ,	9	,36   , 76   ,112  , 127  , 112,	76,	36 	,9 	,0   ,  1 ,	5, 	7]
% h=[0.0100 ,   0.0400   , 0.0900    ,0.1600  ,  0.2000  ,  0.2000 ,   0.1600    ,0.0900  ,  0.0400   , 0.0100]

%h = [6,0, 13,67,127,127,67,13,0,6];
h=[0    ,49   , 87   ,114   ,127   ,127  , 114   , 87  ,  49     ,0]

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

% Time domain response
num_samples = 1000;  % Number of samples for time domain response

% Generate time vector
t = (0:num_samples-1) / SampleRate;

% Generate input signals
input_signal = randn(1, num_samples);  % Random noise signal
signal_10MHz = sin(2*pi*10e6*t);  % 10 MHz sinusoidal signal
signal_100MHz = sin(2*pi*100e6*t);  % 100 MHz sinusoidal signal

% Mix input signals
mixed_signal =  signal_10MHz + signal_100MHz;

% Apply filter to mixed signal
output_signal = filter(h, 1, mixed_signal);

% Plot input signals
figure;


subplot(4,1,1);
plot(t, signal_10MHz);
xlabel('Time (s)');
ylabel('Amplitude');
title('Input Signal (10 MHz)');

subplot(4,1,2);
plot(t, signal_100MHz);
xlabel('Time (s)');
ylabel('Amplitude');
title('Input Signal (100 MHz)');

subplot(4,1,3);
plot(t, mixed_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Input Signal mixed');

subplot(4,1,4);
plot(t, output_signal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Output signal ');

