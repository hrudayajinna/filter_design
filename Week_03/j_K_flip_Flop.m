clear all;
clc;

% Input parameters
clockSignal = [1 0 1 0 1]; % Input clock signal
receivedSignal = [0 1 0 1 0 ]; % Received signal

% Define parameters
dataRate = 25000; % Data rate in Hz
samplingRateFactor = 50; % Sampling rate as a factor of data rate

% Calculate sampling rate
samplingRate = dataRate * samplingRateFactor;

% Calculate the number of clock cycles
numClockCycles = length(clockSignal);

% Calculate the number of samples
numSamples = numClockCycles * samplingRateFactor;

% Initialize variables
J = zeros(1, numSamples); % J input
K = zeros(1, numSamples); % K input
Q = zeros(1, numSamples); % Output Q
Q_bar = zeros(1, numSamples); % Output Q_bar
phaseDifference = zeros(1, numSamples); % Phase difference

% J-K Flip-Flop operation
for i = 1:numSamples
    % Hold J and K inputs based on input clock signal and received signal
    J(i) = xor(clockSignal(mod(i-1, numClockCycles)+1), receivedSignal(mod(i-1, numClockCycles)+1));
    K(i) = xor(clockSignal(mod(i-1, numClockCycles)+1), ~receivedSignal(mod(i-1, numClockCycles)+1));
    
    % Update Q and Q_bar based on J and K inputs
    if J(i) && ~K(i)
        Q(i+1) = ~Q(i);
        Q_bar(i+1) = Q(i);
    elseif ~J(i) && K(i)
        Q(i+1) = Q(i);
        Q_bar(i+1) = ~Q(i);
    else
        Q(i+1) = Q(i);
        Q_bar(i+1) = Q_bar(i);
    end
    
    % Calculate phase difference
    phaseDifference(i) = xor(Q(i), Q_bar(i));
end

% Plotting the results
figure;
subplot(5, 1, 1);
stem(0:numClockCycles-1, clockSignal);
title('Input Clock Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(5, 1, 2);
stem(0:numClockCycles-1, receivedSignal);
title('Received Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(5, 1, 3);
stem(0:numSamples-1, Q(1:end-1));
title('Q Output');
xlabel('Clock Cycle');
ylabel('Q');

subplot(5, 1, 4);
stem(0:numSamples-1, Q_bar(1:end-1));
title('Q_bar Output');
xlabel('Clock Cycle');
ylabel('Q_bar');

subplot(5, 1, 5);
stem(0:numSamples-1, phaseDifference);
title('Phase Difference');
xlabel('Clock Cycle');
ylabel('Difference');
