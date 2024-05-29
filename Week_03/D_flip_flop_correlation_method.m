clear all;
clc;

% Input parameters
clockSignal = [1 0 1 0 1]; % Input clock signal
receivedSignal = [0 0 1 0 1]; % Received signal with 45-degree phase shift

% Determine the length of the shorter array
numSamples = min(length(clockSignal), length(receivedSignal));

% Initialize variables
Q = zeros(1, numSamples+1); % Output Q
Q_bar = zeros(1, numSamples+1); % Output Q'
D = zeros(1, numSamples); % D input
leadingFilterOutput = zeros(1, numSamples); % Leading edge filter output
laggingFilterOutput = zeros(1, numSamples); % Lagging edge filter output

% D Flip-Flop operation
for i = 1:numSamples
    % Hold D input based on input clock signal and received signal
    D(i) = xor(clockSignal(i), receivedSignal(i));
    
    % Update Q and Q' based on D input
    Q(i+1) = D(i);
    Q_bar(i+1) = ~D(i);
    
    % Leading edge filter
    if i > 1
        leadingFilterOutput(i) = Q(i) - Q(i-1);
    end
    
    % Lagging edge filter
    if i < numSamples
        laggingFilterOutput(i) = Q(i) - Q(i+1);
    end
end

% Initialize phase error calculation variables
referencePhase = [0 0 0 1 1]; % Reference phase sequence
phaseError = zeros(1, numSamples); % Phase error

% Calculate phase error using cross-correlation method
for i = 1:numSamples
    % Calculate the cross-correlation of the reference phase and the measured phase
    crossCorr = xcorr(referencePhase, Q(1:i));
    phaseError(i) = crossCorr(length(referencePhase)-1 + i);
end

% Plot the results
figure;
subplot(6, 1, 1);
stem(0:length(clockSignal)-1, clockSignal);
title('Input Clock Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(6, 1, 2);
stem(0:length(receivedSignal)-1, receivedSignal);
title('Received Signal');
xlabel('Clock Cycle');
ylabel('Signal');

subplot(6, 1, 3);
stem(0:numSamples, Q);
title('Q Output');
xlabel('Clock Cycle');
ylabel('Q');

subplot(6, 1, 4);
stem(0:numSamples, Q_bar);
title('Q_bar Output');
xlabel('Clock Cycle');
ylabel('Q_bar');

subplot(6, 1, 5);
stem(0:numSamples-1, leadingFilterOutput);
title('Leading Edge Filter Output');
xlabel('Clock Cycle');
ylabel('Filter Output');

subplot(6, 1, 6);
stem(0:numSamples-1, laggingFilterOutput);
title('Lagging Edge Filter Output');
xlabel('Clock Cycle');
ylabel('Filter Output');

% Find minimum phase error index
[minPhaseError, minPhaseErrorIndex] = min(phaseError);

% Plot phase error
figure;
stem(0:numSamples-1, phaseError);
hold on;
stem(minPhaseErrorIndex-1, minPhaseError, 'r', 'MarkerFaceColor', 'r');
hold off;
title('Phase Error');
xlabel('Clock Cycle');
ylabel('Error');
