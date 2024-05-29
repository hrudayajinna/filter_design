 clear all;
clc;

% Input parameters
clockSignal = [1 0 1 0 1]; % Input clock signal
receivedSignal = [1 0 1 0 1]; % Received signal

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
S = zeros(1, numSamples); % Set input
R = zeros(1, numSamples); % Reset input
Q = zeros(1, numSamples); % Output Q

% SR Flip-Flop operation
for i = 1:numSamples
    % Hold S and R inputs based on input clock signal and received signal
    S(i) = xor(clockSignal(mod(i-1, numClockCycles)+1), receivedSignal(mod(i-1, numClockCycles)+1));
    R(i) = xor(clockSignal(mod(i-1, numClockCycles)+1), ~receivedSignal(mod(i-1, numClockCycles)+1));
    
    % Update Q based on S and R inputs
    if S(i) && ~R(i)
        Q(i+1) = 1;
    elseif ~S(i) && R(i)
        Q(i+1) = 0;
    end
end

% Plotting the results
figure;
subplot(3, 1, 1);
stem(0:numClockCycles-1, clockSignal);
title('Input Clock Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(3, 1, 2);
stem(0:numClockCycles-1, receivedSignal);
title('Received Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(3, 1, 3);
stem(0:numSamples-1, Q(1:end-1));
title('Q Output');
xlabel('Clock Cycle');
ylabel('Q');
