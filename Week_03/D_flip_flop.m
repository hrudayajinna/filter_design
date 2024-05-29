clear all;
clc;

% Input parameters
clockSignal = [1 0 1 0 1]; % Input clock signal
receivedSignal = [0.707 0.707 0 0.707 0.707]; % Received signal

% Define parameters
dataRate = 500000000; % Data rate in Hz

% Modify sampling rate factors
samplingRateFactors = [100, 200, 300, 400, 500]; % Modify the factors according to the desired sampling rates

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
    referencePhase = [0 0 1 1 0]; % Reference phase sequence
    phaseError = zeros(1, numClockCycles); % Phase error

    % Calculate phase error
    for i = 1:numSamples
        % Compare the reference phase with the measured phase
        phaseError(i) = xor(referencePhase(mod(i-1, numClockCycles)+1), Q(mod(i, numSamples)+1));
    end

    % Calculate mean phase error
    meanPhaseError = mean(phaseError);

    % Print the sampling rate and phase error
    fprintf('Sampling Rate: %.2f Hz\n', samplingRate);
    fprintf('Phase Error: %.3f\n', meanPhaseError);
    
    % Add a separator between iterations
    fprintf('---------------------------\n');
end
