clear all;
clc;

% Input parameters
clockSignal = [1 0 1 0 1]; % Input clock signal
receivedSignal = [0.707 0.707 0 0.707 0.707];% Received signal

% Define parameters
dataRate = 100; % Data rate in Hz
samplingRateFactor = 1; % Sampling rate as a factor of data rate

% Calculate sampling rate
samplingRate = dataRate * samplingRateFactor;

% Calculate the number of clock cycles
numClockCycles = length(clockSignal);

% Calculate the number of samples
numSamples = numClockCycles * samplingRateFactor;

% Initialize variables
D = zeros(1, numSamples); % D input
Q = zeros(1, numSamples); % Output Q
Q_bar = zeros(1, numSamples); % Output Q_bar
phaseDifference = zeros(1, numSamples); % Phase difference

% Determine the phase shift between the clock signal and received signal
phaseShift = round(numSamples / 4); % Half of the period for 90-degree phase shift

% D Flip-Flop operation
for i = 1:numSamples
    % Hold D input based on input clock signal and received signal
    D(i) = receivedSignal(mod(i-1 + phaseShift, numClockCycles) + 1);
    
    % Update Q and Q_bar based on D input
    if i > 1
        Q(i) = D(i-1);
        Q_bar(i) = ~D(i-1);
    end
    
    % Calculate phase difference
    if i > 1
        phaseDifference(i) = xor(Q(i), Q_bar(i));
    end
end

% Plotting the results
figure;
title('D Flip-Flop Phase Detector'); % Add figure title
subplot(4, 1, 1);
stem(0:numClockCycles-1, clockSignal);
title('Input Clock Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(4, 1, 2);
stem(0:numClockCycles-1, receivedSignal);
title('Received Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(4, 1, 3);
stem(0:numSamples-2, Q(1:end-1));
title('Q Output');
xlabel('Clock Cycle');
ylabel('Q');

subplot(4, 1, 4);
stem(0:numSamples-2, phaseDifference(1:end-1));
title('Phase Difference');
xlabel('Clock Cycle');
ylabel('Difference');
