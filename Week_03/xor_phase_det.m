clear all;
clc;

% Define input signals
referenceSignal = [0 1 0 1 0]; % Reference signal
receivedSignal = [1 0 1 0 1]; % Received signal

% Perform phase detection using XOR operation
phaseError = xor(referenceSignal, receivedSignal);
% Calculate gain as the average value of the phase error
gain = mean(phaseError);

% Display gain
disp('Gain:');
disp(gain);

% Plotting the signals
figure;

subplot(3, 1, 1);
stem(0:length(referenceSignal)-1, referenceSignal);
title('Reference Signal');
xlabel('Sample Index');
ylabel('Signal');

subplot(3, 1, 2);
stem(0:length(receivedSignal)-1, receivedSignal);
title('Received Signal');
xlabel('Sample Index');
ylabel('Signal');

subplot(3, 1, 3);
stem(0:length(phaseError)-1, phaseError);
title('Phase Error');
xlabel('Sample Index');
ylabel('Error');

% Display phase error
disp('Phase Error:');
disp(phaseError);
