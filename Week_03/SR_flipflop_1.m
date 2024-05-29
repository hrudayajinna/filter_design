% Clear the workspace and command window
clear all;
clc;


% Generate the clock signal (original signal)
clockSignal = [1 0 1 0 1];

% Apply 90-degree phase shift to the received signal
receivedSignal = [ 1 0 1 0 1];
shiftedReceivedSignal = apply90DegreePhaseShift(receivedSignal);

% Define parameters
dataRate = 100; % Data rate in Hz
samplingRateFactor = 4; % Sampling rate as a factor of data rate

% Calculate the sampling rate
samplingRate = dataRate * samplingRateFactor;

% Calculate the number of clock cycles
numClockCycles = length(clockSignal);

% Calculate the number of samples
numSamples = numClockCycles * samplingRateFactor;

% Initialize variables
S = zeros(1, numSamples); % Set input
R = zeros(1, numSamples); % Reset input
Q = zeros(1, numSamples); % Output Q
Q_bar = zeros(1, numSamples); % Output Q_bar
phaseDifference = zeros(1, numSamples); % Phase difference

% SR Flip-Flop operation
for i = 1:numSamples
    % Hold S and R inputs based on input clock signal and received signal
    S(i) = xor(clockSignal(mod(i - 1, numClockCycles) + 1), receivedSignal(mod(i - 1, numClockCycles) + 1));
    R(i) = xor(clockSignal(mod(i - 1, numClockCycles) + 1), ~receivedSignal(mod(i - 1, numClockCycles) + 1));
    
    % Update Q and Q_bar based on S and R inputs
    if S(i) && ~R(i)
        Q(i + 1) = 1;
        Q_bar(i + 1) = 0;
    elseif ~S(i) && R(i)
        Q(i + 1) = 0;
        Q_bar(i + 1) = 1;
    else
        Q(i + 1) = Q(i);
        Q_bar(i + 1) = Q_bar(i);
    end
    
    % Calculate phase difference
    phaseDifference(i) = xor(Q(i), Q_bar(i));
end

% Plotting the results
figure;
subplot(5, 1, 1);
stem(0:numClockCycles - 1, clockSignal);
title('Input Clock Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(5, 1, 2);
stem(0:numClockCycles - 1, receivedSignal);
title('Received Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(5, 1, 3);
stem(0:numSamples - 1, Q(1:end - 1));
title('Q Output');
xlabel('Clock Cycle');
ylabel('Q');

subplot(5, 1, 4);
stem(0:numSamples - 1, Q_bar(1:end - 1));
title('Q_bar Output');
xlabel('Clock Cycle');
ylabel('Q_bar');

subplot(5, 1, 5);
stem(0:numSamples - 1, phaseDifference);
title('Phase Difference');
xlabel('Clock Cycle');
ylabel('Difference');
% Define a function to apply a 90-degree phase shift to a signal
function shiftedSignal = apply90DegreePhaseShift(signal)
    shiftedSignal = [signal(end), signal(1:end-1)];
end

