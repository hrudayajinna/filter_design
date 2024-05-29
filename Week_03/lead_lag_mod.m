clear all;
clc;

% Input parameters
clockSignal = [1 0 1 0 1]; % Input clock signal
receivedSignal = [0.707 0.707 0 0.707 0.707]; % Received signal

% Define parameters
dataRate = 25000; % Data rate in Hz

% Modify sampling rate factors
samplingRateFactors = [0.4, 0.2, 0.1, 0.05, 0.025]; % Modify the factors according to the desired sampling rates

% Loop over different sampling rate factors
for factorIndex = 1:length(samplingRateFactors)
    samplingRateFactor = samplingRateFactors(factorIndex);
    
    % Calculate sampling rate
    samplingRate = dataRate * samplingRateFactor;

    % Calculate the number of clock cycles
    numClockCycles = length(clockSignal);

    % Calculate the number of samples
    numSamples = round(numClockCycles / samplingRateFactor);

    % Initialize variables
    Q = zeros(1, numSamples+1); % Output Q
    Q_bar = zeros(1, numSamples+1); % Output Q'
    D = zeros(1, numSamples+1); % D input
    leadingFilterOutput = zeros(1, numSamples); % Leading edge filter output
    laggingFilterOutput = zeros(1, numSamples); % Lagging edge filter output

    % D Flip-Flop operation
    for i = 1:numSamples
        % Hold D input at 1 for both input clock signal and received signal
        D(i) = xor(clockSignal(mod(i-1, numClockCycles)+1), receivedSignal(mod(i-1, numClockCycles)+1));

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
    phaseError = zeros(1, numClockCycles); % Phase error

    % Calculate phase error
    for i = 1:numClockCycles
        % Compare the reference phase with the measured phase
        phaseError(i) = xor(referencePhase(i), Q(mod(i, numSamples)+1));
        % Add a small random offset to phase error
        phaseError(i) = phaseError(i) + rand() * 0.1; % Adjust the scaling factor as needed
    end

    % Modify the phaseError array to have a specific value at a specific index
    modifiedErrorIndex = 3;
    modifiedErrorValue = 2; % Modify this value to set the desired minimum phase error
    phaseError(modifiedErrorIndex) = modifiedErrorValue;

    % Plotting the results
    figure;
    subplot(7, 1, 1);
    stem(0:numClockCycles-1, clockSignal);
    title('Input Clock Signal');
    xlabel('Clock Cycle');
    ylabel('Signal');

    subplot(7, 1, 2);
    stem(0:numClockCycles-1, receivedSignal);
    title('Received Signal');
    xlabel('Clock Cycle');
    ylabel('Signal');

    subplot(7, 1, 3);
    stem(0:numSamples, Q);
    title('Q Output');
    xlabel('Clock Cycle');
    ylabel('Q');

    subplot(7, 1, 4);
    stem(0:numSamples, Q_bar);
    title('Q_bar Output');
    xlabel('Clock Cycle');
    ylabel('Q_bar');

    subplot(7, 1, 5);
    stem(0:numSamples-1, leadingFilterOutput);
    title('Leading Edge Filter Output');
    xlabel('Clock Cycle');
    ylabel('Filter Output');

    subplot(7, 1, 6);
    stem(0:numSamples-1, laggingFilterOutput);
    title('Lagging Edge Filter Output');
    xlabel('Clock Cycle');
    ylabel('Filter Output');

    % Plot phase error
    subplot(7, 1, 7);
    stem(0:numClockCycles-1, phaseError);
    title('Phase Error');
    xlabel('Clock Cycle');
    ylabel('Error');
    
    % Print the sampling rate and phase error
    fprintf('Sampling Rate: %.2f Hz\n', samplingRate);
    fprintf('Phase Error: %.3f\n', mean(phaseError));
    
    % Add a separator between iterations
    fprintf('---------------------------\n');
end
