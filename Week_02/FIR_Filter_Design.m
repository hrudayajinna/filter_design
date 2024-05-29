% Digital Filter Design Parameters
filterOrder = 10;          % Filter order
cutOffFreqLead = 0.1;      % Cutoff frequency for leading side filter
cutOffFreqLag = 0.2;       % Cutoff frequency for lagging side filter

% Generate sample data (replace with your actual received signal)
Fs = 1000;                % Sampling frequency
t = 0:1/Fs:1;             % Time vector
receivedSignal = sin(2*pi*10*t);  % Example sinusoidal signal

% Design digital filters
leadFilter = fir1(filterOrder, cutOffFreqLead);  % Leading side filter
lagFilter = fir1(filterOrder, cutOffFreqLag);    % Lagging side filter

% Apply digital filters to the received signal
filteredSignalLead = filter(leadFilter, 1, receivedSignal);
filteredSignalLag = filter(lagFilter, 1, receivedSignal);

% Subtract the lagging side filtered signal from the leading side filtered signal
phaseDifference = filteredSignalLead - filteredSignalLag;

% Apply thresholding or other methods to convert phaseDifference to JK flip flop inputs
threshold = 0.2;  % Example threshold value, adjust as needed

% JK flip flop implementation
currentOutput = 0;    % Initial output state of the JK flip flop
previousOutput = currentOutput; % Previous output state of the JK flip flop

for i = 1:length(phaseDifference)
    J = (phaseDifference(i) > threshold);
    K = (phaseDifference(i) < -threshold);
    
    if J && ~K
        currentOutput = 1;  % Set output to 1
        break;              % Exit the loop if condition is met
    elseif ~J && K
        currentOutput = 0;  % Set output to 0
    elseif J && K
        currentOutput = ~currentOutput;  % Toggle output state
    end
    
    previousOutput = currentOutput;     % Store the current output state
end

% Display the final output state of the JK flip flop
disp(currentOutput);
